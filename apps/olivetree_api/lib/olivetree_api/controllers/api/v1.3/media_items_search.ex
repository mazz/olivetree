defmodule OlivetreeApi.MediaItemsSearch do
  import Ecto.Query

  require Logger

  def run(query, search_string) do
    _run(query, normalize(search_string))
  end

  defmacro matching_media_items_and_score(search_string) do
    quote do
      fragment(
        """
        SELECT media_items_search.id AS id,
        ts_rank(
          media_items_search.document, plainto_tsquery(unaccent(?))
        ) AS score
        FROM media_items_search
        WHERE media_items_search.document @@ plainto_tsquery(unaccent(?))
        OR media_items_search.localizedname ILIKE ?
        """,
        ^unquote(search_string),
        ^unquote(search_string),
        ^"%#{unquote(search_string)}%"
      )
    end
  end

  defp _run(query, ""), do: query
  defp _run(query, search_string) do
    from media_item in query,
      join: id_and_score in matching_media_items_and_score(search_string),
      on: id_and_score.id == media_item.id,
      order_by: [desc: id_and_score.score]
  end

  def normalize(search_string) do
    search_string
    |> String.downcase
    |> String.replace(~r/\n/, " ")
    |> String.replace(~r/\t/, " ")
    |> String.replace(~r/\s{2,}/, " ")
    |> String.trim
    |> normalize_bible_book_abbreviations()
  end

  def normalize_bible_book_abbreviations(search_string) do

    no_blanks_in_abbrev_search_string = replace_and_remove_blanks_from_numbered_books(search_string)
    # |> String.split(" ")
    # expanded_book_name(book_map, search_string)
    no_blanks_in_abbrev_search_string
    ## returns an array with matched fullname books at the correct index
    |> matched_books()
    ## convert the maps into a single string of the book name
    |>  Enum.map(fn(x) ->
      x["book"]
    end)
    ## zip the search string as array(book abbreviations no gaps) and the array of found full book names
    |> Enum.zip(String.split(no_blanks_in_abbrev_search_string, " "))
    ## map the tuples to the final array
    |> Enum.map(fn(x) ->
      result = if elem(x, 0) == nil do
        # if the tuple contains nil, return RHS: the non-book search term
        elem(x, 1)
      else
        # if the tuple doesn't contain a nil, return the LHS(full book name)
        elem(x, 0)
      end
    end)
    |> Enum.join(" ")
  end

  defp replace_and_remove_blanks_from_numbered_books(search_string) do
    Regex.replace(~r{([1-3]\s*w*[a-zA-Z]\w*)}, search_string, fn _, x -> "#{String.replace(x, " ", "")}" end)
    # Regex.split(~r{[1-3]\s*w*[a-zA-Z]\w*}, search_string, include_captures: true, trim: true)
  end

  # IO.inspect(Enum.find(packed_list, fn x -> search in elem(x, 1) end))

  defp matched_books(search_string) do
    IO.inspect(search_string)
    ## WORKS, returns an array with matched books at the correct index
    ## and nil where there is no match
    Enum.map(String.split(search_string, " "), fn(y) ->
      # TODO: use Enum.find() instead of list compreh.
      Enum.find(bible(), fn(x) -> y in x["abbreviations"] end)
    end)
  end

  def bible() do
    [
      %{"book" => "1 chronicles", "abbreviations" => ["1 chr", "1 chr", "1 ch", "1chr", "1ch", "1chronicles"]},
    %{"book" => "1 corinthians", "abbreviations" => ["1co", "1cr", "1cor", "1 cor", "1 co", "1 cr", "1corinthians"]},
    %{"book" => "1 john", "abbreviations" => ["1 jn", "1 jhn", "1jhn", "1 j", "1j", "1jn", "1john"]},
    %{"book" => "1 kings", "abbreviations" => ["1kings", "1 kgs", "1kgs", "1 kin", "1kin", "1 ki", "1ki", "1k", "1kings"]},
    %{"book" => "1 peter", "abbreviations" => ["1 pet", "1 pe", "1 pt", "1 p", "1pet", "1pe", "1pt", "1p", "1peter"]},
    %{"book" => "1 samuel", "abbreviations" => ["1 sam", "1 sm", "1 sa", "1 s", "1sam", "1sm", "1sa", "1s", "1samuel"]},
    %{"book" => "1 thessalonians", "abbreviations" => ["1 thess", "1 thes", "1 th", "1 thesalonians", "1 ths", "1thess", "1thes", "1th", "1thesalonians", "1ths", "1thessalonians"]},
    %{"book" => "1 timothy", "abbreviations" => ["1 tim", "1 ti", "1 tm", "1tim", "1ti", "1tm", "1timothy"]},
    %{"book" => "2 chronicles", "abbreviations" => ["2 chr", "2 ch", "2 chron", "2chr", "2ch", "2chron", "2chronicles"]},
    %{"book" => "2 corinthians", "abbreviations" => ["2co", "2cr", "2cor", "2 cor", "2 co", "2 cr"]},
    %{"book" => "2 john", "abbreviations" => ["2 jn", "2 jhn", "2jhn", "2 j", "2j", "2jn", "2john", "2corinthians"]},
    %{"book" => "2 kings", "abbreviations" => ["2 kgs", "2 kin", "2 ki", "2kings", "2kgs", "2kin", "2ki", "2kings"]},
    %{"book" => "2 peter", "abbreviations" => ["2 pet", "2 pe", "2 pt", "2 p", "2pet", "2pe", "2pt", "2p", "2peter"]},
    %{"book" => "2 samuel", "abbreviations" => ["2 sam", "2 sm", "2 sa", "2 s", "2sam", "2sm", "2sa", "2s", "2samuel"]},
    %{"book" => "2 thessalonians", "abbreviations" => ["2 thess", "2 thes", "2 th", "2 thesalonians", "2 ths", "2thess", "2thes", "2th", "2thesalonians", "2ths", "2thessalonians"]},
    %{"book" => "2 timothy", "abbreviations" => ["2 tim", "2 ti", "2 tm", "2tim", "2ti", "2tm","2timothy"]},
    %{"book" => "3 john", "abbreviations" => ["3 jn", "3 jhn", "3jhn", "3 j", "3j", "3jn", "3john"]},
    %{"book" => "acts", "abbreviations" => ["ac", "act"]},
    %{"book" => "amos", "abbreviations" => [ "am", "ams"]},
    %{"book" => "colossians", "abbreviations" => ["col", "co", "cl", "colosians"]},
    %{"book" => "daniel", "abbreviations" => ["dan", "da", "dn", "dnl"]},
    %{"book" => "deuteronomy", "abbreviations" => ["deut", "de", "dt"]},
    %{"book" => "ecclesiastes", "abbreviations" => ["eccl", "eccles", "eccle", "ecc", "ec"]},
    %{"book" => "ephesians", "abbreviations" => ["ep", "ef", "eph", "ephes"]},
    %{"book" => "esther", "abbreviations" => ["esth", "est", "es"]},
    %{"book" => "exodus", "abbreviations" => ["ex", "exod"]},
    %{"book" => "ezekiel", "abbreviations" => ["ezek", "eze", "ezk"]},
    %{"book" => "ezra", "abbreviations" => ["ezra", "ezr", "ez"]},
    %{"book" => "galatians", "abbreviations" => ["gal", "ga", "gl"]},
    %{"book" => "genesis", "abbreviations" => ["gen", "ge", "gn"]},
    %{"book" => "habakkuk", "abbreviations" => ["hab", "hk"]},
    %{"book" => "haggai", "abbreviations" => ["hag", "hg"]},
    %{"book" => "hebrews", "abbreviations" => ["he", "heb", "hb", "hebr"]},
    %{"book" => "hosea", "abbreviations" => ["hos", "ho"]},
    %{"book" => "isaiah", "abbreviations" => ["isa", "is"]},
    %{"book" => "james", "abbreviations" => ["jas", "jm", "jam"]},
    %{"book" => "jeremiah", "abbreviations" => ["jer", "je", "jr"]},
    %{"book" => "job", "abbreviations" => ["job", "jb"]},
    %{"book" => "joel", "abbreviations" => ["joel", "jl", "jol"]},
    %{"book" => "john", "abbreviations" => ["jn", "jhn", "jo"]},
    %{"book" => "jonah", "abbreviations" => ["jon", "jnh"]},
    %{"book" => "joshua", "abbreviations" => ["josh", "jos", "jsh"]},
    %{"book" => "jude", "abbreviations" => ["jude", "jud", "jd"]},
    %{"book" => "judges", "abbreviations" => ["judg", "jdg", "jg", "jdgs", "jud"]},
    %{"book" => "lamentations", "abbreviations" => ["lam", "la"]},
    %{"book" => "leviticus", "abbreviations" => ["lev", "le", "lv", "levit", "lvtcs"]},
    %{"book" => "luke", "abbreviations" => ["lk", "luk", "lu"]},
    %{"book" => "malachi", "abbreviations" => ["mal", "ml","mlch"]},
    %{"book" => "mark", "abbreviations" => ["mk", "mar", "mr", "mrk"]},
    %{"book" => "matthew", "abbreviations" => ["mt", "mat", "matt"]},
    %{"book" => "micah", "abbreviations" => ["mic", "mi", "mc", "mch"]},
    %{"book" => "nahum", "abbreviations" => ["na", "nh", "nhm"]},
    %{"book" => "nehemiah", "abbreviations" => ["neh", "ne", "nhmh"]},
    %{"book" => "numbers", "abbreviations" => ["num", "nu", "nm", "nb", "nmbrs"]},
    %{"book" => "obadiah", "abbreviations" => [ "ob", "obah", "obd", "obdh"]},
    %{"book" => "philemon", "abbreviations" => ["phlemon", "philem", "phm", "pm"]},
    %{"book" => "philippians", "abbreviations" => ["philipians", "phil", "php", "pp", "phl", "ph"]},
    %{"book" => "proverbs", "abbreviations" => ["prov", "pro", "prv", "pr", "pvb", "pvbs"]},
    %{"book" => "psalms", "abbreviations" => ["ps", "psalm", "pslm", "psa", "psm"]},
    %{"book" => "revelation", "abbreviations" => ["rev", "rv", "re", "apo", "apoc", "apocalypse"]},
    %{"book" => "romans", "abbreviations" => ["rom", "ro", "rm", "rmns"]},
    %{"book" => "ruth", "abbreviations" => ["rth", "ru"]},
    %{"book" => "song of solomon", "abbreviations" => ["song", "ss", "so", "sos"]},
    %{"book" => "titus", "abbreviations" => ["ti", "tit", "tits", "tts"]},
    %{"book" => "zechariah", "abbreviations" => ["zech", "zec", "zc"]},
    %{"book" => "zephaniah", "abbreviations" => ["zeph", "zep", "zp"]}
  ]
  end

  # IO.inspect(Enum.find(packed_list, fn x -> "1 Chr" in elem(x, 1) end))

end

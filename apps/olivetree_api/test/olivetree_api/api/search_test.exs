defmodule OlivetreeApi.SearchTest do
  use OlivetreeApi.ConnCase

  alias OlivetreeApi.MediaItemsSearch

  require Logger

  setup do
    %{bible: MediaItemsSearch.bible()}
  end

  test "convert bible abbreviation", %{bible: bible} do
    search_string = "1 chr anderson 1 chr test amos 3 john 2john 2j 2 j 1cor"

    MediaItemsSearch.normalize_bible_book_abbreviations(search_string)
    |> IO.inspect

    # ## Remove blanks from numbered books
    # no_blanks_in_abbrev_search_string = replace_and_remove_blanks_from_numbered_books(search_string)
    # # |> String.split(" ")
    # # expanded_book_name(book_map, search_string)
    # no_blanks_in_abbrev_search_string
    # ## returns an array with matched fullname books at the correct index
    # |> matched_books(bible)
    # ## convert the maps into a single string of the book name
    # |>  Enum.map(fn(x) ->
    #   x["book"]
    # end)
    # ## zip the search string as array(book abbreviations no gaps) and the array of found full book names
    # |> Enum.zip(String.split(no_blanks_in_abbrev_search_string, " "))
    # ## map the tuples to the final array
    # |> Enum.map(fn(x) ->
    #   result = if elem(x, 0) == nil do
    #     # if the tuple contains nil, return RHS: the non-book search term
    #     elem(x, 1)
    #   else
    #     # if the tuple doesn't contain a nil, return the LHS(full book name)
    #     elem(x, 0)
    #   end
    # end)
    # |> Enum.join(" ")
    # |> IO.inspect
    # |> swap_in_normalized_book_names(book_map)
    # |> remove_blanks()
    # |> IO.inspect
    # coalesce_number_and_book(search_string)
    # |> replace_segmented_with_coalesced(search_string)
    # |> IO.inspect

    # IO.inspect(expanded_book_name(book_map, search_string))


    # Logger.info("joined: #{joined}")
    # for  {k, v}  <- MediaItemsSearch.abbreviations()  do
    #   search_string = "Colossians"
    #   # search_string =~ abbrev |> String.downcase do
    #   downcased_abbrev = k |> String.downcase
    #   if Regex.match?( ~r/\b#{downcased_abbrev}\b/ , search_string) do
    #     Logger.info("found #{downcased_abbrev} for #{v}")
    #     new_search_string = Regex.replace(~r/\b#{v}\b/, search_string, k)
    #     Logger.info("new_search_string #{new_search_string}")
    #   end
    # end
  end

  defp replace_and_remove_blanks_from_numbered_books(search_string) do
    Regex.replace(~r{([1-3]\s*w*[a-zA-Z]\w*)}, search_string, fn _, x -> "#{String.replace(x, " ", "")}" end)
    # Regex.split(~r{[1-3]\s*w*[a-zA-Z]\w*}, search_string, include_captures: true, trim: true)
  end

  # IO.inspect(Enum.find(packed_list, fn x -> search in elem(x, 1) end))

  defp matched_books(search_string, bible) do
    IO.inspect(search_string)
    ## WORKS, returns an array with matched books at the correct index
    ## and nil where there is no match
    Enum.map(String.split(search_string, " "), fn(y) ->
      Enum.find(bible, fn(x) -> y in x["abbreviations"] end)
    end)

    ## WORKS but does triplicate
    # Enum.map(String.split(search_string, " "), fn(x) ->
    #   # TODO: use Enum.find() instead of list compreh.
    #   for %{"abbreviations" => abbreviations} = elem <- bible do
    #     IO.inspect(x)
    #     if x in abbreviations do
    #       elem["book"]
    #     else
    #       x
    #     end
    #     # result
    #   end
    # end)

    ## WORKS but returns entire row match + empty on non-match
    # Enum.map(String.split(search_string, " "), fn(x) ->
    #   for %{"abbreviations" => abbreviations} = elem <- bible,
    #   x in abbreviations, do: elem["book"]
    # end)

    # |> IO.inspect
    # Enum.map(search_list, fn(x) ->
    #   Enum.find(book_map, fn(y) -> end)
    # end)
    # Regex.replace(~r{(\w*[0-9a-zA-Z]\w*)}, search_string, fn _, x -> "[#{x}]" end)
    # Enum.find(book_map, fn x -> search_string in elem(x, 1) end)
  end
end


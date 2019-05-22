defmodule Olivetree.Content do
  @moduledoc """
  The Content context.
  """

  import Ecto.Query, warn: false
  alias DB.Repo

  alias DB.Schema.Book

  @doc """
  Returns the list of book.

  ## Examples

      iex> list_book()
      [%Book{}, ...]

  """
  def list_book do
    Repo.all(Book)
  end

  @doc """
  Gets a single book.

  Raises `Ecto.NoResultsError` if the Book does not exist.

  ## Examples

      iex> get_book!(123)
      %Book{}

      iex> get_book!(456)
      ** (Ecto.NoResultsError)

  """
  def get_book!(id), do: Repo.get!(Book, id)

  @doc """
  Creates a book.

  ## Examples

      iex> create_book(%{field: value})
      {:ok, %Book{}}

      iex> create_book(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_book(attrs \\ %{}) do
    %Book{}
    |> Book.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a book.

  ## Examples

      iex> update_book(book, %{field: new_value})
      {:ok, %Book{}}

      iex> update_book(book, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_book(%Book{} = book, attrs) do
    book
    |> Book.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Book.

  ## Examples

      iex> delete_book(book)
      {:ok, %Book{}}

      iex> delete_book(book)
      {:error, %Ecto.Changeset{}}

  """
  def delete_book(%Book{} = book) do
    Repo.delete(book)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking book changes.

  ## Examples

      iex> change_book(book)
      %Ecto.Changeset{source: %Book{}}

  """
  def change_book(%Book{} = book) do
    Book.changeset(book, %{})
  end

  alias DB.Schema.Chapter

  @doc """
  Returns the list of chapter.

  ## Examples

      iex> list_chapter()
      [%Chapter{}, ...]

  """
  def list_chapter do
    Repo.all(Chapter)
  end

  @doc """
  Gets a single chapter.

  Raises `Ecto.NoResultsError` if the Chapter does not exist.

  ## Examples

      iex> get_chapter!(123)
      %Chapter{}

      iex> get_chapter!(456)
      ** (Ecto.NoResultsError)

  """
  def get_chapter!(id), do: Repo.get!(Chapter, id)

  @doc """
  Creates a chapter.

  ## Examples

      iex> create_chapter(%{field: value})
      {:ok, %Chapter{}}

      iex> create_chapter(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_chapter(attrs \\ %{}) do
    %Chapter{}
    |> Chapter.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a chapter.

  ## Examples

      iex> update_chapter(chapter, %{field: new_value})
      {:ok, %Chapter{}}

      iex> update_chapter(chapter, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_chapter(%Chapter{} = chapter, attrs) do
    chapter
    |> Chapter.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Chapter.

  ## Examples

      iex> delete_chapter(chapter)
      {:ok, %Chapter{}}

      iex> delete_chapter(chapter)
      {:error, %Ecto.Changeset{}}

  """
  def delete_chapter(%Chapter{} = chapter) do
    Repo.delete(chapter)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking chapter changes.

  ## Examples

      iex> change_chapter(chapter)
      %Ecto.Changeset{source: %Chapter{}}

  """
  def change_chapter(%Chapter{} = chapter) do
    Chapter.changeset(chapter, %{})
  end

  alias DB.Schema.BookTitle

  @doc """
  Returns the list of booktitle.

  ## Examples

      iex> list_booktitle()
      [%BookTitle{}, ...]

  """
  def list_booktitle do
    Repo.all(BookTitle)
  end

  @doc """
  Gets a single book_title.

  Raises `Ecto.NoResultsError` if the Book title does not exist.

  ## Examples

      iex> get_book_title!(123)
      %BookTitle{}

      iex> get_book_title!(456)
      ** (Ecto.NoResultsError)

  """
  def get_book_title!(id), do: Repo.get!(BookTitle, id)

  @doc """
  Creates a book_title.

  ## Examples

      iex> create_book_title(%{field: value})
      {:ok, %BookTitle{}}

      iex> create_book_title(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_book_title(attrs \\ %{}) do
    %BookTitle{}
    |> BookTitle.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a book_title.

  ## Examples

      iex> update_book_title(book_title, %{field: new_value})
      {:ok, %BookTitle{}}

      iex> update_book_title(book_title, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_book_title(%BookTitle{} = book_title, attrs) do
    book_title
    |> BookTitle.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a BookTitle.

  ## Examples

      iex> delete_book_title(book_title)
      {:ok, %BookTitle{}}

      iex> delete_book_title(book_title)
      {:error, %Ecto.Changeset{}}

  """
  def delete_book_title(%BookTitle{} = book_title) do
    Repo.delete(book_title)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking book_title changes.

  ## Examples

      iex> change_book_title(book_title)
      %Ecto.Changeset{source: %BookTitle{}}

  """
  def change_book_title(%BookTitle{} = book_title) do
    BookTitle.changeset(book_title, %{})
  end

  alias DB.Schema.MediaChapter

  @doc """
  Returns the list of mediachapter.

  ## Examples

      iex> list_mediachapter()
      [%MediaChapter{}, ...]

  """
  def list_mediachapter do
    Repo.all(MediaChapter)
  end

  @doc """
  Gets a single media_chapter.

  Raises `Ecto.NoResultsError` if the Media chapter does not exist.

  ## Examples

      iex> get_media_chapter!(123)
      %MediaChapter{}

      iex> get_media_chapter!(456)
      ** (Ecto.NoResultsError)

  """
  def get_media_chapter!(id), do: Repo.get!(MediaChapter, id)

  @doc """
  Creates a media_chapter.

  ## Examples

      iex> create_media_chapter(%{field: value})
      {:ok, %MediaChapter{}}

      iex> create_media_chapter(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_media_chapter(attrs \\ %{}) do
    %MediaChapter{}
    |> MediaChapter.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a media_chapter.

  ## Examples

      iex> update_media_chapter(media_chapter, %{field: new_value})
      {:ok, %MediaChapter{}}

      iex> update_media_chapter(media_chapter, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_media_chapter(%MediaChapter{} = media_chapter, attrs) do
    media_chapter
    |> MediaChapter.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a MediaChapter.

  ## Examples

      iex> delete_media_chapter(media_chapter)
      {:ok, %MediaChapter{}}

      iex> delete_media_chapter(media_chapter)
      {:error, %Ecto.Changeset{}}

  """
  def delete_media_chapter(%MediaChapter{} = media_chapter) do
    Repo.delete(media_chapter)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking media_chapter changes.

  ## Examples

      iex> change_media_chapter(media_chapter)
      %Ecto.Changeset{source: %MediaChapter{}}

  """
  def change_media_chapter(%MediaChapter{} = media_chapter) do
    MediaChapter.changeset(media_chapter, %{})
  end

  alias DB.Schema.Gospel

  @doc """
  Returns the list of gospel.

  ## Examples

      iex> list_gospel()
      [%Gospel{}, ...]

  """
  def list_gospel do
    Repo.all(Gospel)
  end

  @doc """
  Gets a single gospel.

  Raises `Ecto.NoResultsError` if the Gospel does not exist.

  ## Examples

      iex> get_gospel!(123)
      %Gospel{}

      iex> get_gospel!(456)
      ** (Ecto.NoResultsError)

  """
  def get_gospel!(id), do: Repo.get!(Gospel, id)

  @doc """
  Creates a gospel.

  ## Examples

      iex> create_gospel(%{field: value})
      {:ok, %Gospel{}}

      iex> create_gospel(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_gospel(attrs \\ %{}) do
    %Gospel{}
    |> Gospel.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a gospel.

  ## Examples

      iex> update_gospel(gospel, %{field: new_value})
      {:ok, %Gospel{}}

      iex> update_gospel(gospel, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_gospel(%Gospel{} = gospel, attrs) do
    gospel
    |> Gospel.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Gospel.

  ## Examples

      iex> delete_gospel(gospel)
      {:ok, %Gospel{}}

      iex> delete_gospel(gospel)
      {:error, %Ecto.Changeset{}}

  """
  def delete_gospel(%Gospel{} = gospel) do
    Repo.delete(gospel)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking gospel changes.

  ## Examples

      iex> change_gospel(gospel)
      %Ecto.Changeset{source: %Gospel{}}

  """
  def change_gospel(%Gospel{} = gospel) do
    Gospel.changeset(gospel, %{})
  end

  alias DB.Schema.MediaGospel

  @doc """
  Returns the list of mediagospel.

  ## Examples

      iex> list_mediagospel()
      [%MediaGospel{}, ...]

  """
  def list_mediagospel do
    Repo.all(MediaGospel)
  end

  @doc """
  Gets a single media_gospel.

  Raises `Ecto.NoResultsError` if the Media gospel does not exist.

  ## Examples

      iex> get_media_gospel!(123)
      %MediaGospel{}

      iex> get_media_gospel!(456)
      ** (Ecto.NoResultsError)

  """
  def get_media_gospel!(id), do: Repo.get!(MediaGospel, id)

  @doc """
  Creates a media_gospel.

  ## Examples

      iex> create_media_gospel(%{field: value})
      {:ok, %MediaGospel{}}

      iex> create_media_gospel(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_media_gospel(attrs \\ %{}) do
    %MediaGospel{}
    |> MediaGospel.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a media_gospel.

  ## Examples

      iex> update_media_gospel(media_gospel, %{field: new_value})
      {:ok, %MediaGospel{}}

      iex> update_media_gospel(media_gospel, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_media_gospel(%MediaGospel{} = media_gospel, attrs) do
    media_gospel
    |> MediaGospel.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a MediaGospel.

  ## Examples

      iex> delete_media_gospel(media_gospel)
      {:ok, %MediaGospel{}}

      iex> delete_media_gospel(media_gospel)
      {:error, %Ecto.Changeset{}}

  """
  def delete_media_gospel(%MediaGospel{} = media_gospel) do
    Repo.delete(media_gospel)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking media_gospel changes.

  ## Examples

      iex> change_media_gospel(media_gospel)
      %Ecto.Changeset{source: %MediaGospel{}}

  """
  def change_media_gospel(%MediaGospel{} = media_gospel) do
    MediaGospel.changeset(media_gospel, %{})
  end

  alias DB.Schema.GospelTitle

  @doc """
  Returns the list of gospeltitle.

  ## Examples

      iex> list_gospeltitle()
      [%GospelTitle{}, ...]

  """
  def list_gospeltitle do
    Repo.all(GospelTitle)
  end

  @doc """
  Gets a single gospel_title.

  Raises `Ecto.NoResultsError` if the Gospel title does not exist.

  ## Examples

      iex> get_gospel_title!(123)
      %GospelTitle{}

      iex> get_gospel_title!(456)
      ** (Ecto.NoResultsError)

  """
  def get_gospel_title!(id), do: Repo.get!(GospelTitle, id)

  @doc """
  Creates a gospel_title.

  ## Examples

      iex> create_gospel_title(%{field: value})
      {:ok, %GospelTitle{}}

      iex> create_gospel_title(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_gospel_title(attrs \\ %{}) do
    %GospelTitle{}
    |> GospelTitle.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a gospel_title.

  ## Examples

      iex> update_gospel_title(gospel_title, %{field: new_value})
      {:ok, %GospelTitle{}}

      iex> update_gospel_title(gospel_title, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_gospel_title(%GospelTitle{} = gospel_title, attrs) do
    gospel_title
    |> GospelTitle.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a GospelTitle.

  ## Examples

      iex> delete_gospel_title(gospel_title)
      {:ok, %GospelTitle{}}

      iex> delete_gospel_title(gospel_title)
      {:error, %Ecto.Changeset{}}

  """
  def delete_gospel_title(%GospelTitle{} = gospel_title) do
    Repo.delete(gospel_title)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking gospel_title changes.

  ## Examples

      iex> change_gospel_title(gospel_title)
      %Ecto.Changeset{source: %GospelTitle{}}

  """
  def change_gospel_title(%GospelTitle{} = gospel_title) do
    GospelTitle.changeset(gospel_title, %{})
  end

  alias DB.Schema.Music

  @doc """
  Returns the list of music.

  ## Examples

      iex> list_music()
      [%Music{}, ...]

  """
  def list_music do
    Repo.all(Music)
  end

  @doc """
  Gets a single music.

  Raises `Ecto.NoResultsError` if the Music does not exist.

  ## Examples

      iex> get_music!(123)
      %Music{}

      iex> get_music!(456)
      ** (Ecto.NoResultsError)

  """
  def get_music!(id), do: Repo.get!(Music, id)

  @doc """
  Creates a music.

  ## Examples

      iex> create_music(%{field: value})
      {:ok, %Music{}}

      iex> create_music(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_music(attrs \\ %{}) do
    %Music{}
    |> Music.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a music.

  ## Examples

      iex> update_music(music, %{field: new_value})
      {:ok, %Music{}}

      iex> update_music(music, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_music(%Music{} = music, attrs) do
    music
    |> Music.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Music.

  ## Examples

      iex> delete_music(music)
      {:ok, %Music{}}

      iex> delete_music(music)
      {:error, %Ecto.Changeset{}}

  """
  def delete_music(%Music{} = music) do
    Repo.delete(music)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking music changes.

  ## Examples

      iex> change_music(music)
      %Ecto.Changeset{source: %Music{}}

  """
  def change_music(%Music{} = music) do
    Music.changeset(music, %{})
  end

  alias DB.Schema.MediaMusic

  @doc """
  Returns the list of mediamusic.

  ## Examples

      iex> list_mediamusic()
      [%MediaMusic{}, ...]

  """
  def list_mediamusic do
    Repo.all(MediaMusic)
  end

  @doc """
  Gets a single media_music.

  Raises `Ecto.NoResultsError` if the Media music does not exist.

  ## Examples

      iex> get_media_music!(123)
      %MediaMusic{}

      iex> get_media_music!(456)
      ** (Ecto.NoResultsError)

  """
  def get_media_music!(id), do: Repo.get!(MediaMusic, id)

  @doc """
  Creates a media_music.

  ## Examples

      iex> create_media_music(%{field: value})
      {:ok, %MediaMusic{}}

      iex> create_media_music(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_media_music(attrs \\ %{}) do
    %MediaMusic{}
    |> MediaMusic.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a media_music.

  ## Examples

      iex> update_media_music(media_music, %{field: new_value})
      {:ok, %MediaMusic{}}

      iex> update_media_music(media_music, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_media_music(%MediaMusic{} = media_music, attrs) do
    media_music
    |> MediaMusic.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a MediaMusic.

  ## Examples

      iex> delete_media_music(media_music)
      {:ok, %MediaMusic{}}

      iex> delete_media_music(media_music)
      {:error, %Ecto.Changeset{}}

  """
  def delete_media_music(%MediaMusic{} = media_music) do
    Repo.delete(media_music)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking media_music changes.

  ## Examples

      iex> change_media_music(media_music)
      %Ecto.Changeset{source: %MediaMusic{}}

  """
  def change_media_music(%MediaMusic{} = media_music) do
    MediaMusic.changeset(media_music, %{})
  end

  alias DB.Schema.MusicTitle

  @doc """
  Returns the list of musictitle.

  ## Examples

      iex> list_musictitle()
      [%MusicTitle{}, ...]

  """
  def list_musictitle do
    Repo.all(MusicTitle)
  end

  @doc """
  Gets a single music_title.

  Raises `Ecto.NoResultsError` if the Music title does not exist.

  ## Examples

      iex> get_music_title!(123)
      %MusicTitle{}

      iex> get_music_title!(456)
      ** (Ecto.NoResultsError)

  """
  def get_music_title!(id), do: Repo.get!(MusicTitle, id)

  @doc """
  Creates a music_title.

  ## Examples

      iex> create_music_title(%{field: value})
      {:ok, %MusicTitle{}}

      iex> create_music_title(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_music_title(attrs \\ %{}) do
    %MusicTitle{}
    |> MusicTitle.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a music_title.

  ## Examples

      iex> update_music_title(music_title, %{field: new_value})
      {:ok, %MusicTitle{}}

      iex> update_music_title(music_title, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_music_title(%MusicTitle{} = music_title, attrs) do
    music_title
    |> MusicTitle.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a MusicTitle.

  ## Examples

      iex> delete_music_title(music_title)
      {:ok, %MusicTitle{}}

      iex> delete_music_title(music_title)
      {:error, %Ecto.Changeset{}}

  """
  def delete_music_title(%MusicTitle{} = music_title) do
    Repo.delete(music_title)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking music_title changes.

  ## Examples

      iex> change_music_title(music_title)
      %Ecto.Changeset{source: %MusicTitle{}}

  """
  def change_music_title(%MusicTitle{} = music_title) do
    MusicTitle.changeset(music_title, %{})
  end

  alias DB.Schema.LanguageIdentifier

  @doc """
  Returns the list of languageidentifier.

  ## Examples

      iex> list_languageidentifier()
      [%LanguageIdentifier{}, ...]

  """
  def list_languageidentifier do
    Repo.all(LanguageIdentifier)
  end

  @doc """
  Gets a single language_identifier.

  Raises `Ecto.NoResultsError` if the Language identifier does not exist.

  ## Examples

      iex> get_language_identifier!(123)
      %LanguageIdentifier{}

      iex> get_language_identifier!(456)
      ** (Ecto.NoResultsError)

  """
  def get_language_identifier!(id), do: Repo.get!(LanguageIdentifier, id)

  @doc """
  Creates a language_identifier.

  ## Examples

      iex> create_language_identifier(%{field: value})
      {:ok, %LanguageIdentifier{}}

      iex> create_language_identifier(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_language_identifier(attrs \\ %{}) do
    %LanguageIdentifier{}
    |> LanguageIdentifier.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a language_identifier.

  ## Examples

      iex> update_language_identifier(language_identifier, %{field: new_value})
      {:ok, %LanguageIdentifier{}}

      iex> update_language_identifier(language_identifier, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_language_identifier(%LanguageIdentifier{} = language_identifier, attrs) do
    language_identifier
    |> LanguageIdentifier.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a LanguageIdentifier.

  ## Examples

      iex> delete_language_identifier(language_identifier)
      {:ok, %LanguageIdentifier{}}

      iex> delete_language_identifier(language_identifier)
      {:error, %Ecto.Changeset{}}

  """
  def delete_language_identifier(%LanguageIdentifier{} = language_identifier) do
    Repo.delete(language_identifier)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking language_identifier changes.

  ## Examples

      iex> change_language_identifier(language_identifier)
      %Ecto.Changeset{source: %LanguageIdentifier{}}

  """
  def change_language_identifier(%LanguageIdentifier{} = language_identifier) do
    LanguageIdentifier.changeset(language_identifier, %{})
  end
end

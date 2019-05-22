defmodule OlivetreeApi.V12 do

  import Ecto.Query, warn: false
  alias DB.Repo

  alias DB.Schema.{MediaChapter, Chapter, Book}
  alias DB.Schema.{BookTitle, LanguageIdentifier}

  alias DB.Schema.{MediaGospel, Gospel}
  alias DB.Schema.{GospelTitle, LanguageIdentifier}

  alias DB.Schema.{Music, MediaMusic}
  alias DB.Schema.{AppVersion, ClientDevice}

  require Ecto.Query
  require Logger

  def books_by_language(language) do
    languages = Ecto.Query.from(language in LanguageIdentifier,
      select: language.identifier)
      |> Repo.all

      Logger.debug("lang #{inspect %{attributes: languages}}")

    if !Enum.empty?(languages) do
      # python
      # localized_titles = dbsession.query(BookTitle, Book).join(Book).filter(BookTitle.language_id == language_id).order_by(Book.absolute_id.asc()).all()

      if Enum.find(languages, fn(_element) -> String.starts_with?(language, languages) end) do
        Ecto.Query.from(title in BookTitle,
          join: b in Book,
          on: title.book_id == b.id,
          where: title.language_id  == ^language,
          order_by: b.absolute_id,
          select: %{title: b.basename, localizedTitle: title.localizedname, uuid: b.uuid, languageId: title.language_id})
          |> Repo.all
      else
        nil
      end
    else
      Logger.debug("lang empty #{inspect %{attributes: languages}}")
      nil
    end
  end

  def chapter_media_by_bid(bid_str, language_id) do
    {:ok, bid_uuid} = Ecto.UUID.dump(bid_str)
    Logger.debug("bid_uuid: #{bid_uuid}")
    query = from b in Book,
    join: t in BookTitle,
    join: c in Chapter,
    join: mc in MediaChapter,

    where: b.uuid == ^bid_uuid,
    where: t.book_id == b.id,
    where: t.language_id  == ^language_id,
    where: c.book_id == b.id,
    where: c.id == mc.chapter_id,
    where: mc.language_id == ^language_id,
    order_by: [mc.absolute_id, mc.id],
    # where: t.language_id  == ^language_id,
    # where: mc.chapter_id == c.id,
    select: %{localizedName: mc.localizedname, path: mc.path, presenterName: mc.presenter_name, sourceMaterial: mc.source_material, uuid: mc.uuid}

    Logger.debug("Repo.all(query):")
    IO.inspect(Repo.all(query))
      Repo.all(query)
  end

  def gospel_by_language(language) do
    languages = Ecto.Query.from(language in LanguageIdentifier,
      select: language.identifier)
      |> Repo.all

      Logger.debug("lang #{inspect %{attributes: languages}}")

    if !Enum.empty?(languages) do

      if Enum.find(languages, fn(_element) -> String.starts_with?(language, languages) end) do
        Ecto.Query.from(title in GospelTitle,
          join: g in Gospel,
          on: title.gospel_id == g.id,
          where: title.language_id  == ^language,
          order_by: g.absolute_id,
          select: %{title: g.basename, localizedTitle: title.localizedname, uuid: g.uuid, languageId: title.language_id})
          |> Repo.all
      else
        nil
      end
    else
      Logger.debug("lang empty #{inspect %{attributes: languages}}")
      nil
    end
  end

  def gospel_media_by_gid(gid_str) do
    {:ok, gid_uuid} = Ecto.UUID.dump(gid_str)
    Logger.debug("gid_str: #{gid_str}")
    query = from g in Gospel,
    # join: t in GospelTitle,
    # join: c in Chapter,
    join: mg in MediaGospel,

    where: g.uuid == ^gid_uuid,
    # where: t.gospel_id == g.id,
    # where: t.language_id  == ^language_id,
    # where: c.book_id == g.id,
    # where: c.id == mc.chapter_id,
    where: mg.gospel_id == g.id,
    # where: mg.language_id == ^language_id,
    order_by: [mg.absolute_id, mg.id],
    # where: t.language_id  == ^language_id,
    select: %{localizedName: mg.localizedname, path: mg.path, presenterName: mg.presenter_name, sourceMaterial: mg.source_material, uuid: mg.uuid}

    Logger.debug("Repo.all(query):")
    IO.inspect(Repo.all(query))
    # Repo.paginate(page: 1, page_size: 10)
    Repo.all(query)
  end

  def music() do
    Ecto.Query.from(m in Music,
      order_by: m.absolute_id,
      select: %{mid: m.uuid, title: m.basename})
      |> Repo.all
  end

  def music_media_by_mid(mid_str) do
    {:ok, mid_uuid} = Ecto.UUID.dump(mid_str)
    Logger.debug("mid_str: #{mid_str}")
    query = from m in Music,
    # join: t in GospelTitle,
    # join: c in Chapter,
    join: mm in MediaMusic,

    where: m.uuid == ^mid_uuid,
    where: mm.music_id == m.id,
    # where: t.gospel_id == g.id,
    # where: t.language_id  == ^language_id,
    # where: c.book_id == g.id,
    # where: c.id == mc.chapter_id,
    # where: mm.language_id == ^language_id,
    order_by: [mm.absolute_id, mm.id],
    # where: t.language_id  == ^language_id,
    select: %{localizedName: mm.localizedname, path: mm.path, presenterName: mm.presenter_name, sourceMaterial: mm.source_material, uuid: mm.uuid}

    Logger.debug("Repo.all(query):")
    IO.inspect(Repo.all(query))
    # Repo.paginate(page: 1, page_size: 10)
    Repo.all(query)
  end

  def language_identifiers() do
    Ecto.Query.from(lid in LanguageIdentifier,
      order_by: lid.identifier,
      select: %{identifier: lid.identifier, source_material: lid.source_material, supported: lid.supported, uuid: lid.uuid})
      |> Repo.all
  end

  def app_versions() do
    Ecto.Query.from(av in AppVersion,
      order_by: av.id,
      select: %{version_number: av.version_number,
      ios_supported: av.ios_supported,
      android_supported: av.android_supported,
      uuid: av.uuid})
      |> Repo.all
  end

  # def add_client_device(fcm_token, apns_token, preferred_language, user_agent, user_version) do
    def add_client_device(fcm_token, apns_token, preferred_language, user_agent) do

    case Repo.get_by(ClientDevice, firebase_token: fcm_token) do
      nil ->
        ClientDevice.changeset(%ClientDevice{}, %{
          apns_token: apns_token,
          firebase_token: fcm_token,
          preferred_language: preferred_language,
          user_agent: user_agent,
          user_version: nil,
          uuid: Ecto.UUID.generate
        })
        |> Repo.insert()
      # client_device ->
      #   |> ClientDevice.changeset(%{
      #     apns_token: apns_token,
      #     firebase_token: fcm_token,
      #     preferred_language: preferred_language,
      #     user_agent: user_agent,
      #     user_version: user_version,
      #     uuid: uuid
      #   })
      #   |> Repo.update()
    end
  end
end

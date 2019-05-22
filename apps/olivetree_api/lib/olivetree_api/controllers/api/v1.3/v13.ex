defmodule OlivetreeApi.V13 do

  import Ecto.Query, warn: false
  alias DB.Repo

  alias DB.Schema.{MediaChapter, Chapter, Book}
  alias DB.Schema.{BookTitle, LanguageIdentifier}

  alias DB.Schema.{MediaGospel, Gospel}
  alias DB.Schema.{GospelTitle, LanguageIdentifier}
  alias DB.Schema.{MusicTitle, Music, MediaMusic}
  alias DB.Schema.{Org, Channel, Playlist, PlaylistTitle, MediaItem}
  alias DB.Schema.AppVersion
  alias DB.Schema.ClientDevice

  alias OlivetreeApi.MediaItemsSearch

  require Ecto.Query
  require Logger
  require DateTime

  def books_by_language(language, offset \\ 0, limit \\ 0) do
    languages = Ecto.Query.from(language in LanguageIdentifier,
      select: language.identifier)
      |> Repo.all

      Logger.debug("lang #{inspect %{attributes: languages}}")

    if !Enum.empty?(languages) do
      # python
      # localized_titles = dbsession.query(BookTitle, Book).join(Book).filter(BookTitle.language_id == language_id).order_by(Book.absolute_id.asc()).all()

      if Enum.find(languages, fn(_element) -> String.starts_with?(language, languages) end) do
        Ecto.Query.from(title in DB.Schema.BookTitle,
          join: b in DB.Schema.Book,
          on: title.book_id == b.id,
          where: title.language_id  == ^language,
          order_by: b.absolute_id,
          select: %{title: b.basename, localizedTitle: title.localizedname, uuid: b.uuid, languageId: title.language_id})
          |> Repo.paginate(page: offset, page_size: limit)
          # |> DB.Repo.all
      else
        nil
      end
    else
      Logger.debug("lang empty #{inspect %{attributes: languages}}")
      nil
    end
  end

  def chapter_media_by_uuid(bid_str, language_id, offset \\ 0, limit \\ 0) do
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

    query
    |> Repo.paginate(page: offset, page_size: limit)
    # |> Repo.all
    # Repo.all
    # Repo.paginate(page: 1, page_size: 10)


    # Logger.debug("Repo.all(query):")
    # IO.inspect(Repo.all(query))
    # Repo.all(query)
  end

  def gospel_by_language(language, offset \\ 0, limit \\ 0) do
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
          |> Repo.paginate(page: offset, page_size: limit)
          # |> Repo.all
      else
        nil
      end
    else
      Logger.debug("lang empty #{inspect %{attributes: languages}}")
      nil
    end
  end

  @spec gospel_media_by_uuid(any(), any(), any()) :: Scrivener.Page.t()
  def gospel_media_by_uuid(gid_str, offset \\ 0, limit \\ 0) do
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
    # where: mg.language_id == ^language_id,
    where: mg.gospel_id == g.id,
    # order_by: [mg.absolute_id, mg.id],
    order_by: [desc: mg.updated_at],
    # where: t.language_id  == ^language_id,
    select: %{localizedName: mg.localizedname, path: mg.path, presenterName: mg.presenter_name, sourceMaterial: mg.source_material, uuid: mg.uuid}
    query
    # |> DB.Query.order_by_last_updated_desc()
    |> Repo.paginate(page: offset, page_size: limit)
  end

  @spec music_by_language(any(), any(), any()) :: nil | Scrivener.Page.t()
  def music_by_language(language \\ "en", offset \\ 0, limit \\ 0) do
    # Ecto.Query.from(m in Music,
    # order_by: m.absolute_id,
    # select: %{mid: m.uuid, title: m.title})
    # |> Repo.paginate(page: offset, page_size: limit)

    languages = Ecto.Query.from(language in LanguageIdentifier,
    select: language.identifier)
    |> Repo.all

    Logger.debug("lang #{inspect %{attributes: languages}}")

    if !Enum.empty?(languages) do
      if Enum.find(languages, fn(_element) -> String.starts_with?(language, languages) end) do
        Ecto.Query.from(title in MusicTitle,
          join: m in Music,
          on: title.music_id == m.id,
          where: title.language_id  == ^language,
          order_by: m.absolute_id,
          select: %{title: m.basename, localizedTitle: title.localizedname, uuid: m.uuid, languageId: title.language_id})
          |> Repo.paginate(page: offset, page_size: limit)
          # |> Repo.all
      else
        nil
      end
    else
      Logger.debug("lang empty #{inspect %{attributes: languages}}")
      nil
    end
  end

  def music_media_by_uuid(gid_str, offset \\ 0, limit \\ 0) do
    {:ok, gid_uuid} = Ecto.UUID.dump(gid_str)
    Logger.debug("gid_str: #{gid_str}")

    query = from m in Music,
    # join: t in MusicTitle,
    # join: c in Chapter,
    join: mm in MediaMusic,

    where: m.uuid == ^gid_uuid,
    # where: t.music_id == m.id,
    # where: t.language_id  == ^language_id,
    # where: c.book_id == g.id,
    # where: c.id == mc.chapter_id,
    # where: mm.language_id == ^language_id,
    where: mm.music_id == m.id,
    order_by: [mm.absolute_id, mm.id],
    # where: t.language_id  == ^language_id,
    select:
    %{localizedName: mm.localizedname,
      path: mm.path,
      presenterName: mm.presenter_name,
      sourceMaterial: mm.source_material,
      uuid: mm.uuid}

    query
    |> Repo.paginate(page: offset, page_size: limit)
  end

  def language_identifiers(offset \\ 0, limit \\ 0) do
    Ecto.Query.from(lid in LanguageIdentifier,
      order_by: lid.identifier,
      select: %{identifier: lid.identifier, source_material: lid.source_material, supported: lid.supported, uuid: lid.uuid})
      |> Repo.paginate(page: offset, page_size: limit)
  end

  def app_versions(offset \\ 0, limit \\ 0) do
    Ecto.Query.from(av in AppVersion,
      order_by: av.id,
      select: %{version_number: av.version_number,
      ios_supported: av.ios_supported,
      android_supported: av.android_supported,
      web_supported: av.web_supported,
      uuid: av.uuid})
      |> Repo.paginate(page: offset, page_size: limit)
  end

  def add_client_device(fcm_token, apns_token, preferred_language, user_agent, user_version) do
    case Repo.get_by(ClientDevice, firebase_token: fcm_token) do
      nil ->
        ClientDevice.changeset(%ClientDevice{}, %{
          apns_token: apns_token,
          firebase_token: fcm_token,
          preferred_language: preferred_language,
          user_agent: user_agent,
          user_version: user_version,
          uuid: Ecto.UUID.generate
        })
        |> Repo.insert()
      client_device ->
        ClientDevice.changeset(%ClientDevice{id: client_device.id}, %{
          apns_token: apns_token,
          firebase_token: fcm_token,
          preferred_language: preferred_language,
          user_agent: user_agent,
          user_version: user_version,
          uuid: client_device.uuid
        })
        |> Repo.update()
    end
  end

  def channels_by_org_uuid(orguuid, offset, limit) do
      # python
      # localized_titles = dbsession.query(BookTitle, Book).join(Book).filter(BookTitle.language_id == language_id).order_by(Book.absolute_id.asc()).all()
      {:ok, org_uuid} = Ecto.UUID.dump(orguuid)

        query = from channel in Channel,
        join: org in Org,

        where: org.uuid == ^org_uuid,
        where: org.id == channel.org_id,
        order_by: channel.ordinal,

        select:
        %{basename: channel.basename,
          uuid: channel.uuid,
          org_uuid: org.uuid,
          ordinal: channel.ordinal,
          basename: channel.basename,
          small_thumbnail_path: channel.small_thumbnail_path,
          med_thumbnail_path: channel.med_thumbnail_path,
          large_thumbnail_path: channel.large_thumbnail_path,
          banner_path: channel.banner_path,
          inserted_at: channel.inserted_at,
          updated_at: channel.updated_at,
          hash_id: channel.hash_id
        }

        query
        |> Repo.paginate(page: offset, page_size: limit)

  end

  def playlists_by_channel_uuid(uuid_str, language_id, offset, limit) do
    {:ok, channel_uuid} = Ecto.UUID.dump(uuid_str)
    Logger.debug("channel_uuid: #{uuid_str}")

    query = from pl in Playlist,

    join: ch in Channel,
    join: pt in PlaylistTitle,

    where: ch.uuid == ^channel_uuid,
    where: ch.id == pl.channel_id,
    where: pl.id == pt.playlist_id,
    where: pt.language_id == ^language_id,

    order_by: [pl.ordinal],

    select:
    %{localizedname: pt.localizedname,
      language_id: pt.language_id,
      ordinal: pl.ordinal,
      small_thumbnail_path: pl.small_thumbnail_path,
      med_thumbnail_path: pl.med_thumbnail_path,
      large_thumbnail_path: pl.large_thumbnail_path,
      banner_path: pl.banner_path,
      media_category: pl.media_category,
      uuid: pl.uuid,
      channel_uuid: ch.uuid,
      inserted_at: pl.inserted_at,
      updated_at: pl.updated_at,
      hash_id: pl.hash_id
    }
    query
    |> IO.inspect
    |> Repo.paginate(page: offset, page_size: limit)
  end

  def media_items_by_playlist_uuid(playlist_uuid, language_id \\ "en", offset \\ 0, limit \\ 0) do
    {:ok, pid_uuid} = Ecto.UUID.dump(playlist_uuid)
    Logger.debug("pid_uuid: #{pid_uuid}")

    media_category = Ecto.Query.from(playlist in Playlist,
    where: playlist.uuid == ^playlist_uuid,
    select: playlist.media_category)
    |> Repo.one
    |> IO.inspect

    special_categories = [:livestream, :motivation, :movie, :podcast, :testimony, :preaching]
    {direction, sorting} = if media_category in special_categories do
      {:desc, :presented_at}
    else
      {:asc, :track_number}
    end
    Logger.info("direction: #{direction} sorting: #{sorting}")

    query = from pl in Playlist,
    # join: t in MusicTitle,
    # join: c in Chapter,
    join: mi in MediaItem,
    # join: pt in PlaylistTitle,

    where: pl.uuid == ^pid_uuid,
    where: mi.playlist_id == pl.id,
    # where: pl.id == pt.playlist_id,
    where: mi.language_id == ^language_id,
    order_by: [{^direction, field(mi, ^sorting)}],
    # order_by: [{:desc, field(mi, :presented_at)}],
    select:
    %{ordinal: mi.ordinal,
      uuid: mi.uuid,
      track_number: mi.track_number,
      medium: mi.medium,
      localizedname: mi.localizedname,
      path: mi.path,
      content_provider_link: mi.content_provider_link,
      ipfs_link: mi.ipfs_link,
      language_id: mi.language_id,
      presenter_name: mi.presenter_name,
      source_material: mi.source_material,
      playlist_uuid: pl.uuid,
      tags: mi.tags,
      small_thumbnail_path: mi.small_thumbnail_path,
      med_thumbnail_path: mi.med_thumbnail_path,
      large_thumbnail_path: mi.large_thumbnail_path,
      inserted_at: mi.inserted_at,
      updated_at: mi.updated_at,
      media_category: mi.media_category,
      presented_at: mi.presented_at,
      published_at: mi.published_at,
      hash_id: mi.hash_id
    }

    query
    |> Repo.paginate(page: offset, page_size: limit)
  end

  def media_item_by_hash_id(hash_id) do
    query = from mi in MediaItem,
    where: mi.hash_id == ^hash_id,
    select:
    %{ordinal: mi.ordinal,
      uuid: mi.uuid,
      track_number: mi.track_number,
      medium: mi.medium,
      localizedname: mi.localizedname,
      path: mi.path,
      content_provider_link: mi.content_provider_link,
      ipfs_link: mi.ipfs_link,
      language_id: mi.language_id,
      presenter_name: mi.presenter_name,
      source_material: mi.source_material,
      tags: mi.tags,
      small_thumbnail_path: mi.small_thumbnail_path,
      med_thumbnail_path: mi.med_thumbnail_path,
      large_thumbnail_path: mi.large_thumbnail_path,
      inserted_at: mi.inserted_at,
      updated_at: mi.updated_at,
      media_category: mi.media_category,
      presented_at: mi.presented_at,
      published_at: mi.published_at,
      hash_id: mi.hash_id
    }

    query
    |> Repo.one()
  end

  def orgs_default_org(offset \\ 0, limit \\ 0) do
    # python
    # localized_titles = dbsession.query(BookTitle, Book).join(Book).filter(BookTitle.language_id == language_id).order_by(Book.absolute_id.asc()).all()

    Ecto.Query.from(org in Org,
      where: org.shortname == "olivetreeapp",
      order_by: org.id,
      select:
      %{basename: org.basename,
        uuid: org.uuid,
        small_thumbnail_path: org.small_thumbnail_path,
        med_thumbnail_path: org.med_thumbnail_path,
        large_thumbnail_path: org.large_thumbnail_path,
        banner_path: org.banner_path,
        inserted_at: org.inserted_at,
        updated_at: org.updated_at,
        shortname: org.shortname,
        hash_id: org.hash_id
        })
      |> Repo.paginate(page: offset, page_size: limit)
  end

  def search(query_string, offset \\ 0, limit \\ 0,
    media_category,
    playlist_uuid,
    channel_uuid,
    published_after,
    updated_after,
    presented_after
      ) do

    conditions = true

    conditions =
      if media_category do
        dynamic([mi], mi.media_category == ^media_category and ^conditions)
      else
        conditions
      end

    # jan 2019: 1546527751
    # jan 2020: 1578063751
    # apr 29 2019: 1556550151
    # April 26, 2013 3:02:31 PM: 1366988551
    # May 3, 2017 11:16:55 PM: 1493853415
    # May 3, 2018 11:16:55 PM: 1525389415
    # preaching channel uuid f467f75c-937a-46a3-a21f-880bb9777408
    # music channel uuid 52f758d2-ce64-4ffd-8d3c-77f598003ee1
    conditions =
      if published_after do
        {:ok, datetime} = DateTime.from_unix(published_after, :second)
        naive = DateTime.to_naive(datetime)
        dynamic([mi], mi.published_at >= ^naive and ^conditions)
      else
        conditions
      end

      conditions =
      if updated_after do
        {:ok, datetime} = DateTime.from_unix(updated_after, :second)
        naive = DateTime.to_naive(datetime)
        dynamic([mi], mi.updated_at >= ^naive and ^conditions)
      else
        conditions
      end

      conditions =
      if presented_after do
        {:ok, datetime} = DateTime.from_unix(presented_after, :second)
        naive = DateTime.to_naive(datetime)
        dynamic([mi], mi.presented_at >= ^naive and ^conditions)
      else
        conditions
      end

      Logger.info("channel_uuid: #{channel_uuid}")
      Logger.info("playlist_uuid: #{playlist_uuid}")

      query = if playlist_uuid do
        search_by_playlist_query(playlist_uuid, conditions)
      else
        search_by_channel_query(channel_uuid, conditions)
      end

    MediaItemsSearch.run(query, query_string)
      |> Repo.paginate(page: offset, page_size: limit)
  end

  def search_by_playlist_query(nil, conditions) do
    Ecto.Query.from(mi in MediaItem, where: ^conditions)
  end

  def search_by_playlist_query(playlist_uuid, conditions) do
    # """
    #   -- all the mediaitems in a playlist
    #   select *
    #   from mediaitems
    #   inner join playlists on mediaitems.playlist_id = playlists.id
    #   where playlists.id = 118
    # """

    from mi in MediaItem,
    join: pl in Playlist,
    where: mi.playlist_id == pl.id,
    where: pl.uuid == ^playlist_uuid,
    where: ^conditions
  end

  def search_by_channel_query(nil, conditions) do
    Ecto.Query.from(mi in MediaItem, where: ^conditions)
  end

  def search_by_channel_query(channel_uuid, conditions) do
    # """
    #   -- all the mediaitems in a channel
    #   select *
    #   from mediaitems
    #   inner join playlists on mediaitems.playlist_id = playlists.id
    #   inner join channels on playlists.channel_id = channels.id
    #   where channels.id = 2
    # """
    Logger.info("channel_uuid: #{channel_uuid}")
    from mi in MediaItem,
    join: pl in Playlist,
    join: ch in Channel,

    where: mi.playlist_id == pl.id,
    where: pl.channel_id == ch.id,
    where: ch.uuid == ^channel_uuid,
    where: ^conditions
  end
end

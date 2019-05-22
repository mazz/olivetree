defmodule Olivetree.Videos.MetadataFetcher.Youtube do
  @moduledoc """
  Methods to fetch metadata (title, language) from videos
  """

  @behaviour Olivetree.Videos.MetadataFetcher

  require Logger

  import Olivetree.Videos

  alias Kaur.Result
  alias GoogleApi.YouTube.V3.Connection, as: YouTubeConnection
  alias GoogleApi.YouTube.V3.Api.Videos, as: YouTubeVideos
  # alias GoogleApi.YouTube.V3.Api.PlaylistItems, as: YouTubePlaylistItems
  # UCq7BdmVpQsay5XrwOgMhN5w
  alias GoogleApi.YouTube.V3.Model.PlaylistItemListResponse, as: YouTubePlaylistVideos
  alias GoogleApi.YouTube.V3.Model.PlaylistItem, as: YouTubePlaylistVideo


  alias GoogleApi.YouTube.V3.Model.Video, as: YouTubeVideo
  alias GoogleApi.YouTube.V3.Model.VideoListResponse, as: YouTubeVideoList

  alias DB.Schema.Video
  alias DB.Schema.User
  alias Olivetree.Videos.MetadataFetcher
  alias DB.Repo

  @doc """
  Fetch metadata from video. Returns an object containing  :title, :url and :language
  """
  def fetch_video_metadata(nil),
    do: {:error, "Invalid URL"}

  def fetch_video_metadata(url) when is_binary(url) do
    {:youtube, youtube_id} = Video.parse_url(url)

    case Application.get_env(:olivetree, :youtube_api_key) do
      nil ->
        Logger.warn("No YouTube API key provided. Falling back to HTML fetcher")
        MetadataFetcher.Opengraph.fetch_video_metadata(url)

      api_key ->
        do_fetch_video_metadata(youtube_id, api_key)
    end
  end

  defp do_fetch_video_metadata(youtube_id, api_key) do
    YouTubeConnection.new()
    |> YouTubeVideos.youtube_videos_list("snippet", id: youtube_id, key: api_key)
    |> Result.map_error(fn e -> "YouTube API Error: #{inspect(e)}" end)
    |> Result.keep_if(&(!Enum.empty?(&1.items)), "remote_video_404")
    |> Result.map(fn %YouTubeVideoList{items: [video = %YouTubeVideo{} | _]} ->
      %{
        title: video.snippet.title,
        channelTitle: video.snippet.channelTitle,
        language: video.snippet.defaultLanguage || video.snippet.defaultAudioLanguage,
        publishedAt: video.snippet.publishedAt,
        tags: video.snippet.tags,
        description: video.snippet.description,
        url: Video.build_url(%{youtube_id: youtube_id})
      }
    end)
  end

  def fetch_playlist_item_list_metadata(nil),
    do: {:error, "Invalid URL"}

  def fetch_playlist_item_list_metadata(playlist_id) when is_binary(playlist_id) do

    case Application.get_env(:olivetree, :youtube_api_key) do
      nil ->
        Logger.warn("No YouTube API key provided. Bailing")
        # MetadataFetcher.Opengraph.fetch_video_metadata(url)

      api_key ->
        do_fetch_playlist_item_list_metadata(playlist_id, api_key)
    end
  end


  # defp do_fetch_video_metadata(video_id, api_key) do

  #   # %GoogleApi.YouTube.V3.Model.VideoListResponse{

  #   # conn = GoogleApi.YouTube.V3.Connection.new()
  #   #video
  #   # conn |> GoogleApi.YouTube.V3.Api.Videos.youtube_videos_list("snippet", maxResults: 50, id: "yea9PLUMuzs", key: "AIzaSyB01nsJz0y24aXMqbX34oJ9Y4ywh0koKe4")

  #   user = Repo.get_by(User, email: "admin@olivetree.app")

  #   YouTubeConnection.new()
  #     |> GoogleApi.YouTube.V3.Api.Videos.youtube_videos_list("snippet", maxResults: 50, id: video_id, key: api_key)
  #     |> Result.map_error(fn e -> "YouTube API Error: #{inspect(e)}" end)
  #     |> Result.keep_if(&(!Enum.empty?(&1.items)), "remote_video_404")
  #     |> Result.map(fn %GoogleApi.YouTube.V3.Model.VideoListResponse{items: videos} ->
  #     Enum.each(videos, fn video ->
  #       url = Video.build_url(%{youtube_id: video.snippet.resourceId.videoId})

  #       case get_video_by_url(url) do
  #         nil ->
  #           create!(user, url)
  #       end
  #     end)
  #   end)

  #   """
  #   %GoogleApi.YouTube.V3.Model.VideoListResponse{
  #     etag: "\"XpPGQXPnxQJhLgs6enD_n8JR4Qk/vC2R7JlGA8UPMAFG0fIqdYVQxnI\"",
  #     eventId: nil,
  #     items: [
  #       %GoogleApi.YouTube.V3.Model.Video{
  #         ageGating: nil,
  #         contentDetails: nil,
  #         etag: "\"XpPGQXPnxQJhLgs6enD_n8JR4Qk/6FvMyYhjrrmrdHfzbjB_o-6m2KM\"",
  #         fileDetails: nil,
  #         id: "yea9PLUMuzs",
  #         kind: "youtube#video",
  #         liveStreamingDetails: nil,
  #         localizations: nil,
  #         monetizationDetails: nil,
  #         player: nil,
  #         processingDetails: nil,
  #         projectDetails: nil,
  #         recordingDetails: nil,
  #         snippet: %GoogleApi.YouTube.V3.Model.VideoSnippet{
  #           categoryId: "29",
  #           channelId: "UCq7BdmVpQsay5XrwOgMhN5w",
  #           channelTitle: "sanderson1611",
  #           defaultAudioLanguage: "en",
  #           defaultLanguage: nil,
  #           description: "Here is the link to make a donation to Faithful Word Baptist Church (donations processed by Word of Truth Baptist Church):\n\nhttp://wordoftruthbaptist.org/donate\n\nHere is the link to thousands more sermons from Pastor Anderson:\n\nhttp://www.olivetreebaptist.org/page5.html\n\nTo get hard copies of Pastor Anderson's preaching (CDs, DVDs, USBs, etc), come by Faithful Word Baptist Church in Tempe, AZ, to pick up FREE copies. You can also purchase copies online from a third party \"Framing the World:\"\n\nhttps://store.framingtheworld.com/t/dvds\n\n #baptist\n#preaching\n#sermon",
  #           liveBroadcastContent: "none",
  #           localized: %GoogleApi.YouTube.V3.Model.VideoLocalization{
  #             description: "Here is the link to make a donation to Faithful Word Baptist Church (donations processed by Word of Truth Baptist Church):\n\nhttp://wordoftruthbaptist.org/donate\n\nHere is the link to thousands more sermons from Pastor Anderson:\n\nhttp://www.olivetreebaptist.org/page5.html\n\nTo get hard copies of Pastor Anderson's preaching (CDs, DVDs, USBs, etc), come by Faithful Word Baptist Church in Tempe, AZ, to pick up FREE copies. You can also purchase copies online from a third party \"Framing the World:\"\n\nhttps://store.framingtheworld.com/t/dvds\n\n #baptist\n#preaching\n#sermon",
  #             title: "The Devil's Master Plan for the End Times"
  #           },
  #           publishedAt: #DateTime<2015-03-09 03:16:30.000Z>,
  #           tags: ["Devil (Quotation Subject)", "End Time (Belief)", "Satan",
  #            "prophecy", "eschatology", "antichrist", "man of sin",
  #            "son of perdition", "baptist", "preaching", "independent",
  #            "fundamental", "kjv", "king james", "version", "bible", "only",
  #            "Christian", "church", "revelation", ...],
  #           thumbnails: %GoogleApi.YouTube.V3.Model.ThumbnailDetails{
  #             default: %GoogleApi.YouTube.V3.Model.Thumbnail{
  #               height: 90,
  #               url: "https://i.ytimg.com/vi/yea9PLUMuzs/default.jpg",
  #               width: 120
  #             },
  #             high: %GoogleApi.YouTube.V3.Model.Thumbnail{
  #               height: 360,
  #               url: "https://i.ytimg.com/vi/yea9PLUMuzs/hqdefault.jpg",
  #               width: 480
  #             },
  #             maxres: %GoogleApi.YouTube.V3.Model.Thumbnail{
  #               height: 720,
  #               url: "https://i.ytimg.com/vi/yea9PLUMuzs/maxresdefault.jpg",
  #               width: 1280
  #             },
  #             medium: %GoogleApi.YouTube.V3.Model.Thumbnail{
  #               height: 180,
  #               url: "https://i.ytimg.com/vi/yea9PLUMuzs/mqdefault.jpg",
  #               width: 320
  #             },
  #             standard: %GoogleApi.YouTube.V3.Model.Thumbnail{
  #               height: 480,
  #               url: "https://i.ytimg.com/vi/yea9PLUMuzs/sddefault.jpg",
  #               width: 640
  #             }
  #           },
  #           title: "The Devil's Master Plan for the End Times"
  #         },
  #         statistics: nil,
  #         status: nil,
  #         suggestions: nil,
  #         topicDetails: nil

  #   """
  # end

  defp do_fetch_playlist_item_list_metadata(playlist_id, api_key) do

    # returns playlistid for sanderson1611
    # %GoogleApi.YouTube.V3.Model.ChannelListResponse{
    # conn |> YouTubeChannels.youtube_channels_list("contentDetails", forUsername: "sanderson1611", key: "AIzaSyB01nsJz0y24aXMqbX34oJ9Y4ywh0koKe4")

    #sanderson1611 playlist
    # conn = GoogleApi.YouTube.V3.Connection.new()
    # conn |> GoogleApi.YouTube.V3.Api.PlaylistItems.youtube_playlist_items_list("snippet", maxResults: 50, playlistId: "UUq7BdmVpQsay5XrwOgMhN5w", key: "AIzaSyB01nsJz0y24aXMqbX34oJ9Y4ywh0koKe4")

    #video
    # conn |> GoogleApi.YouTube.V3.Api.Videos.youtube_videos_list("snippet", maxResults: 50, id: "qSVJOYxg1dA", key: "AIzaSyB01nsJz0y24aXMqbX34oJ9Y4ywh0koKe4")

    #  GoogleApi.YouTube.V3.Model.PlaylistItemListResponse.yout
    #returns first 50
    # %GoogleApi.YouTube.V3.Model.PlaylistItemListResponse{
    # with
    # items: [%GoogleApi.YouTube.V3.Model.PlaylistItem{ ...}]
    # from main sanderson1611 playlist
    # with pageToken "CDIQAA"
    # conn |> GoogleApi.YouTube.V3.Api.PlaylistItems.youtube_playlist_items_list("snippet", maxResults: 50, playlistId: "UUq7BdmVpQsay5XrwOgMhN5w", pageToken: "CDIQAA", key: "AIzaSyB01nsJz0y24aXMqbX34oJ9Y4ywh0koKe4")

    # user = Repo.get_by(User, email: "admin@olivetree.app")

    YouTubeConnection.new()
      |> GoogleApi.YouTube.V3.Api.PlaylistItems.youtube_playlist_items_list("snippet", maxResults: 50, playlistId: playlist_id, key: api_key)
      |> Result.map_error(fn e -> "YouTube API Error: #{inspect(e)}" end)
      |> Result.keep_if(&(!Enum.empty?(&1.items)), "remote_video_404")
      |> Result.map(fn %GoogleApi.YouTube.V3.Model.PlaylistItemListResponse{items: videos} ->
        Enum.map(videos, fn video ->
          # url = Video.build_url(%{youtube_id: video.snippet.resourceId.videoId})

          # case get_video_by_url(url) do
          #   nil ->
          #     create!(user, url)
          # end
        %{
          title: video.snippet.title,
          description: video.snippet.description,
          publishedAt: video.snippet.publishedAt,
          thumbnails: video.snippet.thumbnails,
          url: Video.build_url(%{youtube_id: video.snippet.resourceId.videoId})
        }
      # |> IO.inspect("after video:")
      end)
    end)
  end

end

"""
{:ok,
 %GoogleApi.YouTube.V3.Model.PlaylistItemListResponse{
   etag: "\"XpPGQXPnxQJhLgs6enD_n8JR4Qk/bl5SJ6tbEpq3fHA9eJnn81iUwTk\"",
   eventId: nil,
   items: [
     %GoogleApi.YouTube.V3.Model.PlaylistItem{
       contentDetails: nil,
       etag: "\"XpPGQXPnxQJhLgs6enD_n8JR4Qk/cglhhOWRkcs8ApzRqYnj9UqsF-I\"",
       id: "VVVxN0JkbVZwUXNheTVYcndPZ01oTjV3LlNhYk9WWHVBMHdj",
       kind: "youtube#playlistItem",
       snippet: %GoogleApi.YouTube.V3.Model.PlaylistItemSnippet{
         channelId: "UCq7BdmVpQsay5XrwOgMhN5w",
         channelTitle: "sanderson1611",
         description: "This is an excerpt from the full sermon \"Jesus in the Book of Numbers:\"\n\nhttps://www.youtube.com/watch?v=2fJmO30w6Nk\n\nMore preaching from Pastor Anderson:\n\nhttp://www.olivetreebaptist.org/page5.html\n\nHere is the link to make a donation to Faithful Word Baptist Church (donations processed by Word of Truth Baptist Church):\n\nhttp://wordoftruthbaptist.org/donate\n\n#oldtestament\n#ot\n#numbers",
         playlistId: "UUq7BdmVpQsay5XrwOgMhN5w",
         position: 50,
         publishedAt: #DateTime<2019-02-09 16:28:27.000Z>,
         resourceId: %GoogleApi.YouTube.V3.Model.ResourceId{
           channelId: nil,
           kind: "youtube#video",
           playlistId: nil,
           videoId: "SabOVXuA0wc"
         },
         thumbnails: %GoogleApi.YouTube.V3.Model.ThumbnailDetails{
           default: %GoogleApi.YouTube.V3.Model.Thumbnail{
             height: 90,
             url: "https://i.ytimg.com/vi/SabOVXuA0wc/default.jpg",
             width: 120
           },
           high: %GoogleApi.YouTube.V3.Model.Thumbnail{
             height: 360,
             url: "https://i.ytimg.com/vi/SabOVXuA0wc/hqdefault.jpg",
             width: 480
           },
           maxres: %GoogleApi.YouTube.V3.Model.Thumbnail{
             height: 720,
             url: "https://i.ytimg.com/vi/SabOVXuA0wc/maxresdefault.jpg",
             width: 1280
           },
           medium: %GoogleApi.YouTube.V3.Model.Thumbnail{
             height: 180,
             url: "https://i.ytimg.com/vi/SabOVXuA0wc/mqdefault.jpg",
             width: 320
           },
           standard: %GoogleApi.YouTube.V3.Model.Thumbnail{
             height: 480,
             url: "https://i.ytimg.com/vi/SabOVXuA0wc/sddefault.jpg",
             width: 640
           }
         },
         title: "Old Testament Books Have Never Been More Relevant"
       },
       status: nil
     },
"""

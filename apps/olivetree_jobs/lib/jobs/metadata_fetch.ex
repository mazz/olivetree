defmodule Olivetree.Jobs.MetadataFetch do
  @moduledoc """
  This job analyze moderation feebacks and ban or unreport comments accordingly.

  TODO: Broadcast updates
  """

  use GenServer
  require Logger
  import Ecto.Query
  import Olivetree.Videos

  alias DB.Schema.User
  alias Olivetree.Videos.MetadataFetcher.Youtube, as: YoutubeMetaDataFetcher
  alias DB.Repo

  @name __MODULE__
  # @min_nb_feedbacks_to_process_entry 3
  # @refute_ban_under -0.66
  # @confirm_ban_above 0.66

  # --- Client API ---

  def start_link() do
    GenServer.start_link(@name, :ok, name: @name)
  end

  def init(args) do
    {:ok, args}
  end

  # 1 minute
  # @timeout 60_000
  @timeout 60_000

  def update() do
    GenServer.call(@name, :update, @timeout)
  end

  # --- Internal API ---

  def handle_call(:update, _, _) do

    # "https://www.youtube.com/channel/UCq7BdmVpQsay5XrwOgMhN5w" fwbc

    {:ok, youtube_items} = YoutubeMetaDataFetcher.fetch_playlist_item_list_metadata("UUq7BdmVpQsay5XrwOgMhN5w")

    user = Repo.get_by(User, email: "michael@olivetree.app")

    Enum.each(youtube_items, fn item ->
      case get_video_by_url(item.url) do
      nil ->
          create!(user, item.url)
      end

    end)



    # fetch_timeout = 10000
    # Logger.debug("moderation handle_call :update")

    # url = "http://localhost:4000/v1.3/books?language-id=en&offset=1&limit=50"
    # %HTTPoison.Response{body: body} = HTTPoison.get!(url, %{}, hackney: [recv_timeout: fetch_timeout , timeout: fetch_timeout])
    # Logger.info(body)

    # UserAction
    # |> join(:inner, [a], uf in ModerationUserFeedback, uf.action_id == a.id)
    # |> select([a, uf], %{
    #   action: %{
    #     id: a.id,
    #     user_id: a.user_id,
    #     type: a.type,
    #     entity: a.entity,
    #     comment_id: a.comment_id
    #   },
    #   results: %{
    #     nb_feedbacks: count(uf.id),
    #     feedbacks_sum: sum(uf.value)
    #   }
    # })
    # |> having([_, uf], count(uf.id) >= @min_nb_feedbacks_to_process_entry)
    # |> group_by([a, _], a.id)
    # |> Repo.all(log: false)
    # |> Enum.map(&put_score_in_results/1)
    # |> Enum.filter(&filter_with_consensus/1)
    # |> Enum.map(&put_flag_reason_in_results/1)
    # |> log_update()
    # |> Enum.map(&process_entry/1)

    # credo:disable-for-previous-line

    {:reply, :ok, :ok}
  end

  #   # Delete all flags and punish all users for abusive flags
  #   Flag
  #   |> where([f], f.action_id == ^action.id)
  #   |> Repo.delete_all(returning: [:source_user_id])
  #   # Repo.delete_all returns a tuple like {nb_updated, entries}
  #   |> elem(1)
  #   |> Enum.map(&Map.get(&1, :source_user_id))
  #   |> record_flags_results(Comment.type(comment), :abused_flag)

  #   # Delete all feedbacks
  #   Repo.delete_all(where(ModerationUserFeedback, [f], f.action_id == ^action.id))
  # end

  # Record the flag result for all users
  # defp record_flags_results(flagging_users_ids, entity_type, action_type) do
  #   targets = Enum.map(flagging_users_ids, &%{target_user_id: &1})

  #   Repo.insert_all(
  #     UserAction,
  #     Enum.map(targets, fn params ->
  #       Map.merge(params, %{
  #         user_id: nil,
  #         type: action_type,
  #         entity: entity_type,
  #         inserted_at: Ecto.DateTime.utc()
  #       })
  #     end)
  #   )
  # end
end

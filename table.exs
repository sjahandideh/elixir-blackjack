Code.require_file "player.exs"

defmodule Table do
  import Player
  
  def start do
    {:ok, table} = GenServer.start __MODULE__, []
    table
  end

  def join(table, player) do
    GenServer.cast table, {:add_player, player}
  end

  def leave(table, player) do
    GenServer.cast table, {:remove_player, player}
  end

  def deal(table) do
    GenServer.cast table, :deal
  end

  def winner(table) do
    GenServer.call table, :winner
  end

  # --- Server methods

  use GenServer

  def init(_args) do
    {:ok, %{players: []}}
  end

  def handle_cast({:add_player, player}, state) do
    players = [player | state.players]
    {:noreply, :ok, %{players: players}}
  end

  def handle_cast({:remove_player, player}, state) do
    players = List.delete state.players, player
    {:noreply, :ok, %{players: players}}
  end

  def handle_cast(:deal, state) do
    Enum.each(state.players, fn(player) ->
      Player.deal player
    end)

    {:noreply, :ok, state}
  end

  def handle_call(:winner, _from, state) do
    {:noreply, (state.players |> winner_sofar), state}
  end

  defp winner_sofar(players) do
    Enum.max_by(players, fn(player) ->
      Player.sum player
    end)
  end
end

# table = Table.start
# p1 = Player.start
# p2 = Player.start
#
# Table.join(table, p1)
# Table.join(table, p2)
# Table.deal(table)
# Player.hand(p1) --> [3, 6]
# Player.hand(p2) --> [10, 'Jack']
#
# Table.leave(table, p2)
# Table.join(table, p3)

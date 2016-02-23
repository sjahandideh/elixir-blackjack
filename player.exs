defmodule Player do

  def start do
    {:ok, player} = GenServer.start __MODULE__, []
    player
  end

  def deal(player) do
    IO.puts "dealing player: #{player}"
    GenServer.call player, :deal
  end

  def hit(player) do
    GenServer.call player, :hit
  end

  def hand(player) do
    GenServer.call player, :hand
  end

  def sum(player) do
    GenServer.call player, :sum
  end

  def stand(player) do
    GenServer.call player, :sum
  end

  # --- Server methods

  use GenServer

  def init(_args) do
    {:ok, []}
  end

  def handle_call(:deal, _from, _cards) do
    deal = [pick_random_card, pick_random_card]

    {:reply, deal, deal}
  end

  def handle_call(:hit, _from, cards) do
    hit = pick_random_card

    {:reply, hit, [hit|cards]}
  end

  def handle_call(:hand, _from, cards) do
    {:reply, cards, cards}
  end

  def handle_call(:sum, _from, cards) do
    sum = Enum.reduce(cards, 0, fn(x, acc) ->
      card_value(x) + acc
    end)

    {:reply, sum, cards}
  end

  @cards %{
    1 => "Ace",
    2 => 2,
    3 => 3,
    4 => 4,
    5 => 5,
    6 => 6,
    7 => 7,
    8 => 8,
    9 => 9,
    10 => 10,
    11 => "Jack",
    12 => "Queen",
    13 => "King"
  }

  defp pick_random_card do
    :random.seed(:erlang.now()) # prevents same random sequence
    @cards[:random.uniform(13)]
  end

  defp card_value("King"),  do: 10
  defp card_value("Queen"), do: 10
  defp card_value("Jack"),  do: 10
  defp card_value("Ace"),   do: 1
  defp card_value(num),     do: num
end

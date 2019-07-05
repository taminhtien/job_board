defmodule JobBoard.Storage do
  use GenServer

  @table_name :storage

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    :ets.new(@table_name, [:set, :public, :named_table, read_concurrency: true])
    {:ok, %{}}
  end

  def upsert(issue) do
    :ets.insert(@table_name, {issue.number, issue})
    # GenServer.cast(__MODULE__, {:upsert, issue})
  end

  def get(issue_number) do
    case :ets.lookup(@table_name, issue_number) do
      [{^issue_number, issue}] -> issue
      [] -> nil
    end
    # GenServer.call(__MODULE__, {:get, issue_number})
  end

  def list() do
    :ets.select(@table_name, [{{:"$1", :"$2"}, [], [:"$2"]}])
    # GenServer.call(__MODULE__, {:list})
  end

  # def handle_cast({:upsert, issue}, issues) do
  #   issues = Map.put(issues, issue.number, issue)

  #   {:noreply, issues}
  # end

  # def handle_call({:get, issue_number}, _from, issues) do
  #   {:reply, Map.get(issues, issue_number), issues}
  # end

  # def handle_call({:list}, _from, issues) do
  #   list_issues = Enum.map(issues, fn {_number, issue} -> issue end)

  #   {:reply, list_issues, issues}
  # end
end

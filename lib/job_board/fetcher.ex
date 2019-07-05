defmodule JobBoard.Fetcher do
  use GenServer
  require Logger

  alias JobBoard.Storage

  def start_link(_) do
    GenServer.start_link(__MODULE__, [])
  end

  def init(_) do
    send(self(), :fetch)

    {:ok, []}
  end

  def handle_info(:fetch, state) do
    # Process.send_after(self(), :fetch, 10_000)
    Logger.info("its time to fetch")

    req_url = "https://api.github.com/repos/awesome-jobs/vietnam/issues"
    req_headers = [
      {"accept", "application/json"}
    ]
    req_options = [:with_body]

    case :hackney.request(:get, req_url, req_headers, [], req_options) do
      {:ok, 200, _resp_headers, resp_body} ->
        case Jason.decode(resp_body) do
          {:ok, payload} ->
            issues = Enum.map(payload, fn issue ->
              %{
                  "title" => issue_title,
                  "body" => issue_body,
                  "number" => issue_number
                } = issue

              Storage.upsert(%{number: issue_number, title: issue_title, body: issue_body})
            end)
          {:error, exception} ->
            Logger.warn("Could not decode response body: reason: " <> Exception.message(exception))
        end

      {:ok, status, _resp_headers, _resp_body} ->
        Logger.warn("Received Unexpected status: #{inspect(status)}")

      {:error, reason} ->
        Logger.error("Could not reach Github API, reason: #{inspect(reason)}")
    end

    {:noreply, state}
  end
end

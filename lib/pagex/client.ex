defmodule Pagex.Client do
  @moduledoc """
  Client for executing HTTP requests to the Pagerduty API.
  """

  alias Pagex.{Config, Utils}

  @base_headers [
    {"accept", "application/vnd.pagerduty+json;version=2"},
    {"content-type", "application/json"},
  ]

  def get(url, headers \\ [], options \\ []) do
    hh = headers ++ build_headers()

    url
    |> HTTPoison.get(hh, options)
    |> Utils.handle_json_response()
  end

  def post(url, body, headers \\ [], options \\ []) do
    hh = headers ++ build_headers()

    url
    |> HTTPoison.post(body, hh, options)
    |> Utils.handle_json_response()
  end

  defp build_headers do
    @base_headers ++ [
      {"authorization", "Token token=#{get_api_key()}"},
    ]
  end

  # TODO: use cache so these are faster
  defp get_api_key, do: Config.get(:api_key)
  defp get_from, do: Config.get(:from)
end

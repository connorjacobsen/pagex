defmodule Pagex.EventsBypass do
  @moduledoc false

  alias Plug.Conn
  alias Pagex.BypassHelper

  def mock_response(fun), do: BypassHelper.mock_response(Pagex.Events, fun)

  # TODO: move into __using__ macro
  def respond_with_json(json, status \\ 200) do
    mock_response(fn(conn) -> 
      json_response(conn, status, json)
    end)
  end

  def json_response(conn, status, json) do
    conn
    |> Conn.put_resp_header("content-type", "application/json")
    |> Conn.resp(status, json)
  end

  def accepted_response(conn) do
    json_response(conn, 202, Poison.encode!(accepted_response_body()))
  end

  defp accepted_response_body do
    %{
      status: "success",
      message: "Event processed",
      dedup_key: "samplekeyhere"
    }
  end

  def bad_request(conn) do
    json_response(conn, 400, Poison.encode!(bad_request_body()))
  end

  defp bad_request_body do
    %{
      status: "invalid event",
      message: "Event object is invalid",
      errors: [
        "Length of 'routing_key' is incorrect (should be 32 characters)"
      ]
    }
  end

  def too_many_requests(conn) do
    conn
    |> Conn.put_resp_header("content-type", "application/json")
    |> Conn.send_resp(429, "")
  end
end

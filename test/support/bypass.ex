defmodule Pagex.Bypass do
  @moduledoc false

  alias Plug.Conn
  alias Pagex.BypassHelper

  def mock_response(fun), do: BypassHelper.mock_response(Pagex, fun)

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
end

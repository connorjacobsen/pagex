defmodule Pagex.Utils do
  @doc false

  import Pagex.Config, only: [get: 1]

  def resolve_uri(path) do
    uri =
      :uri
      |> get()
      |> build_uri()
    %{uri | path: path}
  end

  def handle_json_response({:ok, %HTTPoison.Response{status_code: code} = resp}) when code < 400 do
    case Poison.decode(resp.body) do
      {:ok, _} = result -> result
      {:error, _reason} = err -> err
      err -> err
    end
  end
  def handle_json_response({:ok, %HTTPoison.Response{status_code: code} = resp}) when code >= 400 do
    case Poison.decode(resp.body) do
      {:ok, result} -> {:error, result}
      {:error, _reason} = err -> err
      err -> err
    end
  end
  def handle_json_response({:error, _reason} = resp), do: resp

  defp build_uri(:bypass) do
    case :ets.lookup(:bypass_registry, {Pagex, :bypass}) do
      [{_, bypass}] ->
        %URI{
          host: "localhost",
          port: bypass.port,
          scheme: "http",
        }
      [] -> %URI{}
    end
  end
  defp build_uri(uri), do: to_uri(uri)

  defp to_uri(%URI{} = uri), do: uri
  defp to_uri(uri_string) when is_binary(uri_string), do: URI.parse(uri_string)

  @doc false
  def to_map(enum) do
    List.foldl(enum, %{}, fn({k, v}, acc) ->
      case is_nil(v) do
        true -> acc
        _ -> Map.put(acc, k, v)
      end
    end)
  end
end

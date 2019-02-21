defmodule Pagex.Config do
  @moduledoc """
  Helpers for working with configuration for pagex.
  """

  @doc """
  Get the configuration for the given `key` from the pagex config.
  """
  def get(key), do: resolve_key(key)

  defp resolve_key(key) do
    :pagex
    |> Application.get_env(key)
    |> resolve_value()
  end

  # TODO: build out documentation so this can be used more widely.
  @doc false
  def resolve_value({:system, value}), do: System.get_env(value)
  def resolve_value({m, f, a}) when is_atom(m) and is_atom(f), do: apply(m, f, a)
  def resolve_value(v), do: v
end

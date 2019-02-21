defmodule Pagex.BypassHelper do
  @moduledoc """
  Provide helpers to start a bypass server for an API module.

  Hat tip to @hassox
  """

  def mock_response(mod, fun) do
    mod
    |> bypass_for()
    |> Bypass.expect(fun)
  end
  def mock_response(mod, method, path, fun) do
    mod
    |> bypass_for()
    |> Bypass.expect(method, path, fun)
  end
  def mock_response_once(mod, method, path, fun) do
    mod
    |> bypass_for()
    |> Bypass.expect_once(method, path, fun)
  end

  def bypass_for(mod) do
    {mod, :bypass}
    |> Process.get()
    |> find_or_create_bypass(mod)
  end

  defp find_or_create_bypass(nil, mod) do
    bypass = Bypass.open()
    :ets.insert(:bypass_registry, {{mod, :bypass}, bypass})
    bypass
  end
  defp find_or_create_bypass(bypass, _mod), do: bypass
end

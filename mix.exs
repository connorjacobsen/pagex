defmodule Pagex.MixProject do
  use Mix.Project

  @url "https://github.com/connorjacobsen/pagex"

  def project do
    [
      app: :pagex,
      version: "0.1.0",
      elixir: "~> 1.6",
      description: "Elixir client for the Pagerduty API",
      start_permanent: Mix.env() == :prod,
      homepage_url: @url,
      source_url: @url,
      deps: deps(),
      package: package(),
      elixirc_paths: elixirc_paths(Mix.env),
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:bypass, "~> 1.0", only: :test},
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:httpoison, ">= 0.9.0"},
      {:plug, "~> 1.7", only: :test},
      {:poison, ">= 3.0.0"},
    ]
  end

  defp package do
    [
      maintainers: ["Connor Jacobsen"],
      licenses: ["MIT"],
      links: %{github: @url},
      files: ~w(lib) ++ ~w(mix.exs README.md LICENSE),
    ]
  end
end

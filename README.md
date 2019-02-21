# Pagex

[![Hex.pm](https://img.shields.io/hexpm/v/pagex.svg)](https://hex.pm/packages/pagex) [![API Docs](https://img.shields.io/badge/api-docs-yellow.svg?style=flat)](http://hexdocs.pm/pagex/) [![Build Status](https://travis-ci.org/connorjacobsen/pagex.svg?branch=master)](https://travis-ci.org/connorjacobsen/pagex)

Elixir client for V2 of the Pagerduty REST API.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `pagex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:pagex, "~> 0.1.0"}
  ]
end
```

## Usage

Configuration pagex for your application is simple, you only need to pass in your API Key and the Pagerduty base URI.

```elixir
config :pagex,
  api_key: "SOME-API-KEY",
  uri: "https://api.pagerduty.com"
```

Configurable URIs are useful for testing.

You can also use the `{:system, "ENV_VAR_NAME"}` pattern to force pagex to lookup the value from the environment at run time.

```elixir
config :pagex,
  api_key: {:system, "PAGERDUTY_API_KEY"},
  uri: {:system, "PAGERDUTY_URI"}
```

Creating an incident is simple:

```elixir
iex> Pagex.Incidents.create("Test Incident!", "MyServiceID", "me@example.org)
```

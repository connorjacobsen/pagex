defmodule Pagex.Incidents do
  @moduledoc """
  Client for the Incidents API v2 from Pagerduty.
  """

  import Pagex.Client, only: [post: 3]
  alias Pagex.Utils

  @type response() :: {:ok, map()} | {:error, map()} | {:error, String.t()}

  @doc """
  Create a new Incident.

    * `title` - A succinct description of the nature, symptoms, cause or effect
                of the incident.
    * `service` - The incident will be created on this service.
    * `from` - The email address from the Pagerduty user to be associated with
      the triggering of the request.

  ## Options

    * `urgency` - The urgency of the incident. Can be `:high` or `:low`.
    * `incident_key` - A string which identifies the incident. Sending
       subsequent requests referencing the same service and with the same
       `incident_key` will result in those requests being rejected if an open
       incident matches that `incident_key`.

  ## Examples

    iex> Pagex.Incidents.create("Test", "MyServiceID", "user@example.com")
  """
  @spec create(String.t(), String.t(), String.t(), Keyword.t()) :: response()
  def create(title, service, from, _opts \\ []) do
    params = %{
      type: "incident",
      title: title,
      service: %{
        type: "service",
        id: service
      },
    }
    payload = Poison.encode!(%{incident: params})

    "/incidents"
    |> build_uri()
    |> URI.to_string()
    |> post(payload, [{"from", from}])
  end

  defp build_uri(path), do: Utils.resolve_uri(path)
end

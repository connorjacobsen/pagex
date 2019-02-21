defmodule Pagex.IncidentsTest do
  use ExUnit.Case
  alias Pagex.{Bypass, Incidents}

  @incident_response %{
    "incident" => %{
      "acknowledgements" => [],
      "alert_counts" => %{"all" => 0, "resolved" => 0, "triggered" => 0},
      "alert_grouping" => nil,
      "assignments" => [
        %{
          "assignee" => %{
            "html_url" => "https://foo.pagerduty.com/users/ABCABC",
            "id" => "ABCABC",
            "self" => "https://api.pagerduty.com/users/ABCABC",
            "summary" => "John Doe",
            "type" => "user_reference"
          },
          "at" => "2019-02-20T23:04:29Z"
        }
      ],
      "basic_alert_grouping" => nil,
      "created_at" => "2019-02-20T23:04:29Z",
      "description" => "Testing!",
      "escalation_policy" => %{
        "html_url" => "https://opendoor.pagerduty.com/escalation_policies/ABC123",
        "id" => "ABC123",
        "self" => "https://api.pagerduty.com/escalation_policies/ABC123",
        "summary" => "Some Team",
        "type" => "escalation_policy_reference"
      },
      "first_trigger_log_entry" => %{
        "html_url" => "https://foo.pagerduty.com/incidents/P7T8L6X/log_entries/R0OSTBWYEU523LDKH08IPGOF6H",
        "id" => "R0OSTBWYEU523LDKH08IPGOF6H",
        "self" => "https://api.pagerduty.com/log_entries/R0OSTBWYEU523LDKH08IPGOF6H",
        "summary" => "Triggered through the website",
        "type" => "trigger_log_entry_reference"
      },
      "html_url" => "https://foo.pagerduty.com/incidents/P6X8L1T",
      "id" => "P6X8L1T",
      "impacted_services" => [
        %{
          "html_url" => "https://foo.pagerduty.com/services/P7V2RDX",
          "id" => "P7V2RDX",
          "self" => "https://api.pagerduty.com/services/P7V2RDX",
          "summary" => "Service A",
          "type" => "service_reference"
        }
      ],
      "incident_key" => "3a1e725640ff4c5f8eede5ce977d0a58",
      "incident_number" => 12345,
      "incidents_responders" => [],
      "is_mergeable" => true,
      "last_status_change_at" => "2019-02-20T23:04:29Z",
      "last_status_change_by" => %{
        "html_url" => "https://foo.pagerduty.com/services/P7V2RDX",
        "id" => "P3N9RDX",
        "self" => "https://api.pagerduty.com/services/P7V2RDX",
        "summary" => "Service A",
        "type" => "service_reference"
      },
      "pending_actions" => [
        %{"at" => "2019-02-20T23:34:29Z", "type" => "escalate"},
        %{"at" => "2019-02-21T03:04:29Z", "type" => "resolve"}
      ],
      "responder_requests" => [],
      "self" => "https://api.pagerduty.com/incidents/P3N9RDX",
      "service" => %{
        "html_url" => "https://foo.pagerduty.com/services/P3N9RDX",
        "id" => "P3N9RDX",
        "self" => "https://api.pagerduty.com/services/P3N9RDX",
        "summary" => "Knox",
        "type" => "service_reference"
      },
      "status" => "triggered",
      "subscriber_requests" => [],
      "summary" => "[#12345] testing!",
      "teams" => [
        %{
          "html_url" => "https://foo.pagerduty.com/teams/PLSXHQ1",
          "id" => "PLSXHQ1",
          "self" => "https://api.pagerduty.com/teams/PLSXHQ1",
          "summary" => "Foo Engineering",
          "type" => "team_reference"
        }
      ],
      "title" => "Testing!",
      "type" => "incident",
      "urgency" => "high"
    }
  }

  describe "create/3" do
    test "success" do
      Bypass.mock_response(fn conn ->
        assert "/incidents" == conn.request_path
        Bypass.json_response(conn, 201, Poison.encode!(@incident_response))
      end)

      assert {:ok, resp} = Incidents.create("Testing!", "some-service-key", "foo@example.com")
      assert "incident" == resp["incident"]["type"]
      assert "Testing!" == resp["incident"]["title"]
    end

    test "bad request" do
      msg = "You must specify a user's email address in the \"From\" header to perform this action"
      Bypass.mock_response(fn conn ->
        assert "/incidents" == conn.request_path
        Bypass.json_response(conn, 400, Poison.encode!(%{
          message: msg,
          code: 2016,
        }))
      end)

      assert {:error, resp} = Incidents.create("Testing!", "some-service-key", "foo@example.com")
      assert msg == resp["message"]
    end
  end
end

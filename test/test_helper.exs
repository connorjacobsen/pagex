ExUnit.start()
Application.ensure_all_started(:bypass)

# Cross-process key value store for Bypasses
:ets.new(:bypass_registry, [:named_table, :set, :public])

Mox.defmock(FEx.APIs.Fixer.Mock, for: FEx.APIs.Fixer)
Application.put_env(:fex, :fixer, FEx.APIs.Fixer.Mock)

ExUnit.configure(exclude: [:fixer_api])
ExUnit.start()

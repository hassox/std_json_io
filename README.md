# StdJsonIo

Starts a pool of workers that communicate with an external script via JSON over
STDIN/STDOUT.

Originally written to use [react-stdio](https://github.com/mjackson/react-stdio)
but can be used with any process that reads a JSON object from STDIN and outputs
JSON on STDOUT.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `std_json_io` to your list of dependencies in `mix.exs`:

        def deps do
          [{:std_json_io, "~> 0.1.0"}]
        end

  2. Ensure `std_json_io` is started before your application:

        def application do
          [applications: [:std_json_io]]
        end

### Setup

Define a module and use StdJsonIo.

```elixir
defmodule MyApp.ReactIo do
  use StdJsonIo, otp_app: :my_app
end
```

When you use `StdJsonIo` your module becomes a supervisor. You'll need to add it
to your supervision tree.

```elixir
children = [
  # snip
  supervisor(MyApp.ReactIo, [])
]

opts = [strategy: :one_for_one, name: MyApp]

Supervisor.start_link(children, opts)
```


### Configuration

You can either configure as additional arguments of the use statement, or in your config file.

```elixir
config :my_app, MyApp.ReactIo,
  pool_size: 20, # default 5
  max_overflow: 10, # default 10
  script: "path/to/script", # for react-io use "react-stdio"
  watch_files: [
    Path.join([__DIR__, "../priv/server/js/component.js"]) # do not watch files in dev
  ]
```

* `script` - the script to run for the IO server
* `watch_files` - A list of files to watch for changes. When the file changes,
  kill the IO worker and restart, picking up any changes. Use only in dev.
* `pool_size` - The size for the pool of workers - See poolboy `size`
* `max_overflow` - The poolboy `max_overflow`


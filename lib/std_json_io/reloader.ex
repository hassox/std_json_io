defmodule StdJsonIo.Reloader do
  use GenServer

  def start_link(mod, files) do
    GenServer.start_link(__MODULE__, [mod, files], name: {:local, __MODULE__})
  end

  def init([mod, files]) do
    :fs.subscribe()
    {:ok, %{files: files, mod: mod}}
  end

  def handle_info({_, {:fs, :file_event}, {path, _}}, %{files: files, mod: mod} = state) do
    if Enum.member?(files, path |> to_string) do
      mod.restart_io_workers!
    end
    {:noreply, state}
  end

  def handle_info(msg, state) do
    {:noreply, state}
  end
end

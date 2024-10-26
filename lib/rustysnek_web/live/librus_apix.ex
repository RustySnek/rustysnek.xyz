defmodule RustysnekWeb.LibrusApix do
  use RustysnekWeb, :live_view
  import RustysnekWeb.Components.Static.Sections

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :page_title, "librus_apix")}
  end
end

defmodule RustysnekWeb.Kotkowo do
  use RustysnekWeb, :live_view
  import RustysnekWeb.Components.Static.Sections

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end

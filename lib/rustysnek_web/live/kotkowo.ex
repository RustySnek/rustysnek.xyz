defmodule RustysnekWeb.Kotkowo do
  use RustysnekWeb, :live_view
  import RustysnekWeb.Components.ProjectComponents

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :page_title, "Kotkowo")}
  end
end

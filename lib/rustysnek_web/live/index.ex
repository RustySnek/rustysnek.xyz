defmodule RustysnekWeb.Index do
  use RustysnekWeb, :live_view
  import RustysnekWeb.Components.Static.Sections
  import RustysnekWeb.Components.ProjectComponents

  attr :description, :string, required: true
  attr :name, :string, required: true
  attr :location, :string, required: true
  attr :github, :string, required: true
  attr :license, :any, default: :gplv3
  attr :tags, :list, default: []

  def project(assigns) do
    ~H"""
    <.project_card name={@name} default_license={@license}>
      <:tags>
        <.tag :for={tag <- @tags} name={tag} />
      </:tags>
      <:description>
        <%= raw(@description) %>
      </:description>
      <:footer>
        <.view_project_button to={@location} />
        <.github_link url={@github} />
      </:footer>
    </.project_card>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :page_title, "Pascal Jodłowski")}
  end
end

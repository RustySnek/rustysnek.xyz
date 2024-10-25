defmodule RustysnekWeb.Components.Static.Sections do
  use Phoenix.Component

  attr :name, :string

  def skill(assigns) do
    ~H"""
    <div class="bg-gray-700 rounded-lg p-4 text-center transition-all duration-300 ease-in-out transform hover:scale-105 hover:bg-primary-700">
      <%= @name %>
    </div>
    """
  end

  attr :anchor, :string
  attr :content, :string

  def list_item(assigns) do
    ~H"""
    <li class="transition-all duration-300 ease-in-out transform hover:translate-x-2">
      <a href={@anchor} class="text-fuchsia-400 hover:text-fuchsia-300">
        <%= @content %>
      </a>
    </li>
    """
  end
end

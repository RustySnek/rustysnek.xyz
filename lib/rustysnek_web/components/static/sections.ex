defmodule RustysnekWeb.Components.Static.Sections do
  use Phoenix.Component

  attr :name, :string

  def skill(assigns) do
    ~H"""
    <div class="glass glass-card rounded-lg p-4 text-center text-neon-purple-light neon-border transition-all duration-300 ease-in-out transform hover:scale-105">
      <%= @name %>
    </div>
    """
  end

  attr :anchor, :string
  attr :content, :string

  def list_item(assigns) do
    ~H"""
    <li class="transition-all duration-300 ease-in-out transform hover:translate-x-2">
      <a href={@anchor} class="text-neon-purple-light hover:text-neon-purple-glow hover:drop-shadow-[0_0_10px_rgba(168,85,247,0.8)]">
        <%= @content %>
      </a>
    </li>
    """
  end
end

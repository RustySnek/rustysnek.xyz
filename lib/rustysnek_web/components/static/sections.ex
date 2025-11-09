defmodule RustysnekWeb.Components.Static.Sections do
  use Phoenix.Component

  attr :name, :string

  def skill(assigns) do
    ~H"""
    <div class="glass glass-card rounded-lg p-4 text-center text-neon-purple-light skill-card transition-all duration-300 ease-in-out transform hover:scale-105">
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

  @doc """
  Timeline item component for professional experience.
  
  ## Examples
  
      <.timeline_item
        company="Company Name"
        role="Software Developer"
        period="2020 - 2023"
        responsibilities={["Built X", "Maintained Y", "Improved Z"]}
      />
  """
  attr :company, :string, required: true
  attr :role, :string, required: true
  attr :period, :string, required: true
  attr :responsibilities, :list, default: []

  def timeline_item(assigns) do
    ~H"""
    <div class="relative flex items-start gap-4 sm:gap-6 pb-8 sm:pb-12 last:pb-0">
      <!-- Timeline line -->
      <div class="flex flex-col items-center flex-shrink-0">
        <!-- Timeline dot -->
        <div class="relative z-10 w-4 h-4 sm:w-5 sm:h-5 rounded-full glass-strong neon-border border-2 flex items-center justify-center transition-all duration-300 hover:scale-125 hover:border-neon-purple-glow">
          <div class="w-2 h-2 sm:w-3 sm:h-3 rounded-full bg-neon-purple-glow shadow-[0_0_10px_rgba(192,132,252,0.8)]"></div>
        </div>
        <!-- Timeline line -->
        <div class="w-0.5 sm:w-1 h-full bg-gradient-to-b from-neon-purple/50 to-transparent mt-2"></div>
      </div>

      <!-- Content card -->
      <div class="flex-1 glass glass-card rounded-xl sm:rounded-2xl p-4 sm:p-6 neon-border transition-all duration-300 hover:shadow-neon-purple-sm hover:scale-[1.02]">
        <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-2 mb-3">
          <h3 class="text-xl sm:text-2xl font-bold neon-text"><%= @company %></h3>
          <span class="text-sm sm:text-base text-neon-purple-light/70 font-medium"><%= @period %></span>
        </div>
        <p class="text-base sm:text-lg text-neon-purple-light mb-4 font-medium"><%= @role %></p>
        
        <%= if @responsibilities != [] do %>
          <ul class="space-y-2 text-sm sm:text-base text-neon-purple-light/90">
            <li :for={responsibility <- @responsibilities} class="flex items-start gap-2">
              <svg class="w-4 h-4 sm:w-5 sm:h-5 text-neon-cyan flex-shrink-0 mt-0.5" fill="currentColor" viewBox="0 0 20 20">
                <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
              </svg>
              <span><%= responsibility %></span>
            </li>
          </ul>
        <% end %>
      </div>
    </div>
    """
  end

  @doc """
  Timeline container component.
  
  ## Examples
  
      <.timeline>
        <.timeline_item ... />
        <.timeline_item ... />
      </.timeline>
  """
  attr :class, :string, default: ""

  slot :inner_block, required: true

  def timeline(assigns) do
    ~H"""
    <div class={["relative", @class]}>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end
end

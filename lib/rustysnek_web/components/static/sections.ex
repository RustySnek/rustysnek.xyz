defmodule RustysnekWeb.Components.Static.Sections do
  use Phoenix.Component

  attr :name, :string

  def skill(assigns) do
    ~H"""
    <div class="glass glass-card rounded-lg p-4 text-center text-ink skill-card transition-all duration-300 ease-in-out transform hover:scale-105">
      <%= @name %>
    </div>
    """
  end

  attr :anchor, :string
  attr :content, :string

  def list_item(assigns) do
    ~H"""
    <li class="transition-all duration-300 ease-in-out transform hover:translate-x-2">
      <a href={@anchor} class="text-ink-muted hover:text-neon-purple-glow hover:drop-shadow-neon">
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
          <div class="w-2 h-2 sm:w-3 sm:h-3 rounded-full bg-neon-purple-glow shadow-neon-dot"></div>
        </div>
        <!-- Timeline line -->
        <div class="w-0.5 sm:w-1 h-full bg-gradient-to-b from-neon-purple/50 to-transparent mt-2"></div>
      </div>

      <!-- Content card -->
      <div class="flex-1 glass glass-card rounded-xl sm:rounded-2xl p-4 sm:p-6 neon-border transition-all duration-300 hover:shadow-neon-purple-sm hover:scale-[1.02]">
        <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-2 mb-3">
          <h3 class="text-xl sm:text-2xl font-bold neon-text"><%= @company %></h3>
          <span class="text-sm sm:text-base text-ink-muted font-medium"><%= @period %></span>
        </div>
        <p class="text-base sm:text-lg text-ink mb-4 font-medium"><%= @role %></p>
        
        <%= if @responsibilities != [] do %>
          <ul class="space-y-2 text-sm sm:text-base text-ink">
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
  Education card component.

  A self-contained card (graduation-cap badge + institution / degree / period)
  purpose-built for the Education section, rather than reusing the experience
  timeline which expects several stacked, responsibility-bearing entries.

  ## Examples

      <.education_item
        institution="Some University"
        degree="BEng Computer Science"
        specialization="Artificial Intelligence Engineering"
        period="2026 – 2030"
        note="in progress"
      />
  """
  attr :institution, :string, required: true
  attr :degree, :string, required: true
  attr :specialization, :string, default: nil
  attr :period, :string, required: true
  attr :note, :string, default: nil

  def education_item(assigns) do
    ~H"""
    <div class="glass glass-card rounded-2xl p-5 sm:p-7 neon-border transition-all duration-300 hover:shadow-neon-purple-sm hover:scale-[1.02]">
      <div class="flex items-start gap-3 sm:gap-5">
        <div class="flex-shrink-0 w-10 h-10 sm:w-14 sm:h-14 rounded-xl sm:rounded-2xl glass-strong neon-border flex items-center justify-center">
          <svg
            class="w-6 h-6 sm:w-7 sm:h-7 text-neon-purple-glow drop-shadow-neon"
            fill="none"
            stroke="currentColor"
            stroke-width="1.5"
            viewBox="0 0 24 24"
            aria-hidden="true"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              d="M4.26 10.147a60.438 60.438 0 0 0-.491 6.347A48.62 48.62 0 0 1 12 20.904a48.62 48.62 0 0 1 8.232-4.41 60.46 60.46 0 0 0-.491-6.347m-15.482 0a50.636 50.636 0 0 0-2.658-.813A59.906 59.906 0 0 1 12 3.493a59.903 59.903 0 0 1 10.399 5.84c-.896.248-1.783.52-2.658.814m-15.482 0A50.717 50.717 0 0 1 12 13.489a50.702 50.702 0 0 1 7.74-3.342M6.75 15a.75.75 0 1 0 0-1.5.75.75 0 0 0 0 1.5Zm0 0v-3.675A55.378 55.378 0 0 1 12 8.443m-7.007 11.55A5.981 5.981 0 0 0 6.75 15.75v-1.5"
            />
          </svg>
        </div>
        <div class="min-w-0 flex-1">
          <h3 class="text-lg sm:text-xl md:text-2xl font-bold neon-text"><%= @institution %></h3>
          <span class="inline-flex items-center gap-1.5 mt-2.5 px-3 py-1 rounded-full text-sm sm:text-base font-medium text-ink glass-light border border-neon-purple/30 whitespace-nowrap max-w-full">
            <svg class="w-3.5 h-3.5 sm:w-4 sm:h-4 shrink-0" fill="none" stroke="currentColor" stroke-width="1.5" viewBox="0 0 24 24" aria-hidden="true">
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                d="M12 6.042A8.967 8.967 0 0 0 6 3.75c-1.052 0-2.062.18-3 .512v14.25A8.987 8.987 0 0 1 6 18c2.305 0 4.408.867 6 2.292m0-14.25a8.966 8.966 0 0 1 6-2.292c1.052 0 2.062.18 3 .512v14.25A8.987 8.987 0 0 0 18 18a8.967 8.967 0 0 0-6 2.292m0-14.25v14.25"
              />
            </svg>
            <%= @degree %>
          </span>
          <p :if={@specialization} class="mt-2 text-sm sm:text-base text-ink-muted">
            Specialization: <span class="text-neon-purple-light font-bold"><%= @specialization %></span>
          </p>
          <div class="flex justify-end mt-3 sm:mt-4">
            <span class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs sm:text-sm text-ink glass-light border border-neon-purple/30 whitespace-nowrap">
              <svg class="w-3.5 h-3.5 sm:w-4 sm:h-4" fill="none" stroke="currentColor" stroke-width="1.5" viewBox="0 0 24 24" aria-hidden="true">
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  d="M6.75 3v2.25M17.25 3v2.25M3 18.75V7.5a2.25 2.25 0 0 1 2.25-2.25h13.5A2.25 2.25 0 0 1 21 7.5v11.25m-18 0A2.25 2.25 0 0 0 5.25 21h13.5A2.25 2.25 0 0 0 21 18.75m-18 0v-7.5A2.25 2.25 0 0 1 5.25 9h13.5A2.25 2.25 0 0 1 21 11.25v7.5"
                />
              </svg>
              <%= @period %><%= if @note, do: " · #{@note}" %>
            </span>
          </div>
        </div>
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

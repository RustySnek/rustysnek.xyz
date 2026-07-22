defmodule RustysnekWeb.Components.ProjectComponents do
  @moduledoc """
  Reusable components for displaying project cards with customizable elements.
  """
  use Phoenix.Component

  @doc """
  Enum for standard license types with display information.
  """
  defmodule LicenseType do
    @moduledoc """
    Enum-like module for license types with associated metadata.
    """
    @type t :: :gplv3 | :mit | :apache | :bsd | :custom

    @spec display_name(t()) :: String.t()
    def display_name(:gplv3), do: "GPLv3"
    def display_name(:mit), do: "MIT"
    def display_name(:apache), do: "Apache 2.0"
    def display_name(:bsd), do: "BSD"
    def display_name(:custom), do: "Custom"

    @spec all() :: [t()]
    def all(), do: [:gplv3, :mit, :apache, :bsd, :custom]
  end

  @doc """
  A single tag badge component for project technologies/categories.
  
  ## Examples
  
      <.tag name="Elixir" />
      <.tag name="Phoenix LiveView" variant={:primary} />
  """
  attr :name, :string, required: true
  attr :variant, :atom, default: :default, values: [:default, :primary, :secondary]

  def tag(assigns) do
    variant_classes = variant_classes(assigns.variant)

    ~H"""
    <span class={["px-2 py-1 text-xs md:text-sm font-semibold rounded-full border", variant_classes]}>
      <%= @name %>
    </span>
    """
  end

  defp variant_classes(:default),
    do: "text-ink-muted glass-light border-neon-purple/30"

  defp variant_classes(:primary),
    do: "text-ink-muted glass-light border-neon-purple/50"

  defp variant_classes(:secondary),
    do: "text-ink-muted glass border-neon-purple/20"

  @doc """
  License badge component that displays a license with an icon.
  
  ## Examples
  
      <.license_badge license={:gplv3} />
      <.license_badge license="Custom License" />
  """
  attr :license, :any, required: true

  def license_badge(assigns) do
    license_text = format_license(assigns.license)

    ~H"""
    <div class="flex mb-4 items-center text-ink-muted">
      <svg class="w-5 h-5 mr-2" fill="currentColor" viewBox="0 0 20 20">
        <path
          fill-rule="evenodd"
          d="M10 2a1 1 0 00-1 1v1.323l-3.954 1.582A1 1 0 004 6.868V16a1 1 0 001.5.866l4.5-1.8V16a1 1 0 001 1h4a1 1 0 001-1V6.868a1 1 0 00-1.046-.963L11 4.323V3a1 1 0 00-1-1zm1 7.5l4 1.6v4.9h-4v-6.5zm-6 .5l4-1.6v6.5l-4 1.6V10z"
          clip-rule="evenodd"
        >
        </path>
      </svg>
      <span><%= license_text %></span>
    </div>
    """
  end

  defp format_license(license) when is_atom(license), do: LicenseType.display_name(license)
  defp format_license("GPLv3"), do: LicenseType.display_name(:gplv3)
  defp format_license("MIT"), do: LicenseType.display_name(:mit)
  defp format_license("Apache"), do: LicenseType.display_name(:apache)
  defp format_license("BSD"), do: LicenseType.display_name(:bsd)
  defp format_license(license) when is_binary(license), do: license

  @doc """
  Project header component displaying title and tags.
  Uses slots for custom content.
  """
  attr :name, :string, required: true
  attr :class, :string, default: ""

  slot :tags, doc: "Slot for tag components"
  slot :inner_block, doc: "Slot for additional header content"

  def project_header(assigns) do
    ~H"""
    <div>
      <h3 class={["text-3xl md:text-4xl font-bold font-quicksand neon-text mb-2", @class]}>
        <%= @name %>
      </h3>
      <div :if={@tags != []} class="flex flex-wrap gap-2 mb-2">
        <%= render_slot(@tags) %>
      </div>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  @doc """
  Project footer component with customizable action buttons.
  Uses slots for custom actions.
  """
  attr :class, :string, default: ""

  slot :actions, doc: "Slot for action buttons/links"
  slot :inner_block, doc: "Slot for additional footer content"

  def project_footer(assigns) do
    ~H"""
    <div class={["px-6 -m-4 py-4 glass-strong flex justify-between items-center", @class]}>
      <%= if @actions != [] do %>
        <%= render_slot(@actions) %>
      <% else %>
        <%= render_slot(@inner_block) %>
      <% end %>
    </div>
    """
  end

  @doc """
  Standard "View Project" link button.
  """
  attr :to, :string, required: true
  attr :label, :string, default: "View Project"
  attr :class, :string, default: ""

  def view_project_button(assigns) do
    ~H"""
    <.link
      navigate={@to}
      class={[
        "inline-flex text-lg font-bold items-center px-4 py-2 text-sm font-medium neon-button rounded-lg transition-all duration-300",
        @class
      ]}
    >
      <%= @label %>
    </.link>
    """
  end

  @doc """
  Standard GitHub link button.
  """
  attr :url, :string, required: true
  attr :class, :string, default: ""

  def github_link(assigns) do
    ~H"""
    <a
      rel="noopener noreferrer"
      target="_blank"
      href={@url}
      class={[
        "text-ink-muted hover:text-neon-purple-glow transition-all duration-300 flex items-center hover:drop-shadow-neon",
        @class
      ]}
    >
      <svg class="w-5 h-5 mr-2" fill="currentColor" viewBox="0 0 20 20">
        <path
          fill-rule="evenodd"
          d="M10 0C4.477 0 0 4.477 0 10c0 4.42 2.865 8.166 6.839 9.489.5.092.682-.217.682-.482 0-.237-.008-.866-.013-1.7-2.782.603-3.369-1.34-3.369-1.34-.454-1.156-1.11-1.463-1.11-1.463-.908-.62.069-.608.069-.608 1.003.07 1.531 1.03 1.531 1.03.892 1.529 2.341 1.087 2.91.831.092-.646.35-1.086.636-1.336-2.22-.253-4.555-1.11-4.555-4.943 0-1.091.39-1.984 1.029-2.683-.103-.253-.446-1.27.098-2.647 0 0 .84-.269 2.75 1.025A9.564 9.564 0 0110 4.844c.85.004 1.705.114 2.504.336 1.909-1.294 2.747-1.025 2.747-1.025.546 1.377.203 2.394.1 2.647.64.699 1.028 1.592 1.028 2.683 0 3.842-2.339 4.687-4.566 4.935.359.309.678.919.678 1.852 0 1.336-.012 2.415-.012 2.743 0 .267.18.578.688.48C17.137 18.163 20 14.418 20 10c0-5.523-4.477-10-10-10z"
          clip-rule="evenodd"
        >
        </path>
      </svg>
      GitHub
    </a>
    """
  end

  @doc """
  Main project card component with customizable slots.
  
  ## Examples
  
      <.project_card name="My Project" default_license={:gplv3}>
        <:tags>
          <.tag name="Elixir" />
          <.tag name="Phoenix" />
        </:tags>
        <:description>
          This is a great project!
        </:description>
        <:footer>
          <.view_project_button to={~p"/project"} />
          <.github_link url="https://github.com/user/repo" />
        </:footer>
      </.project_card>
  """
  attr :name, :string, required: true
  attr :class, :string, default: ""
  attr :height, :string, default: "min-h-[20rem]"
  attr :default_license, :any, default: nil

  slot :tags, doc: "Slot for tag components"
  slot :description, doc: "Slot for project description"
  slot :license, doc: "Slot for custom license badge (overrides default_license attribute)"
  slot :header, doc: "Slot for custom header content"
  slot :footer, doc: "Slot for footer actions"
  slot :inner_block, doc: "Slot for additional content"

  def project_card(assigns) do
    ~H"""
    <div
      class={[
        "p-4 flex flex-col justify-between glass glass-card rounded-lg overflow-hidden shadow-neon-purple-sm transition-all duration-300 ease-in-out transform hover:scale-105 neon-border",
        @height,
        @class
      ]}
    >
      <div>
        <%= if @header != [] do %>
          <%= render_slot(@header) %>
        <% else %>
          <.project_header name={@name}>
            <:tags>
              <%= render_slot(@tags) %>
            </:tags>
          </.project_header>
        <% end %>

        <div :if={@description != []} class="text-ink mb-4">
          <%= render_slot(@description) %>
        </div>

        <%= render_slot(@inner_block) %>
      </div>
      <div>
        <%= cond do %>
          <% @license != [] -> %>
            <%= render_slot(@license) %>
          <% @default_license != nil -> %>
            <.license_badge license={@default_license} />
          <% true -> %>
        <% end %>

        <%= if @footer != [] do %>
          <div class="px-6 -m-4 py-4 glass-strong flex justify-between items-center">
            <%= render_slot(@footer) %>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  @doc """
  Page wrapper for project detail pages: outer padding, centered column
  and a "back to projects" link that scrolls to the projects section.
  """
  slot :inner_block, required: true

  def project_page(assigns) do
    ~H"""
    <div class="relative z-10 font-inter p-4 sm:p-6 md:p-10">
      <div class="max-w-5xl mx-auto">
        <.link
          navigate="/"
          data-section="projects"
          class="nav-section-link inline-flex items-center gap-1.5 text-sm text-ink-muted hover:text-neon-purple-glow transition-all duration-300 hover:drop-shadow-neon mb-4"
        >
          <svg class="w-4 h-4" fill="none" stroke="currentColor" stroke-width="1.5" viewBox="0 0 24 24" aria-hidden="true">
            <path stroke-linecap="round" stroke-linejoin="round" d="M10.5 19.5L3 12m0 0l7.5-7.5M3 12h18" />
          </svg>
          Back to projects
        </.link>
        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end

  @doc """
  Hero card for project detail pages: title, optional subtitle,
  a row of action links and the project description.

  ## Examples

      <.project_hero title="Elixirus 📔" subtitle="A better LMS interface">
        <:links>
          <.project_link href="https://..." label="Live" icon={:live} primary />
          <.project_link href="https://github.com/..." label="GitHub" icon={:github} />
        </:links>
        Elixirus is a web application ...
      </.project_hero>
  """
  attr :title, :string, required: true
  attr :subtitle, :string, default: nil

  slot :links, doc: "Slot for project_link action pills"
  slot :inner_block, doc: "Project description"

  def project_hero(assigns) do
    ~H"""
    <div class="glass glass-card rounded-3xl p-6 sm:p-8 md:p-10 neon-border mb-6 sm:mb-8">
      <h1 class="text-3xl sm:text-4xl md:text-5xl font-quicksand neon-text-strong font-extrabold mb-3">
        <%= @title %>
      </h1>
      <h2 :if={@subtitle} class="text-ink text-lg sm:text-xl md:text-2xl mb-4">
        <%= @subtitle %>
      </h2>
      <div :if={@links != []} class="flex flex-wrap gap-2 sm:gap-3 my-5 sm:my-6">
        <%= render_slot(@links) %>
      </div>
      <div
        :if={@inner_block != []}
        class="text-base md:text-lg leading-relaxed text-ink space-y-4"
      >
        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end

  @doc """
  Compact action pill for project heroes (external links).
  """
  attr :href, :string, required: true
  attr :label, :string, required: true
  attr :icon, :atom, default: nil, values: [nil, :github, :docs, :live, :package]
  attr :primary, :boolean, default: false

  def project_link(assigns) do
    ~H"""
    <a
      rel="noopener noreferrer"
      target="_blank"
      href={@href}
      class={[
        if(@primary, do: "neon-button-gradient", else: "neon-button"),
        "inline-flex items-center gap-2 px-4 py-2 sm:px-5 sm:py-2.5 rounded-lg text-sm sm:text-base font-medium transition-all duration-300"
      ]}
    >
      <.link_icon :if={@icon} icon={@icon} />
      <span><%= @label %></span>
    </a>
    """
  end

  attr :icon, :atom, required: true

  defp link_icon(%{icon: :github} = assigns) do
    ~H"""
    <svg class="w-4 h-4 shrink-0" fill="currentColor" viewBox="0 0 20 20" aria-hidden="true">
      <path
        fill-rule="evenodd"
        d="M10 0C4.477 0 0 4.477 0 10c0 4.42 2.865 8.166 6.839 9.489.5.092.682-.217.682-.482 0-.237-.008-.866-.013-1.7-2.782.603-3.369-1.34-3.369-1.34-.454-1.156-1.11-1.463-1.11-1.463-.908-.62.069-.608.069-.608 1.003.07 1.531 1.03 1.531 1.03.892 1.529 2.341 1.087 2.91.831.092-.646.35-1.086.636-1.336-2.22-.253-4.555-1.11-4.555-4.943 0-1.091.39-1.984 1.029-2.683-.103-.253-.446-1.27.098-2.647 0 0 .84-.269 2.75 1.025A9.564 9.564 0 0110 4.844c.85.004 1.705.114 2.504.336 1.909-1.294 2.747-1.025 2.747-1.025.546 1.377.203 2.394.1 2.647.64.699 1.028 1.592 1.028 2.683 0 3.842-2.339 4.687-4.566 4.935.359.309.678.919.678 1.852 0 1.336-.012 2.415-.012 2.743 0 .267.18.578.688.48C17.137 18.163 20 14.418 20 10c0-5.523-4.477-10-10-10z"
        clip-rule="evenodd"
      />
    </svg>
    """
  end

  defp link_icon(%{icon: :docs} = assigns) do
    ~H"""
    <svg class="w-4 h-4 shrink-0" fill="none" stroke="currentColor" stroke-width="1.5" viewBox="0 0 24 24" aria-hidden="true">
      <path
        stroke-linecap="round"
        stroke-linejoin="round"
        d="M12 6.042A8.967 8.967 0 006 3.75c-1.052 0-2.062.18-3 .512v14.25A8.987 8.987 0 016 18c2.305 0 4.408.867 6 2.292m0-14.25a8.966 8.966 0 016-2.292c1.052 0 2.062.18 3 .512v14.25A8.987 8.987 0 0018 18a8.967 8.967 0 00-6 2.292m0-14.25v14.25"
      />
    </svg>
    """
  end

  defp link_icon(%{icon: :live} = assigns) do
    ~H"""
    <svg class="w-4 h-4 shrink-0" fill="none" stroke="currentColor" stroke-width="1.5" viewBox="0 0 24 24" aria-hidden="true">
      <path
        stroke-linecap="round"
        stroke-linejoin="round"
        d="M12 21a9.004 9.004 0 008.716-6.747M12 21a9.004 9.004 0 01-8.716-6.747M12 21c2.485 0 4.5-4.03 4.5-9S14.485 3 12 3m0 18c-2.485 0-4.5-4.03-4.5-9S9.515 3 12 3m0 0a8.997 8.997 0 017.843 4.582M12 3a8.997 8.997 0 00-7.843 4.582m15.686 0A11.953 11.953 0 0112 10.5c-2.998 0-5.74-1.1-7.843-2.918m15.686 0A8.959 8.959 0 0121 12c0 .778-.099 1.533-.284 2.253m-18.716-4.918A8.959 8.959 0 003 12c0 .778.099 1.533.284 2.253"
      />
    </svg>
    """
  end

  defp link_icon(%{icon: :package} = assigns) do
    ~H"""
    <svg class="w-4 h-4 shrink-0" fill="none" stroke="currentColor" stroke-width="1.5" viewBox="0 0 24 24" aria-hidden="true">
      <path
        stroke-linecap="round"
        stroke-linejoin="round"
        d="M21 7.5l-9-5.25L3 7.5m18 0l-9 5.25m9-5.25v9l-9 5.25M3 7.5l9 5.25M3 7.5v9l9 5.25m0-9v9"
      />
    </svg>
    """
  end

  @doc """
  Glass content section for project detail pages. Sections are meant to
  live inside a `md:grid-cols-2` grid; set `wide` to span both columns.
  """
  attr :id, :string, default: nil
  attr :title, :string, required: true
  attr :wide, :boolean, default: false

  slot :inner_block, required: true

  def project_section(assigns) do
    ~H"""
    <section
      id={@id}
      class={[
        "glass glass-card rounded-2xl p-5 sm:p-6 md:p-8 neon-border min-w-0",
        @wide && "md:col-span-2"
      ]}
    >
      <h3 class="text-xl md:text-2xl font-semibold mb-3 md:mb-4 neon-text"><%= @title %></h3>
      <div class="text-base md:text-lg text-ink leading-relaxed">
        <%= render_slot(@inner_block) %>
      </div>
    </section>
    """
  end
end


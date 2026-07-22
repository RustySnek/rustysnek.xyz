defmodule RustysnekWeb.Layouts do
  @moduledoc """
  This module holds different layouts used by your application.

  See the `layouts` directory for all templates available.
  The "root" layout is a skeleton rendered as part of the
  application router. The "app" layout is set as the default
  layout on both `use RustysnekWeb, :controller` and
  `use RustysnekWeb, :live_view`.
  """
  use RustysnekWeb, :html

  embed_templates "layouts/*"

  @doc "Per-colorscheme mascot icon."
  attr :theme, :string, required: true, values: ~w(ice violet emerald pink)
  attr :class, :any, default: nil

  def mascot(%{theme: "ice"} = assigns) do
    ~H"""
    <svg viewBox="0 0 64 64" class={@class} role="img" aria-label="Penguin mascot">
      <ellipse cx="9" cy="36" rx="7" ry="16" fill="#15151d" stroke="#38bdf8" stroke-width="2" transform="rotate(16 9 36)" />
      <ellipse cx="55" cy="36" rx="7" ry="16" fill="#15151d" stroke="#38bdf8" stroke-width="2" transform="rotate(-16 55 36)" />
      <ellipse cx="23" cy="58" rx="8" ry="4.5" fill="#fb923c" />
      <ellipse cx="41" cy="58" rx="8" ry="4.5" fill="#fb923c" />
      <ellipse cx="32" cy="31" rx="23" ry="28" fill="#15151d" stroke="#38bdf8" stroke-width="2.5" />
      <ellipse cx="32" cy="38" rx="15.5" ry="18" fill="#f3f0fa" />
      <circle cx="24.5" cy="19" r="5" fill="#ffffff" />
      <circle cx="39.5" cy="19" r="5" fill="#ffffff" />
      <circle cx="25.5" cy="19.5" r="2.4" fill="#15151d" />
      <circle cx="38.5" cy="19.5" r="2.4" fill="#15151d" />
      <path d="M 27.5 25.5 L 36.5 25.5 L 32 31.5 Z" fill="#fb923c" />
    </svg>
    """
  end

  def mascot(%{theme: "violet"} = assigns) do
    ~H"""
    <svg viewBox="0 0 64 64" class={@class} role="img" aria-label="Snake mascot">
      <path d="M16 52 C 44 52, 46 36, 31 32 C 16 28, 18 12, 44 14" fill="none" stroke="#a855f7" stroke-width="13" stroke-linecap="round" />
      <path d="M16 52 C 44 52, 46 36, 31 32 C 16 28, 18 12, 44 14" fill="none" stroke="#15151d" stroke-width="8.5" stroke-linecap="round" />
      <ellipse cx="46" cy="14" rx="9" ry="7.5" fill="#15151d" stroke="#a855f7" stroke-width="2.5" />
      <circle cx="48.5" cy="12" r="2.6" fill="#ffffff" />
      <circle cx="49.3" cy="12.3" r="1.2" fill="#15151d" />
      <path d="M54.5 15 C 58 15.5, 59.5 14, 61.5 13 M61.5 13 L 63.3 11.2 M61.5 13 L 63.6 14.6" fill="none" stroke="#f43f5e" stroke-width="1.8" stroke-linecap="round" />
    </svg>
    """
  end

  def mascot(%{theme: "emerald"} = assigns) do
    ~H"""
    <svg viewBox="0 0 64 64" class={@class} role="img" aria-label="Scarab mascot">
      <g stroke="#10b981" stroke-width="3" stroke-linecap="round" fill="none">
        <path d="M18 26 L 8 20" />
        <path d="M46 26 L 56 20" />
        <path d="M16 38 L 5 38" />
        <path d="M48 38 L 59 38" />
        <path d="M18 48 L 9 56" />
        <path d="M46 48 L 55 56" />
      </g>
      <path d="M27 9 C 25 5, 21 4, 18 6" stroke="#10b981" stroke-width="2.5" fill="none" stroke-linecap="round" />
      <path d="M37 9 C 39 5, 43 4, 46 6" stroke="#10b981" stroke-width="2.5" fill="none" stroke-linecap="round" />
      <circle cx="32" cy="13" r="7" fill="#15151d" stroke="#10b981" stroke-width="2.5" />
      <ellipse cx="32" cy="23" rx="12" ry="8" fill="#15151d" stroke="#10b981" stroke-width="2.5" />
      <ellipse cx="32" cy="42" rx="16" ry="17" fill="#15151d" stroke="#10b981" stroke-width="2.5" />
      <path d="M32 26 L 32 58" stroke="#10b981" stroke-width="2" opacity="0.55" />
      <path d="M24 33 C 22 40, 23 48, 26 53" stroke="#52d695" stroke-width="2" opacity="0.4" fill="none" stroke-linecap="round" />
    </svg>
    """
  end

  def mascot(%{theme: "pink"} = assigns) do
    ~H"""
    <svg viewBox="0 0 64 64" class={@class} role="img" aria-label="Sakura tree mascot">
      <path d="M30 60 C 31 50, 27 44, 23 36 M29 52 C 33 46, 38 42, 43 38 M27 46 C 22 42, 18 40, 14 39" stroke="#7c5642" stroke-width="4.5" fill="none" stroke-linecap="round" />
      <g fill="#ec4899">
        <circle cx="20" cy="30" r="10" />
        <circle cx="34" cy="22" r="11" />
        <circle cx="47" cy="30" r="9" />
        <circle cx="13" cy="38" r="6.5" />
        <circle cx="50" cy="40" r="6" />
      </g>
      <g fill="#f06fae" opacity="0.85">
        <circle cx="27" cy="24" r="4.5" />
        <circle cx="41" cy="27" r="4" />
        <circle cx="18" cy="35" r="3.2" />
      </g>
      <circle cx="48" cy="52" r="2" fill="#f06fae" />
      <circle cx="54" cy="58" r="1.6" fill="#ec4899" />
      <circle cx="10" cy="52" r="1.8" fill="#f06fae" />
    </svg>
    """
  end
end

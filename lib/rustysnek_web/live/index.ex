defmodule RustysnekWeb.Index do
  use RustysnekWeb, :live_view
  import RustysnekWeb.Components.Static.Sections

  attr :description, :string
  attr :name, :string
  attr :location, :string
  attr :github, :string
  attr :license, :string
  attr :tags, :list

  def project(assigns) do
    ~H"""
    <div class="p-4 h-80 flex flex-col justify-between bg-[#1f1f1f] rounded-lg overflow-hidden shadow-lg transition-all duration-300 ease-in-out transform hover:scale-105">
      <div>
        <h3 class="text-3xl md:text-4xl font-bold font-quicksand text-white mb-2"><%= @name %></h3>
        <div class="flex flex-wrap gap-2 mb-2">
          <span
            :for={tag <- @tags}
            class="px-2 py-1 text-xs md:text-sm font-semibold text-fuchsia-200 bg-fuchsia-800 rounded-full"
          >
            <%= tag %>
          </span>
        </div>
        <p class="text-gray-300 mb-4">
          <%= @description %>
        </p>
      </div>
      <div>
        <div class="flex mb-4 items-center text-gray-400">
          <svg
            class="w-5 h-5 mr-2"
            fill="currentColor"
            viewBox="0 0 20 20"
            xmlns="http://www.w3.org/2000/svg"
          >
            <path
              fill-rule="evenodd"
              d="M10 2a1 1 0 00-1 1v1.323l-3.954 1.582A1 1 0 004 6.868V16a1 1 0 001.5.866l4.5-1.8V16a1 1 0 001 1h4a1 1 0 001-1V6.868a1 1 0 00-1.046-.963L11 4.323V3a1 1 0 00-1-1zm1 7.5l4 1.6v4.9h-4v-6.5zm-6 .5l4-1.6v6.5l-4 1.6V10z"
              clip-rule="evenodd"
            >
            </path>
          </svg>
          <span><%= @license %></span>
        </div>
        <div class="px-6 -m-4 py-4 bg-[#1a1a1a] flex justify-between items-center">
          <.link
            navigate={@location}
            class="inline-flex text-lg font-bold items-center px-4 py-2 text-sm font-medium text-white bg-fuchsia-600 rounded-lg hover:bg-fuchsia-500 transition-colors duration-300"
          >
            View Project
          </.link>
          <a
            rel="noopener noreferrer"
            target="_blank"
            href={@github}
            class="text-fuchsia-400 hover:text-fuchsia-300 transition-colors duration-300 flex items-center"
          >
            <svg
              class="w-5 h-5 mr-2"
              fill="currentColor"
              viewBox="0 0 20 20"
              xmlns="http://www.w3.org/2000/svg"
            >
              <path
                fill-rule="evenodd"
                d="M10 0C4.477 0 0 4.477 0 10c0 4.42 2.865 8.166 6.839 9.489.5.092.682-.217.682-.482 0-.237-.008-.866-.013-1.7-2.782.603-3.369-1.34-3.369-1.34-.454-1.156-1.11-1.463-1.11-1.463-.908-.62.069-.608.069-.608 1.003.07 1.531 1.03 1.531 1.03.892 1.529 2.341 1.087 2.91.831.092-.646.35-1.086.636-1.336-2.22-.253-4.555-1.11-4.555-4.943 0-1.091.39-1.984 1.029-2.683-.103-.253-.446-1.27.098-2.647 0 0 .84-.269 2.75 1.025A9.564 9.564 0 0110 4.844c.85.004 1.705.114 2.504.336 1.909-1.294 2.747-1.025 2.747-1.025.546 1.377.203 2.394.1 2.647.64.699 1.028 1.592 1.028 2.683 0 3.842-2.339 4.687-4.566 4.935.359.309.678.919.678 1.852 0 1.336-.012 2.415-.012 2.743 0 .267.18.578.688.48C17.137 18.163 20 14.418 20 10c0-5.523-4.477-10-10-10z"
                clip-rule="evenodd"
              >
              </path>
            </svg>
            GitHub
          </a>
        </div>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end

// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix"
import { LiveSocket } from "phoenix_live_view"
import topbar from "../vendor/topbar"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: { _csrf_token: csrfToken }
})

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" })
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

window.addEventListener("phx:display_message", (event) => {
  const messagesContainer = document.getElementById("messages-container");

  // Create a new div for the message
  const messageElement = document.createElement("div");
  messageElement.id = event.detail.process;
  messageElement.innerText = event.detail.text; // Set the text from the event

  // Randomize rotation between -30 and 30 degrees
  const random_top = Math.random() * (messagesContainer.clientHeight + 400);
  const random_left = Math.random() * (messagesContainer.clientWidth - 200);

  const randomRotation = Math.random() * 80 - 30; // Random value between -30 and +30
  messageElement.style.transform = `rotate(${randomRotation}deg)`;
  messageElement.style.position = "absolute";
  messageElement.style.top = `${random_top}px`;
  messageElement.style.left = `${random_left}px`;
  messageElement.style.color = "#F313AB";
  messageElement.style.fontWeight = "bold";
  messageElement.style.zIndex = "20";
  messageElement.style.userSelect = 'none';

  messagesContainer.appendChild(messageElement); // Add the new message to the container

  // Set initial opacity
  messageElement.style.opacity = '1';

  // Hide the message after 2 seconds
  const duration = 2000;
  const intervalTime = 50; // Interval time in milliseconds
  const steps = duration / intervalTime; // Number of steps for opacity change
  let currentStep = 0;

  const opacityInterval = setInterval(() => {
    currentStep++;
    const opacityValue = Math.max(0, (1 - currentStep / steps)); // Decrease opacity

    messageElement.style.opacity = opacityValue;

    if (currentStep >= steps) {
      clearInterval(opacityInterval); // Clear interval when done
      messagesContainer.removeChild(messageElement); // Remove the message from the DOM
    }
  }, intervalTime);
});

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket


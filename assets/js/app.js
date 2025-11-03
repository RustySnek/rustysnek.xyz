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
window.addEventListener("phx:page-loading-stop", _info => {
  topbar.hide()
  
  // Check if we need to scroll to a section after navigation
  const scrollToSection = sessionStorage.getItem("scrollToSection")
  if (scrollToSection) {
    sessionStorage.removeItem("scrollToSection")
    // Use requestAnimationFrame for better performance
    requestAnimationFrame(() => {
      setTimeout(() => {
        const element = document.querySelector(`#${scrollToSection}`)
        if (element) {
          // Account for sticky header
          const headerOffset = 80
          const elementPosition = element.getBoundingClientRect().top
          const offsetPosition = elementPosition + window.pageYOffset - headerOffset
          
          window.scrollTo({
            top: offsetPosition,
            behavior: 'smooth'
          })
        }
      }, 150)
    })
  } else if (window.location.hash) {
    // Scroll to hash fragment after navigation if present (and we're not scrolling to a section)
    const element = document.querySelector(window.location.hash)
    if (element) {
      requestAnimationFrame(() => {
        setTimeout(() => {
          element.scrollIntoView({ behavior: 'smooth', block: 'start' })
        }, 100)
      })
    }
  }
})

// Handle scroll-to-section event from navigation buttons
window.addEventListener("scroll-to-section", (event) => {
  const section = event.detail?.section
  if (section) {
    const scrollToElement = () => {
      const element = document.querySelector(`#${section}`)
      if (element) {
        element.scrollIntoView({ behavior: 'smooth', block: 'start' })
      }
    }
    
    // If we're already on the home page, scroll immediately
    if (window.location.pathname === '/') {
      setTimeout(scrollToElement, 100)
    } else {
      // Otherwise wait for navigation to complete
      const handlePageLoad = () => {
        setTimeout(scrollToElement, 100)
        window.removeEventListener("phx:page-loading-stop", handlePageLoad)
      }
      window.addEventListener("phx:page-loading-stop", handlePageLoad)
    }
  }
})

// Handle clicks on navigation section links
document.addEventListener("click", (event) => {
  // Find the closest nav-section-link, handling clicks on the link itself or its children
  const link = event.target.closest(".nav-section-link")
  if (link && link.classList.contains("nav-section-link")) {
    const section = link.getAttribute("data-section")
    // Verify we got a valid section
    if (section && (section === "about" || section === "projects" || section === "skills")) {
      // Store section for scrolling after navigation
      sessionStorage.setItem("scrollToSection", section)
      
      // If we're already on the home page, prevent navigation and scroll immediately
      if (window.location.pathname === '/') {
        event.preventDefault()
        event.stopPropagation()
        const element = document.querySelector(`#${section}`)
        if (element) {
          // Use requestAnimationFrame for smoother scrolling
          requestAnimationFrame(() => {
            const headerOffset = 80
            const elementPosition = element.getBoundingClientRect().top
            const offsetPosition = elementPosition + window.pageYOffset - headerOffset
            
            // Use optimized smooth scroll
            window.scrollTo({
              top: offsetPosition,
              behavior: 'smooth'
            })
          })
        }
        sessionStorage.removeItem("scrollToSection")
      }
      // Otherwise, let navigation happen naturally - scrolling will occur after page-loading-stop
    }
  }
})

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


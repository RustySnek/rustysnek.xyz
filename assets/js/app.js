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
import { initTheme } from "./theme"

initTheme()

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: { _csrf_token: csrfToken }
})

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" })
window.addEventListener("phx:page-loading-start", _info => {
  // Match the progress bar to the active color scheme (canvas can't resolve CSS vars)
  const themeColor = getComputedStyle(document.documentElement).getPropertyValue("--theme-primary").trim()
  if (themeColor) topbar.config({ barColors: { 0: themeColor } })
  topbar.show(300)
})
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

// Mobile burger menu: delegated so it keeps working across LiveView navigations
document.addEventListener("click", (event) => {
  const menu = document.getElementById("mobile-menu")
  const toggle = document.getElementById("mobile-menu-toggle")
  if (!menu || !toggle) return

  const setOpen = (open) => {
    menu.classList.toggle("hidden", !open)
    toggle.setAttribute("aria-expanded", String(open))
  }

  if (event.target.closest("#mobile-menu-toggle")) {
    setOpen(menu.classList.contains("hidden"))
    return
  }

  // Close on link click inside the menu, or on any click outside of it
  if (event.target.closest("#mobile-menu")) {
    if (event.target.closest("a")) setOpen(false)
    return
  }

  setOpen(false)
})

// Handle clicks on navigation section links
document.addEventListener("click", (event) => {
  // Find the closest nav-section-link, handling clicks on the link itself or its children
  const link = event.target.closest(".nav-section-link")
  if (link && link.classList.contains("nav-section-link")) {
    const section = link.getAttribute("data-section")
    // Verify we got a valid section
    if (section && ["about", "experience", "education", "projects", "skills"].includes(section)) {
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
  messageElement.style.color = "var(--theme-accent-glow, #F313AB)";
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

// Cursor tracking flashlight effect - GPU optimized
let cursorGlow = document.createElement('div')
cursorGlow.id = 'cursor-glow'
cursorGlow.style.cssText = `
  position: fixed;
  width: 400px;
  height: 400px;
  border-radius: 50%;
  background: radial-gradient(circle, color-mix(in srgb, var(--theme-primary) 15%, transparent) 0%, transparent 70%);
  pointer-events: none;
  z-index: 1;
  left: 0;
  top: 0;
  will-change: transform, opacity;
  filter: blur(40px);
  opacity: 0;
  transition: opacity 0.3s ease;
`
document.body.appendChild(cursorGlow)

let moveTimeout

document.addEventListener('mousemove', (e) => {
  // Use transform3d for GPU acceleration
  cursorGlow.style.transform = `translate3d(${e.clientX - 200}px, ${e.clientY - 200}px, 0)`
  cursorGlow.style.opacity = '1'
  
  clearTimeout(moveTimeout)
  moveTimeout = setTimeout(() => {
    cursorGlow.style.opacity = '0'
  }, 200)
})

// Hide on mouse leave
document.addEventListener('mouseleave', () => {
  cursorGlow.style.opacity = '0'
})

// Pause background animation during scroll for better performance
let scrollTimeout
let isScrolling = false

function handleScroll() {
  if (!isScrolling) {
    document.body.classList.add('scrolling')
    isScrolling = true
  }
  
  clearTimeout(scrollTimeout)
  scrollTimeout = setTimeout(() => {
    document.body.classList.remove('scrolling')
    isScrolling = false
  }, 150)
}

// Use passive listener for better scroll performance
window.addEventListener('scroll', handleScroll, { passive: true })
window.addEventListener('wheel', handleScroll, { passive: true })
window.addEventListener('touchmove', handleScroll, { passive: true })

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket


/*
 * application.js - importmap entrypoint
 */

import "@hotwired/turbo"

// optional: log when Turbo is ready
document.addEventListener("turbo:load", () => {
  console.log("Turbo is ready");
});

/*
 * application.js - importmap entrypoint
 */

import "@hotwired/turbo"

// optional: log when Turbo is ready
document.addEventListener("turbo:load", () => {
  console.log("Turbo is ready");
});

// password toggle (simple)
document.addEventListener("DOMContentLoaded", () => {
  document.querySelectorAll(".btn-toggle-password").forEach(btn => {
    btn.addEventListener("click", () => {
      const parent = btn.closest(".password-field");
      if (!parent) return;
      const input = parent.querySelector("input[type='password'], input[type='text']");
      if (!input) return;
      if (input.type === "password") {
        input.type = "text";
        btn.textContent = "非表示";
      } else {
        input.type = "password";
        btn.textContent = "表示";
      }
    });
  });
});

document.addEventListener("turbo:load", function() {
  document.querySelectorAll(".star-rating").forEach(function(group) {
    const inputs = group.querySelectorAll('input[type="radio"]');
    const labels = group.querySelectorAll('.star-label');

    function refresh() {
      labels.forEach(lbl => lbl.classList.remove('selected'));
      const checked = group.querySelector('input[type="radio"]:checked');
      if (checked) {
        const lab = group.querySelector(`.star-label[data-value="${checked.value}"]`);
        if (lab) lab.classList.add('selected');
      }
    }

    // initial state
    refresh();

    labels.forEach(lbl => {
      lbl.addEventListener('click', function(e) {
        // check the corresponding input
        const val = lbl.getAttribute('data-value');
        const input = group.querySelector(`input[value="${val}"]`);
        if (input) {
          input.checked = true;
          refresh();
        }
      });
    });

    inputs.forEach(inp => inp.addEventListener('change', refresh));
  });
});
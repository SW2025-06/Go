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

document.addEventListener("turbo:load", function() {
  // 初期化／イベント登録
  document.querySelectorAll(".star-rating").forEach(function(group) {
    const labels = Array.from(group.querySelectorAll(".star-label"));
    const inputs = Array.from(group.querySelectorAll("input[type='radio']"));

    function refresh() {
      const checked = inputs.find(i => i.checked);
      let value = checked ? parseInt(checked.value, 10) : 0;
      // clear
      labels.forEach(lbl => lbl.classList.remove("on"));
      // add .on to all labels with data-value <= value
      labels.forEach(lbl => {
        const v = parseInt(lbl.dataset.value, 10);
        if (v <= value) lbl.classList.add("on");
      });
    }

    // initial
    refresh();

    // clicking a label will toggle its input; we handle input change
    inputs.forEach(inp => {
      inp.addEventListener("change", refresh);
    });

    // also: clicking label visually gives immediate feedback (optional)
    labels.forEach(lbl => {
      lbl.addEventListener("mouseenter", () => {
        const hoverVal = parseInt(lbl.dataset.value, 10);
        labels.forEach(l => {
          if (parseInt(l.dataset.value, 10) <= hoverVal) l.classList.add("on");
          else l.classList.remove("on");
        });
      });
      lbl.addEventListener("mouseleave", refresh);
    });
  });
});

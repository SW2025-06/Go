import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["trigger", "menu", "current"];
  static values = { name: String }

  connect() {
    // デバッグ用（必要ならコメントアウト）
    // console.log("dropdown controller connected", this.element);
    // close on outside click
    this.outsideClickHandler = this.outsideClickHandler.bind(this);
  }

  toggle(e) {
    e.stopPropagation();
    if (this.menuTarget.classList.contains("show")) {
      this.close();
    } else {
      // close other dropdowns on page
      document.querySelectorAll('.menu.show').forEach(m => { if (m !== this.menuTarget) m.classList.remove('show'); });
      this.open();
    }
  }

  open() {
    this.menuTarget.classList.add("show");
    if (this.hasTriggerTarget) this.triggerTarget.setAttribute("aria-expanded","true");
    document.addEventListener("click", this.outsideClickHandler);
  }

  close() {
    this.menuTarget.classList.remove("show");
    if (this.hasTriggerTarget) this.triggerTarget.setAttribute("aria-expanded","false");
    document.removeEventListener("click", this.outsideClickHandler);
  }

  outsideClickHandler(e) {
    if (!this.element.contains(e.target)) this.close();
  }

  // when an li is clicked, this method is triggered by data-action on li
  select(e) {
    const li = e.currentTarget;
    const val = li.dataset.value || li.textContent.trim();

    // update visible text (the trigger's current span)
    const current = this.currentTarget || this.element.querySelector('[data-dropdown-target="current"]');
    if (current) current.textContent = val;

    this.close();
    // note: the <a> inside li will navigate (unless you preventDefault)
  }
}
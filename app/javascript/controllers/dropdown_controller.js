// app/javascript/controllers/dropdown_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["trigger", "menu", "current"];

  connect() {
    this.onDocumentClick = this.onDocumentClick.bind(this);
  }

  toggle(event) {
    event.stopPropagation();
    if (this.menuTarget.classList.contains("show")) {
      this.close();
    } else {
      this.open();
    }
  }

  open() {
    this.menuTarget.classList.add("show");
    this.triggerTarget.setAttribute("aria-expanded", "true");
    document.addEventListener("click", this.onDocumentClick);
  }

  close() {
    this.menuTarget.classList.remove("show");
    this.triggerTarget.setAttribute("aria-expanded", "false");
    document.removeEventListener("click", this.onDocumentClick);
  }

  onDocumentClick(e) {
    if (!this.element.contains(e.target)) this.close();
  }

  select(e) {
    // リンクをクリックするとページ遷移するのでここでは current を更新するだけ（navigation will proceed）
    const li = e.currentTarget;
    const v = li.dataset.value || li.textContent.trim();
    if (this.hasCurrentTarget) this.currentTarget.textContent = v;
    this.close();
  }
}

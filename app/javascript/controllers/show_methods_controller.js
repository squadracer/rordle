import { Controller } from "@hotwired/stimulus"

export default class ShowMethods extends Controller {
    initialize() {
    }

    connect() {
    }

    toggle() {
      document.getElementById("modal_turbo_frame").classList.toggle("toggle-list");
    }
}
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['seconds']

  initialize() {
    this.numberOfSeconds = 0;
  }

  connect() {
    setInterval(() => {
      this.numberOfSeconds += 1;
      this.secondsTarget.innerHTML = this.numberOfSeconds;
    }, 1000);
  }
}

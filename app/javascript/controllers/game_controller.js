import { Controller } from "@hotwired/stimulus"

export default class Game extends Controller {
    static values = {
      lineindex: Number
    }
    
    initialize() {
      this.pos = [this.lineindexValue, 0];
      this.answer = '';
      this.boundNext = this.next.bind(this);
    }

    connect(){
      window.addEventListener('keydown', this.boundNext);
    }

    disconnect() {
      window.removeEventListener('keydown', this.boundNext);
    }

    next(event) {
      const input = event.key.toUpperCase();
      const key = document.getElementById(this.pos.join('-'));

      if (input == "ENTER" && key === null) {
        const csrfToken = document.querySelector("[name='csrf-token']").content
        fetch('/games/answer', {
          method: 'POST',
          mode: 'cors',
          cache: 'no-cache',
          credentials: 'same-origin',
          headers: {
              'Content-Type': 'application/json',
              'X-CSRF-Token': csrfToken
          },
          body: JSON.stringify({ answer: this.answer })
        }).then (response => response.text()).then(html => Turbo.renderStreamMessage(html));
        this.answer = '';
      } else if (input == 'BACKSPACE' && this.pos[1] > 0) {
        if (key) key.classList.remove("border-blue-600");
        this.pos[1] -= 1;
        this.answer = this.answer.slice(0, -1);
        const next_key = document.getElementById(this.pos.join('-'));
        next_key.innerHTML = '';
        next_key.classList.add("border-blue-600");
      } else if (key && /^[A-Z_?!]$/.test(input) && !event.getModifierState("Control") && !event.getModifierState("Meta") && !event.getModifierState("Alt") && !event.getModifierState("AltGraph")) {
        this.answer += input;
        key.innerHTML = input;
        key.classList.remove("border-blue-600");
        this.pos[1] += 1;
        const next_key = document.getElementById(this.pos.join('-'));
        if (next_key) next_key.classList.add("border-blue-600");
      }
    }
}

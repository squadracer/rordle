import { Controller } from "@hotwired/stimulus"

export default class Game extends Controller {
    static values = {
      lineindex: Number,
      isvalidanswer: Boolean
    }
    
    initialize() {
      this.pos = [this.lineindexValue, 0];
      this.answer = '';
      this.boundNext = this.next.bind(this);
      this.isValidAnswer = this.isvalidanswerValue;
    }

    async connect(){
      window.addEventListener('keydown', this.boundNext);
      if (this.isValidAnswer == true) {
        await flipLetterAnimation(this.pos)
      } else {
        await wiggle(this.pos)
      }
    }

    disconnect() {
      window.removeEventListener('keydown', this.boundNext);
    }

    reset_line_index() {
      this.lineindexValue = 0;
      this.pos = [this.lineindexValue, 0];
    }

    next(event) {
      const input = event.key.toUpperCase();
      const key = document.getElementById(this.pos.join('-'));

      if (input == "ENTER" && key === null) {
        this.enterSolution()
      } else if (input == 'BACKSPACE' && this.pos[1] > 0) {
        this.removeLetter()
      } else if (key && /^[A-Z_?!]$/.test(input) && !event.getModifierState("Control") && !event.getModifierState("Meta") && !event.getModifierState("Alt") && !event.getModifierState("AltGraph")) {
        this.addLetter(event)
      }
    }

    addLetter(event) {
      const key = document.getElementById(this.pos.join('-'));
      const input = event.key?.toUpperCase() || event.params.payload;
      this.answer += input;
      key.innerHTML = input;
      key.classList.remove("border-blue-600");
      this.pos[1] += 1;
      const next_key = document.getElementById(this.pos.join('-'));
      if (next_key) next_key.classList.add("border-blue-600");
    }

    removeLetter() {
      const key = document.getElementById(this.pos.join('-'));
      if (key) key.classList.remove("border-blue-600");
      this.pos[1] -= 1;
      this.answer = this.answer.slice(0, -1);
      const next_key = document.getElementById(this.pos.join('-'));
      next_key.innerHTML = '';
      next_key.classList.add("border-blue-600");
    }

    enterSolution() {
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
      }).then(response => response.text()).then(html => Turbo.renderStreamMessage(html));
      this.answer = '';
    }
}

async function flipLetterAnimation(position) {
  const last_line_letters = document.getElementById("line-" + (position[0] - 1) )?.children || [];
  for(let i = 0; i < last_line_letters.length; i++) {
    last_line_letters[i].classList.add("bg-red-flip");
    last_line_letters[i].classList.add("border-red-flip");
  }

  for(let i = 0; i < last_line_letters.length; i++) {
    setTimeout(() => {
      last_line_letters[i].classList.add("flip");
      last_line_letters[i].classList.remove("bg-red-flip");
      last_line_letters[i].classList.remove("border-red-flip");
    }, 200 * i)
  }
}

async function wiggle(position) {
  const last_line_letters = document.getElementById("line-" + position[0] );
  last_line_letters.classList.add("wiggle");
}
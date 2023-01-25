import { Controller } from "@hotwired/stimulus"

export default class GameWon extends Controller {
    initialize() {
    }

    connect() {
      const jsConfetti = new JSConfetti();
      jsConfetti.addConfetti({
        emojis: ['❤️', '💎'],
        emojiSize: 30,
        confettiNumber: 70
      });
    }

    disconnect() {

    }
}
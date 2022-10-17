import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static values = {
      railsMethod: String
    }
    static targets = [ "name", "output" ]

    connect() {
        console.log("Hello, @rails_method!", this.railsMethodValue);
    }

    greet() {
        console.log("hello");
        this.outputTarget.textContent =
        `Hello, ${this.nameTarget.value}!`
    }
}
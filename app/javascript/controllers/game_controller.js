import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static values = {
      railsMethod: String
    }

    connect() {
        console.log("Rails method: ", this.railsMethodValue);
    }
}
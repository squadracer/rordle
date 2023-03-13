import { Controller } from "@hotwired/stimulus"

export default class ShareAnswers extends Controller {
    initialize() {
    }

    connect() {
    }

    copyToClipboard() {
      if (navigator && navigator.clipboard && navigator.clipboard.writeText) {
        const shareText = document.getElementById("share_text").innerText;
        console.log(shareText);
        return navigator.clipboard.writeText(shareText);
      }
      return Promise.reject('The Clipboard API is not available.');
    }
}
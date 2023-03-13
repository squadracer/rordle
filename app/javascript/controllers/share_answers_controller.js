import { Controller } from "@hotwired/stimulus"

export default class ShareAnswers extends Controller {
    initialize() {
    }

    connect() {
    }

    copyToClipboard() {
      if (navigator && navigator.clipboard && navigator.clipboard.writeText) {
        const toast = document.getElementById('copy-toast');
        toast.classList.add("show");
        setTimeout(() => { toast.classList.remove("show") }, 1500);
        const shareText = document.getElementById("share_text").innerText;
        return navigator.clipboard.writeText(shareText);
      }
      return Promise.reject('The Clipboard API is not available.');
    }
}
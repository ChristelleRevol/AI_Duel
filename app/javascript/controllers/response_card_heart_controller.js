import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="response-card-heart"
export default class extends Controller {
	static targets = ["content", "heart"];

	connect() {
		this.toggleHeartPosition(); // Vérifie au chargement uniquement
	}

	toggleHeartPosition() {
		if (this.contentTarget.scrollHeight > this.contentTarget.clientHeight) {
			this.heartTarget.classList.add("has-scrollbar");
		}
	}
}

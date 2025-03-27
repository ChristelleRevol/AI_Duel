import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="timer"
export default class extends Controller {
	static targets = ["timer"];

	connect() {
		console.log("conecteed!");

		this.secondsUntilEnd = this.timerTarget.dataset.secondsUntilEndValue;

		const now = new Date().getTime();
		this.endTime = new Date(now + this.secondsUntilEnd * 1000);

		this.timer = setInterval(this.timer.bind(this), 1000);
	}

	timer() {
		const now = new Date();
		const secondsRemaining = (this.endTime - now) / 1000;

		if (secondsRemaining <= 0) {
			clearInterval(this.timer);
			this.timerTarget.innerHTML = "Battle is Over!";
			return;
		}

		const secondsPerDay = 86400;
		const secondsPerHour = 3600;
		const secondsPerMinute = 60;

		const days = Math.floor(secondsRemaining / secondsPerDay);
		const hours = Math.floor(
			(secondsRemaining % secondsPerDay) / secondsPerHour,
		);
		const minutes = Math.floor(
			(secondsRemaining % secondsPerHour) / secondsPerMinute,
		);
		// const seconds = Math.floor(secondsRemaining % secondsPerMinute);

		// this.timerTarget.innerHTML = `${days} days, ${hours} hours, ${minutes} minutes`;
		// ${seconds} seconds

    let displayText = "";

    // Ajouter les jours uniquement si > 0
    if (days > 0) {
        displayText += `${days} days`;
    }

    // Ajouter les heures
    if (hours > 0 || displayText.length > 0) {
        displayText += (displayText.length > 0 ? ", " : "") + `${hours} hours`;
    }

    // Ajouter les minutes
        displayText += (displayText.length > 0 ? ", " : "") + `${minutes} minutes`;

    // Toujours ajouter les secondes
    // displayText += (displayText.length > 0 ? ", " : "") + `${seconds} seconds`;

    this.timerTarget.innerHTML = displayText;
	}
}

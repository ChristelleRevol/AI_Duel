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

		const secondsPerHour = 3600;
		const secondsPerMinute = 60;

		const hours = Math.floor(
			secondsRemaining / secondsPerHour,
		);
		const minutes = Math.floor(
			(secondsRemaining % secondsPerHour) / secondsPerMinute,
		);

    let displayText = "";

    if (hours > 0 || displayText.length > 0) {
        displayText += `${hours > 0 ? ` ${hours}` : ''} ${hours === 1 ? 'hour' : 'hours'}`;
    }

        displayText += (displayText.length > 0 ? " " : "") + `${minutes > 0 ? ` ${minutes}` : ''} ${minutes === 1 ? 'minute' : 'minutes'}`;

    this.timerTarget.innerHTML = displayText;
	}
}

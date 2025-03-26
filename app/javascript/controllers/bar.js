import { Controller } from "@hotwired/stimulus";
import { Chart } from "chart.js";

export default class extends Controller {
	connect() {
		console.log("I'm in");

		const worldPopulation = {
			men: 504,
			women: 496,
		};

		const labels = ["men", "women"];
		const data = [504, 496];

		new Chart(this.element, {
			type: "doughnut",
			data: {
				labels: labels,
				datasets: [
					{
						label: "for 1000 people",
						data: data,
						backgroundColor: [
							"rgb(255, 99, 132)",
							"rgb(54, 162, 235)",
							// "rgb(255, 205, 86)",
						],
						hoverOffset: 4,
					},
				],
			},
			// options: {
			// 	radius: "50%",
			// },
		});
	}
}

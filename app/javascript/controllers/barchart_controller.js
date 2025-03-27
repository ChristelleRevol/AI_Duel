import { Controller } from "@hotwired/stimulus";
import { Chart, registerables } from "chart.js";
Chart.register(...registerables);
// Connects to data-controller="barchart"
export default class extends Controller {
	connect() {
		console.log("bar chart damn");

		const worldPopulation = {
			men: 504,
			women: 496,
		};

		const labels = ["men", "women"];
		const data = [504, 496];

		new Chart(this.element, {
			type: "bar",
			data: {
				labels: labels,
				datasets: [
					{
						// label: "for 1000 people",
						data: data,
						backgroundColor: [
							"rgb(255, 99, 132)",
							"rgb(54, 162, 235)",
							"rgb(255, 205, 86)",
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

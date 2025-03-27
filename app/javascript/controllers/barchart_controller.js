import { Controller } from "@hotwired/stimulus";
import { Chart, registerables } from "chart.js";
import ChartDataLabels from "chartjs-plugin-datalabels";

Chart.register(...registerables);
// Chart.register(ChartDataLabels);
// Connects to data-controller="barchart"
export default class extends Controller {
	static values = {
		votecount: String,
		ranking: String,
	};
	connect() {
		console.log("I'm in");

		const labels = JSON.parse(this.rankingValue);
		const data = JSON.parse(this.votecountValue);

		new Chart(this.element, {
			type: "bar",
			data: {
				labels: labels,
				datasets: [
					{
						datalabels: {
							color: "#FFCE56",
						},
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
			options: {
				plugins: [ChartDataLabels],
				legend: {
					display: false, // Désactive la legend
				},
			},
		});

		console.log("Labels:", labels);
		console.log("Data:", data);
	}
}

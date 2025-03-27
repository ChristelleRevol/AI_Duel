import { Controller } from "@hotwired/stimulus";
import { Chart, registerables } from "chart.js";
import ChartDataLabels from "chartjs-plugin-datalabels";

Chart.register(...registerables);
Chart.register(ChartDataLabels);
// Connects to data-controller="barchart"
export default class extends Controller {
	static values = {
		votecount: String,
		ranking: String,
	};

	connect() {
		console.log("I'm in");

		Chart.defaults.plugins.legend.display = false;

		const labels = JSON.parse(this.rankingValue);
		const data = JSON.parse(this.votecountValue);

		new Chart(this.element, {
			type: "bar",
			data: {
				labels: labels,
				datasets: [
					{
						datalabels: {
							labels: {
								color: "blue",
							},
						},
						label: "",
						data: data,
						backgroundColor: [
							"rgb(255,204,98)",
							"rgb(0, 189, 187)",
							"rgb(0, 133, 131)",
						],
						hoverOffset: 4,
					},
				],
			},
			options: {
				scales: {
					x: {
						ticks: {
							color: "rgba(27,31,50,1)",
							font: {
								size: 20,
								weight: "bold",
							},
						},
						grid: { color: "rgba(27,31,50,1)" },
					},
					y: {
						ticks: {
							color: "rgb(12, 14, 34)",
							font: {
								size: 20,
								weight: "bold",
							},
						},
						grid: { color: "rgb(12, 14, 34)" },
					},
				},
				maintainAspectRatio: false, // Permet de définir une hauteur et largeur custom
				legend: {
					display: false, // Désactive la legend
				},
				tooltip: {
					titleColor: "white", // Couleur du titre dans le tooltip
					bodyColor: "white", // Couleur du texte du tooltip
					backgroundColor: "rgba(0, 0, 0, 0.7)", // Fond du tooltip
				},
				plugins: [ChartDataLabels],
			},
		});

		console.log("Labels:", labels);
		console.log("Data:", data);
	}
}

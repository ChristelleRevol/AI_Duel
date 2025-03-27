import { Controller } from "@hotwired/stimulus";
import { Chart, registerables } from "chart.js";
import ChartDataLabels from "chartjs-plugin-datalabels";

Chart.register(...registerables);
Chart.register(ChartDataLabels);
// Connects to data-controller="doughnut"
export default class extends Controller {
	static values = {
		models: String,
		votes: String,
	};

	connect() {
		console.log("I'm in");
		console.log("Labels:", this.modelsValue);

		const labels = JSON.parse(this.modelsValue);
		const data = JSON.parse(this.votesValue);

		new Chart(this.element, {
			type: "doughnut",
			data: {
				labels: labels,
				datasets: [
					{
						label: "votes rating",
						data: data,
						backgroundColor: [
							"rgb(255,204,98)",
							"rgb(0, 189, 187)",
							"rgb(0, 133, 131)",
						],
						borderColor: [
							"rgb(255,255,255)", // Blanc (par défaut)
							"rgb(255,255,255)",
							"rgb(255,255,255)",
						],
						borderWidth: 0, // Épaisseur de la bordure (mettre 0 pour supprimer)
						hoverOffset: 4,
					},
				],
			},
			options: {
				plugins: { legend: { display: true } },
				maintainAspectRatio: false, // Permet de définir une hauteur et largeur custom
			},
			plugins: [ChartDataLabels],
		});
	}
}

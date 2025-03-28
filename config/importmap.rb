# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "bootstrap", to: "bootstrap.min.js", preload: true
pin "@popperjs/core", to: "popper.js", preload: true
pin "flatpickr" # @4.6.13
pin "chart.js", to: "https://ga.jspm.io/npm:chart.js@4.2.0/dist/chart.js"
pin "@kurkle/color", to: "@kurkle--color.js" # @0.3.4
pin "chartjs-plugin-datalabels", to: "https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2.2.0/dist/chartjs-plugin-datalabels.esm.js"
pin "chart.js/helpers", to: "https://ga.jspm.io/npm:chart.js@4.4.8/helpers/helpers.js"


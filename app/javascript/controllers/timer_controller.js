import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="timer"
export default class extends Controller {
  static targets = ["timer"]

  connect() {
    console.log("conecteed!")

    this.secondsUntilEnd = this.timerTarget.dataset.secondsUntilEndValue

    const now = new Date().getTime()
    // const now = new Date(now + this.secondsUntilEnd * 1000)
    this.endTime = new Date(now + this.secondsUntilEnd * 1000);

    this.timer = setInterval(this.timer.bind(this), 1000)
  }

  timer() {
    const now = new Date()
    const secondsRemaining = (this.endTime - now) / 1000

    if (secondsRemaining <= 0 ) {
      clearInterval(this.timer)
      this.timerTarget.innerHTML = "Battle is Over!"
      return
    }

    const secondsPerDay = 86400
    const secondsPerHour = 3600
    const secondsPerMinute = 60

    const days = Math.floor(secondsRemaining / secondsPerDay)
    const hours = Math.floor((secondsRemaining % secondsPerDay) / secondsPerHour)
    const minutes = Math.floor((secondsRemaining % secondsPerHour) / secondsPerMinute)
    const seconds = Math.floor(secondsRemaining % secondsPerMinute)

    this.timerTarget.innerHTML = `${days} days, ${hours} hours, ${minutes} minutes, ${seconds} seconds`
  }
}

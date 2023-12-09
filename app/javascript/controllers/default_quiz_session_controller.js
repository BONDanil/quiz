import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="default-quiz-session"
export default class extends Controller {
  static targets = ["progressBar", "showAnswerBtn", "carousel", "answer"];
  static values = {index: Number}

  connect() {
    this.setProgressWidth(0);

    this.carouselTarget.addEventListener('slide.bs.carousel', event => {
      this.indexValue = event.to;
      this.setProgressWidth(this.indexValue);
      this.hideAnswer(event.from)
    })
  }

  setProgressWidth(slideIndex) {
    this.progressBarTarget.innerHTML = (slideIndex + 1).toString() +  '/' + this.answerTargets.length.toString();
    this.progressBarTarget.style.width = (slideIndex + 1) * (100 / this.answerTargets.length) + '%';
  }

  showAnswer() {
    this.answerTargets[this.indexValue].style.visibility = 'visible';
  }

  hideAnswer(index) {
    this.answerTargets[index].style.visibility = 'hidden';
  }
}

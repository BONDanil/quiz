import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="answers"
export default class extends Controller {
  static targets = ['ratingBtn']

  connect() {
    if(!this.all_answers_marked()) {
      $(this.ratingBtnTarget).hide();
    }
  }

  save() {
    if(this.all_answers_marked()) {
      $(this.ratingBtnTarget).show();
    }
  }

  all_answers_marked() {
    let forms = $('form');

    if (forms.length === 0) {
      return false;
    }

    let allFormsValid = true;

    forms.each(function() {
      let formValid = false;

      // Check if at least one radio button is checked within the form
      if ($(this).find('input[name="quiz_answer[correct]"]:checked').length > 0) {
        formValid = true;
      }

      // Update the overall validity of all forms
      allFormsValid = allFormsValid && formValid;
    });

    return allFormsValid;
  }
}

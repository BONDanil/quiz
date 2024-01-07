import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="categories"
export default class extends Controller {
  static targets = ['categoriesList']

  connect() {
  }

  click() {
    if ($(event.target).is(':checked')) {
      // Checked 'All categories'
      this.checkAll();
    } else {
      // Unchecked 'All categories'
      this.uncheckAll();
    }
  }

  checkAll() {
    $(this.categoriesListTarget).addClass('visually-hidden');
    $('input[name="quiz_session[category_ids][]"]').each(function() {
      this.checked = true;
    });
  }

  uncheckAll() {
    $(this.categoriesListTarget).removeClass('visually-hidden');
    $('input[name="quiz_session[category_ids][]"]').each(function() {
      this.checked = false;
    });
  }
}

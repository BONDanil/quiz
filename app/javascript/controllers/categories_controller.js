import { Controller } from "@hotwired/stimulus"
import { Tab } from "bootstrap"

// Connects to data-controller="categories"
export default class extends Controller {
  static targets = ['myCategories', 'generalCategories', 'selectedCount']

  connect() {
    this.launchTabs();
    this.recountSelected();
    this.listenCheckboxes();
  }

  launchTabs() {
    this.navLinks = $(this.element).find('.nav-link').get();
    this.navLinks.forEach(function (triggerEl) {
      let tabTrigger = new Tab(triggerEl);

      triggerEl.addEventListener('click', function (event) {
        event.preventDefault();
        tabTrigger.show();
      })
    });
  }

  listenCheckboxes() {
    this.element.addEventListener('change', () => {
      this.recountSelected();
    });
  }

  my() {
    let target = $(event.target);

    if (target.is(':checked')) {
      this.checkAll('my');
      target.parent().find('label.btn').get(0).innerHTML = 'Uncheck all';
    } else {
      this.uncheckAll('my');
      target.parent().find('label.btn').get(0).innerHTML = 'Check all';
    }
  }

  general() {
    let target = $(event.target);

    if (target.is(':checked')) {
      this.checkAll('general');
      target.parent().find('label.btn').get(0).innerHTML = 'Uncheck all';
    } else {
      this.uncheckAll('general');
      target.parent().find('label.btn').get(0).innerHTML = 'Check all';
    }
  }

  checkAll(option) {
    let categoriesList = option === 'my' ? $(this.myCategoriesTarget) : $(this.generalCategoriesTarget);

    categoriesList.find('input[name="quiz_session[category_ids][]"]').each(function() {
      this.checked = true;
    });
  }

  uncheckAll(option) {
    let categoriesList = option === 'my' ? $(this.myCategoriesTarget) : $(this.generalCategoriesTarget);

    categoriesList.find('input[name="quiz_session[category_ids][]"]').each(function() {
      this.checked = false;
    });
  }

  recountSelected() {
    this.selectedCountTarget.innerHTML = $('input[name="quiz_session[category_ids][]"]:checked').length;
  }
}

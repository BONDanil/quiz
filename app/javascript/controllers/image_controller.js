import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="image"
export default class extends Controller {
  connect() {
  }

  showImage(event) {
    let input = event.target;
    let reader = new FileReader();

    reader.onload = function (e) {
      $('#imagePreview')
          .attr('src', e.target.result)
          .height(200)
          .css("display", "block");
    };

    reader.readAsDataURL(input.files[0]);
  }
}

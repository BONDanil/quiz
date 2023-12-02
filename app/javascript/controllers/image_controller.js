import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="image"
export default class extends Controller {
  static targets = ['imageInput', 'imagePreview'];

  connect() {
  }

  showImage() {
    let reader = new FileReader();

    if (this.imageInputTarget.files && this.imageInputTarget.files[0]) {
      $('#deleteImageBtn').css("display", "none");

      reader.onload = this.previewImage;

      reader.readAsDataURL(this.imageInputTarget.files[0]);

      $("<button type=\"button\" class=\"btn-close\" aria-label=\"Close\" data-action='image#deleteImage' id='deleteImageBtn'></button>").insertAfter(imagePreview);
    }
    else {
      this.clearPreview();
    }
  }

  previewImage(e) {
    $(imagePreview)
        .attr('src', e.target.result)
        .height(200)
        .css("display", "block");
  }

  deleteImage() {
    if (this.imageInputTarget.files && this.imageInputTarget.files[0]) {
      $(this.imageInputTarget).val('');
    }

    this.clearPreview();
  }

  clearPreview() {
    $('#imagePreview').css("display", "none");
    $('#deleteImageBtn').css("display", "none");
  }
}

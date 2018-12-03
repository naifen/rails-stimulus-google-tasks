import { Controller } from "stimulus";

class HomeController extends Controller {
  static targets = ["credentials", "hiddenCredentials", "authCode"];

  private credentialsTarget: HTMLInputElement;
  private hiddenCredentialsTarget: HTMLInputElement;
  // private codeTarget: HTMLInputElement;

  getUrlFormSubmit() {
    this.hiddenCredentialsTarget.value = this.credentialsTarget.value;
  }

  authFormSubmit() {
    console.log("auth form submitted");
  }
}

export default HomeController;

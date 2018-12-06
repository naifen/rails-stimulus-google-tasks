import { Controller } from "stimulus";

class HomeController extends Controller {
  static targets = ["credentials", "hiddenCredentials", "authCode"];

  private credentialsTarget: HTMLInputElement;
  private hiddenCredentialsTarget: HTMLInputElement;
  private authCodeTarget: HTMLInputElement;

  urlFormSubmit(e: Event) {
    if (!this.credentialsTarget.value) {
      e.preventDefault();
      this.displayNotificationFor("Credentials cannot be empty.", "warning");
    } else {
      this.hiddenCredentialsTarget.value = this.credentialsTarget.value;
    }
  }

  authFormSubmit(e: Event) {
    if (!this.authCodeTarget.value) {
      e.preventDefault();
      this.displayNotificationFor(
        "Authentication code cannot be empty.",
        "warning"
      );
    }
  }

  private displayNotificationFor(content: string, type: string): void {
    const nav = document.querySelector("nav");
    const notificationDiv = document.createElement("div");
    notificationDiv.className = `notification-top-right notification is-${type}`;
    notificationDiv.innerHTML = `<button class="delete"></button>${content}`;
    document.body.insertBefore(notificationDiv, nav);
  }
}

export default HomeController;

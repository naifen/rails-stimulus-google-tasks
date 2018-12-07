import { Controller } from "stimulus";

class HomeController extends Controller {
  static targets = ["credentials", "hiddenCredentials", "authCode"];

  private credentialsTarget: HTMLInputElement;
  private hiddenCredentialsTarget: HTMLInputElement;
  private authCodeTarget: HTMLInputElement;

  connect() {
    document.body.addEventListener("ajax:success", this.xhrSuccessListener);
    document.body.addEventListener("ajax:error", this.xhrErrorListener);
  }

  disconnect() {
    document.body.removeEventListener("ajax:success", this.xhrSuccessListener);
    document.body.removeEventListener("ajax:error", this.xhrErrorListener);
  }

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

  // Rails-ujs event handlers, arrow function binds this to current context
  private xhrSuccessListener = (event: CustomEvent) => {
    const res = event.detail[0];
    if (res.display_notification) {
      this.displayNotificationFor(
        res.notification.content,
        res.notification.type
      );
    }
    if (res.is_manipulate_dom) {
      this.updateContentFor(res.selector, res.content, res.is_authorized);
    }
  };

  private xhrErrorListener = () => {
    this.displayNotificationFor(
      "Something went wrong please try again",
      "danger"
    );
  };

  // TODO make this more generic
  private updateContentFor(
    selector: string,
    content: string,
    isAuthorized: boolean
  ) {
    const target: HTMLAnchorElement = document.querySelector(selector);
    if (isAuthorized) {
      target.textContent = content; // Already authorized
    } else {
      target.href = content;
      target.textContent = "Get the authorization code";
    }
  }
}

export default HomeController;

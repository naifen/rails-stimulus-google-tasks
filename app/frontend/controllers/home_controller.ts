import { Controller } from "stimulus";
import FlashHelper from "../utils/flashHelper";

class HomeController extends Controller {
  static targets = ["credentials", "hiddenCredentials", "authCode"];

  private credentialsTarget: HTMLInputElement;
  private hiddenCredentialsTarget: HTMLInputElement;
  private authCodeTarget: HTMLInputElement;

  connect() {
    document.body.addEventListener("ajax:success", this.onXHRSuccess);
    document.body.addEventListener("ajax:error", this.onXHRError);
  }

  disconnect() {
    document.body.removeEventListener("ajax:success", this.onXHRSuccess);
    document.body.removeEventListener("ajax:error", this.onXHRError);
  }

  urlFormSubmit(e: Event) {
    if (!this.credentialsTarget.value) {
      e.preventDefault();
      const flash = new FlashHelper("Credentials cannot be empty!", "warning");
      flash.display();
    } else {
      this.hiddenCredentialsTarget.value = this.credentialsTarget.value;
    }
  }

  authFormSubmit(e: Event) {
    if (!this.authCodeTarget.value) {
      e.preventDefault();
      const flash = new FlashHelper(
        "Authentication code cannot be empty!",
        "warning"
      );
      flash.display();
    }
  }

  // Rails-ujs event handlers, arrow function binds this to current context
  private onXHRSuccess = (event: CustomEvent) => {
    const res = event.detail[0];
    if (res.is_display_notification) {
      const flash = new FlashHelper(
        res.notification.content,
        res.notification.type
      );
      flash.display();
    }
    if (res.is_manipulate_dom) {
      this.updateContentFor(res.selector, res.content, res.is_authorized);
    }
  };

  private onXHRError = () => {
    const flash = new FlashHelper(
      "Something went wrong please try again",
      "danger"
    );
    flash.display();
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

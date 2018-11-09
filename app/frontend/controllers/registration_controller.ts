import { Controller } from "stimulus";

class RegistrationController extends Controller {
  static targets = [
    "step1username",
    "step1email",
    "step1phone",
    "username",
    "email",
    "phone",
    "method"
  ];

  private step1usernameTarget: HTMLInputElement;
  private step1emailTarget: HTMLInputElement;
  private step1phoneTarget: HTMLInputElement;
  private methodTarget: HTMLElement;

  private usernameTarget: HTMLInputElement;
  private emailTarget: HTMLInputElement;
  private phoneTarget: HTMLInputElement;
  // private hasPhoneTarget: boolean;

  // TODO: add client side formats check, disable button when invalid
  // TODO: add server side availability check, disable button when invalid
  step1Submit(e: Event) {
    e.preventDefault();
    console.log(this.step1phoneTarget.value);

    this.usernameTarget.value = this.step1usernameTarget.value;
    this.emailTarget.value = this.step1emailTarget.value;
    this.phoneTarget.value = this.step1phoneTarget.value;
  }

  switchSignupMethod(e: Event) {
    e.preventDefault();
    const currentText = this.methodTarget.textContent;
    document
      .querySelector("#step1-form-email-filed")
      .classList.toggle("is-hidden");
    document
      .querySelector("#step1-form-phone-filed")
      .classList.toggle("is-hidden");
    this.methodTarget.textContent =
      currentText === "Use email instead"
        ? "Use phone instead"
        : "Use email instead";
  }
}

export default RegistrationController;

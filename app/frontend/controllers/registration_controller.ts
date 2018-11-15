import { Controller } from "stimulus";
import FormValidator from "../utils/formValidator";

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

  // TODO: validation check on blur after first submit, disable button on invalid
  // TODO: add server side availability check, disable button on taken
  // TODO: add password validation on blur
  step1Submit(e: Event) {
    e.preventDefault();

    const unameValidator = new FormValidator(this.step1usernameTarget);
    const emailValidator = new FormValidator(this.step1emailTarget);
    const phoneValidator = new FormValidator(this.step1phoneTarget);

    unameValidator.validateInputFieldFor("username", () => {
      this.usernameTarget.value = this.step1usernameTarget.value;
    });

    if (
      document
        .querySelector("#step1form-phone-filed")
        .classList.contains("is-hidden")
    ) {
      emailValidator.validateInputFieldFor("email", () => {
        this.emailTarget.value = this.step1emailTarget.value;
      });
      this.step1phoneTarget.value = "";
    } else {
      phoneValidator.validateInputFieldFor("phone", () => {
        this.phoneTarget.value = this.step1phoneTarget.value;
      });
      this.step1emailTarget.value = "";
    }
  }

  switchSignupMethod(e: Event) {
    e.preventDefault();

    this.emailTarget.value = "";
    this.phoneTarget.value = "";

    const currentText = this.methodTarget.textContent;
    this.methodTarget.textContent =
      currentText === "Use email instead"
        ? "Use phone instead"
        : "Use email instead";

    document
      .querySelector("#step1form-email-filed")
      .classList.toggle("is-hidden");
    document
      .querySelector("#step1form-phone-filed")
      .classList.toggle("is-hidden");
  }
}

export default RegistrationController;

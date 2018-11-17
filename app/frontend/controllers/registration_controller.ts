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
    "password",
    "pwConfirmation",
    "submit",
    "method"
  ];

  private step1usernameTarget: HTMLInputElement;
  private step1emailTarget: HTMLInputElement;
  private step1phoneTarget: HTMLInputElement;
  private usernameTarget: HTMLInputElement;
  private emailTarget: HTMLInputElement;
  private phoneTarget: HTMLInputElement;
  private passwordTarget: HTMLInputElement;
  private pwConfirmationTarget: HTMLInputElement;
  private submitTarget: HTMLInputElement;
  private methodTarget: HTMLElement;

  // TODO: add server side availability check, disable button if taken
  // need to combine with format validation nicely
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

  // TODO: re-enable submit button only when all condition are match
  // password valid && password === password confirmation
  // TODO: aslo add focus and keyup to password field
  onPasswordBlur() {
    const passwordValidator = new FormValidator(this.passwordTarget);
    passwordValidator.validateInputFieldFor(
      "password",
      () => (this.submitTarget.disabled = false),
      () => (this.submitTarget.disabled = true)
    );
  }

  onPwConfirmationKeyup() {
    let typingTimer: any;
    const typingInterval = 1200; // invoke setTimeout function after 1.2s

    clearTimeout(typingTimer);

    if (this.pwConfirmationTarget.value) {
      typingTimer = setTimeout(() => {
        this.validatePwconfirmation();
      }, typingInterval);
    }
  }

  onPwConfirmationFocus() {
    this.validatePwconfirmation();
  }

  onPwConfirmationBlur() {
    this.validatePwconfirmation();
  }

  private validatePwconfirmation() {
    const pwconfValidator = new FormValidator(this.pwConfirmationTarget);

    pwconfValidator.validatePwConfirmation(
      this.passwordTarget.value,
      this.pwConfirmationTarget.value,
      () => (this.submitTarget.disabled = false),
      () => (this.submitTarget.disabled = true)
    );
  }
}

export default RegistrationController;

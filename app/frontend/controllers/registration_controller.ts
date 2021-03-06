import { Controller } from "stimulus";
import FlashHelper from "../utils/flashHelper";
import InputValidator from "../utils/inputValidator";

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

  connect() {
    document.body.addEventListener("ajax:success", this.onXHRSuccess);
    document.body.addEventListener("ajax:error", this.onXHRError);
  }

  disconnect() {
    document.body.removeEventListener("ajax:success", this.onXHRSuccess);
    document.body.removeEventListener("ajax:error", this.onXHRError);
  }

  // TODO: add server side availability check, disable button if taken consider
  // using formValidator.validateEmailField(...) over explicit input validators
  step1Submit(e: Event) {
    e.preventDefault();

    const unameValidator = new InputValidator(this.step1usernameTarget);
    const emailValidator = new InputValidator(this.step1emailTarget);
    const phoneValidator = new InputValidator(this.step1phoneTarget);

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
        this.step1phoneTarget.value = "";
      });
    } else {
      phoneValidator.validateInputFieldFor("phone", () => {
        this.phoneTarget.value = this.step1phoneTarget.value;
        this.step1emailTarget.value = "";
      });
    }

    if (
      unameValidator.isValidate &&
      (emailValidator.isValidate || phoneValidator.isValidate)
    ) {
      setTimeout(this.toggleForms, 200);
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

  backToStep1() {
    this.toggleForms();
  }

  // TODO: re-enable submit button only when all condition are match
  // password valid && password === password confirmation
  // Sanario: 1, password valid -> 2, password confirmation invalid -> 3, focus back password
  // button should still be disabled, consider do this on submit button click
  onPasswordKeyup() {
    this.setKeyupIntervalFor(this.passwordTarget, 1200, () =>
      this.validatePassword()
    );
  }

  onPasswordBlur() {
    this.validatePassword();
  }

  onPasswordFocus() {
    if (this.passwordTarget.value || this.pwConfirmationTarget.value) {
      this.validatePassword();
    }
  }

  onPwConfirmationKeyup() {
    this.setKeyupIntervalFor(this.pwConfirmationTarget, 1200, () =>
      this.validatePwconfirmation()
    );
  }

  onPwConfirmationFocus() {
    this.validatePwconfirmation();
  }

  onPwConfirmationBlur() {
    this.validatePwconfirmation();
  }

  private toggleForms() {
    document
      .querySelector("#step1form")
      .parentElement.classList.toggle("is-hidden");

    document
      .querySelector("#signupform")
      .parentElement.classList.toggle("is-hidden");
  }

  private validatePassword() {
    const passwordValidator = new InputValidator(this.passwordTarget);

    passwordValidator.validateInputFieldFor(
      "password",
      () => (this.submitTarget.disabled = false),
      () => (this.submitTarget.disabled = true)
    );
  }

  private validatePwconfirmation() {
    const pwconfValidator = new InputValidator(this.pwConfirmationTarget);

    pwconfValidator.validatePwConfirmation(
      this.passwordTarget.value,
      this.pwConfirmationTarget.value,
      () => (this.submitTarget.disabled = false),
      () => (this.submitTarget.disabled = true)
    );
  }

  private setKeyupIntervalFor(
    target: HTMLInputElement,
    delay: number,
    callBack: any
  ) {
    let typingInterval: any;

    clearTimeout(typingInterval);
    if (target.value) {
      typingInterval = setTimeout(() => {
        callBack();
      }, delay); // invoke setTimeout function after 1.2s
    }
  }

  private onXHRSuccess = (event: CustomEvent) => {
    const res = event.detail[0];
    if (res.is_display_notification) {
      const flash = new FlashHelper(
        res.notification.content,
        res.notification.type
      );
      flash.display();
    }
  };

  private onXHRError = () => {
    const flash = new FlashHelper(
      "Something went wrong please try again",
      "danger"
    );
    flash.display();
  };
}

export default RegistrationController;

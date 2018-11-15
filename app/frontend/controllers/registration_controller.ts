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
    "method"
  ];

  private step1usernameTarget: HTMLInputElement;
  private step1emailTarget: HTMLInputElement;
  private step1phoneTarget: HTMLInputElement;
  private methodTarget: HTMLElement;

  private usernameTarget: HTMLInputElement;
  private emailTarget: HTMLInputElement;
  private phoneTarget: HTMLInputElement;
  private passwordTarget: HTMLInputElement;
  private hasPasswordTarget: boolean;
  private pwConfirmationTarget: HTMLInputElement;
  private hasPwConfirmationTarget: boolean;

  connect() {
    if (this.hasPasswordTarget) {
      this.passwordTarget.addEventListener("blur", this.onPasswordBlur);
    }

    if (this.hasPwConfirmationTarget) {
      this.pwConfirmationTarget.addEventListener(
        "blur",
        this.onPwConfirmationBlur
      );
    }
  }

  disconnect() {
    if (this.hasPasswordTarget) {
      this.passwordTarget.removeEventListener("blur", this.onPasswordBlur);
    }

    if (this.hasPwConfirmationTarget) {
      this.pwConfirmationTarget.removeEventListener(
        "blur",
        this.onPwConfirmationBlur
      );
    }
  }

  // TODO: validation check on blur after first submit, disable button on invalid
  // TODO: add server side availability check, disable button on taken
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

  private onPasswordBlur(e: Event) {
    const pwTarget = e.target as HTMLInputElement;
    const passwordValidator = new FormValidator(pwTarget);
    const commitBtn = document
      .querySelector("#signupform")
      .querySelector("#commit-btn") as HTMLInputElement;

    // TODO: re-enable submit button only when all condition are match
    // password valid && password === password confirmation
    passwordValidator.validateInputFieldFor(
      "password",
      () => (commitBtn.disabled = false),
      () => (commitBtn.disabled = true)
    );
  }

  // instead of blur, detect user stopped typing with keyup and setInterval
  private onPwConfirmationBlur(e: Event) {
    const pwTarget = document.querySelector(
      "#signupform-password"
    ) as HTMLInputElement;
    const pwconfTarget = e.target as HTMLInputElement;
    const passwordValidator = new FormValidator(pwconfTarget);

    passwordValidator.validatePwConfirmation(
      pwTarget.value,
      pwconfTarget.value
    );
  }
}

export default RegistrationController;

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

  // TODO: extract validation related functions out to a utility class
  private static unameRegexp = /^[a-zA-Z0-9-_]+$/;
  private static emailRegexp = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
  private static phoneRegexp = /^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$/im;

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

    this.validateInputField(this.step1usernameTarget, "username", () => {
      this.usernameTarget.value = this.step1usernameTarget.value;
    });

    if (
      document
        .querySelector("#step1form-phone-filed")
        .classList.contains("is-hidden")
    ) {
      this.validateInputField(this.step1emailTarget, "email", () => {
        this.emailTarget.value = this.step1emailTarget.value;
      });
      this.step1phoneTarget.value = "";
    } else {
      this.validateInputField(this.step1phoneTarget, "phone", () => {
        this.phoneTarget.value = this.step1phoneTarget.value;
      });
      this.step1emailTarget.value = "";
    }
  }

  // TODO: reset signupform fields on change
  switchSignupMethod(e: Event) {
    e.preventDefault();
    const currentText = this.methodTarget.textContent;
    document
      .querySelector("#step1form-email-filed")
      .classList.toggle("is-hidden");
    document
      .querySelector("#step1form-phone-filed")
      .classList.toggle("is-hidden");
    this.methodTarget.textContent =
      currentText === "Use email instead"
        ? "Use phone instead"
        : "Use email instead";
  }

  private validateInputField(
    target: HTMLInputElement,
    type?: string,
    callBack?: any
  ) {
    if (target.value === "") {
      this.displayValidationInfo(target, false, "Input cannot be empty.");
      return;
    }

    switch (type) {
      case "username":
        if (
          !this.validateFormat(target.value, RegistrationController.unameRegexp)
        ) {
          this.displayValidationInfo(target, false, "Invalid format.");
        } else {
          this.displayValidationInfo(target, true);
          if (callBack !== undefined) {
            callBack();
          }
        }
        break;
      case "email":
        if (
          !this.validateFormat(target.value, RegistrationController.emailRegexp)
        ) {
          this.displayValidationInfo(target, false, "Invalid format.");
        } else {
          this.displayValidationInfo(target, true);
          if (callBack !== undefined) {
            callBack();
          }
        }
        break;
      case "phone":
        if (
          !this.validateFormat(target.value, RegistrationController.phoneRegexp)
        ) {
          this.displayValidationInfo(target, false, "Invalid format.");
        } else {
          this.displayValidationInfo(target, true);
          if (callBack !== undefined) {
            callBack();
          }
        }
        break;
      case "password":
        if (
          !this.validateFormat(target.value, RegistrationController.phoneRegexp)
        ) {
          this.displayValidationInfo(target, false, "Invalid format.");
        } else {
          this.displayValidationInfo(target, true);
          if (callBack !== undefined) {
            callBack();
          }
        }
        break;
      default:
        break;
    }
  }

  private validateFormat(input: string, format: RegExp): boolean {
    return format.test(String(input).toLowerCase());
  }

  private displayValidationInfo(
    target: HTMLInputElement,
    isValid: boolean,
    validationMsg?: string
  ) {
    const validationIndicator: HTMLElement = target.parentElement.querySelector(
      ".validation-indicator"
    );
    const errorTextElement: HTMLElement = target.parentElement.querySelector(
      "p.is-danger"
    );

    if (isValid) {
      this.setValidationInfo(
        target,
        "is-success",
        validationIndicator,
        "has-text-success",
        '<i class="fas fa-check"></i>'
      );

      this.unsetValidationInfo(
        target,
        "is-danger",
        validationIndicator,
        "has-text-danger",
        errorTextElement
      );
    } else {
      this.setValidationInfo(
        target,
        "is-danger",
        validationIndicator,
        "has-text-danger",
        '<i class="fas fa-exclamation-circle"></i>',
        errorTextElement,
        validationMsg
      );

      this.unsetValidationInfo(
        target,
        "is-success",
        validationIndicator,
        "has-text-success"
      );
    }
  }

  private setValidationInfo(
    target: HTMLInputElement,
    targetClass: string,
    indicator: HTMLElement,
    indicatorClass: string,
    indicatorIcon: string,
    textElement?: HTMLElement,
    textContent: string = ""
  ) {
    target.classList.add(targetClass);
    indicator.classList.add(indicatorClass);
    indicator.innerHTML = indicatorIcon;
    if (textElement !== undefined) {
      textElement.innerHTML = textContent;
    }
  }

  private unsetValidationInfo(
    target: HTMLInputElement,
    targetClass: string,
    indicator: HTMLElement,
    indicatorClass: string,
    textElement?: HTMLElement
  ) {
    target.classList.remove(targetClass);
    indicator.classList.remove(indicatorClass);
    // indicator.innerHTML = indicatorIcon;
    if (textElement !== undefined) {
      textElement.innerHTML = "";
    }
  }
}

export default RegistrationController;

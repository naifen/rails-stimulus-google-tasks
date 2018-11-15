// TODO: consider initialize with Form object or remove all explicit target parm

class FormValidator {
  private static unameRegexp: RegExp = /^[a-zA-Z0-9-_]+$/;
  private static emailRegexp: RegExp = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
  private static phoneRegexp: RegExp = /^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$/im;
  // password RegEx minimum 8 characters, at least 1 lowercase, 1 uppercase, 1 num, 1 special character from !@#$%^&*
  private static paswdRegexp: RegExp = /^(?=.*[\d])(?=.*[A-Z])(?=.*[a-z])(?=.*[!@#$%^&*])[\w!@#$%^&*]{8,}$/;
  private static inValidFormatMsg: string = "Invalid format.";

  private target: HTMLInputElement;

  constructor(target: HTMLInputElement) {
    this.target = target;
  }

  validateInputFieldFor(type: string, callBack?: any) {
    if (this.target.value === "") {
      this.displayValidationInfo(this.target, false, "Input cannot be empty.");
      return;
    }

    switch (type) {
      case "username":
        this.handleValidationFor(
          this.target,
          FormValidator.unameRegexp,
          FormValidator.inValidFormatMsg,
          callBack
        );
        break;
      case "email":
        this.handleValidationFor(
          this.target,
          FormValidator.emailRegexp,
          FormValidator.inValidFormatMsg,
          callBack
        );
        break;
      case "phone":
        this.handleValidationFor(
          this.target,
          FormValidator.phoneRegexp,
          FormValidator.inValidFormatMsg,
          callBack
        );
        break;
      case "password":
        this.handleValidationFor(
          this.target,
          FormValidator.paswdRegexp,
          FormValidator.inValidFormatMsg,
          callBack
        );
        break;
      default:
        break;
    }
  }

  private handleValidationFor(
    target: HTMLInputElement,
    regexp: RegExp,
    errorMsg: string,
    callBack: any
  ) {
    if (!this.validateFormat(target.value, regexp)) {
      this.displayValidationInfo(target, false, errorMsg);
    } else {
      this.displayValidationInfo(target, true);
      if (callBack !== undefined) {
        callBack();
      }
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
    if (textElement !== undefined) {
      textElement.innerHTML = "";
    }
  }
}

export default FormValidator;

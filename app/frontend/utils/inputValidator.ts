class InputValidator {
  private static unameRegexp: RegExp = /^[a-zA-Z0-9-_]+$/;
  private static emailRegexp: RegExp = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
  private static phoneRegexp: RegExp = /^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$/im;
  // password RegEx minimum 8 characters, at least 1 lowercase, 1 uppercase, 1 num, 1 special character from !@#$%^&*
  private static paswdRegexp: RegExp = /^(?=.*[\d])(?=.*[A-Z])(?=.*[a-z])(?=.*[!@#$%^&*])[\w!@#$%^&*]{8,}$/;
  private static inValidFormatMsg: string = "Invalid format.";

  isValidate: boolean = false;
  private target: HTMLInputElement;

  constructor(target: HTMLInputElement) {
    this.target = target;
  }

  validateInputFieldFor(
    type: string,
    validCallBack?: any,
    invalidCallback?: any
  ) {
    if (this.target.value === "") {
      this.displayValidationInfo(this.target, false, "Input cannot be empty.");
      return;
    }

    switch (type) {
      case "username":
        this.handleValidationFor(
          this.target,
          InputValidator.unameRegexp,
          InputValidator.inValidFormatMsg,
          validCallBack,
          invalidCallback
        );
        break;
      case "email":
        this.handleValidationFor(
          this.target,
          InputValidator.emailRegexp,
          InputValidator.inValidFormatMsg,
          validCallBack,
          invalidCallback
        );
        break;
      case "phone":
        this.handleValidationFor(
          this.target,
          InputValidator.phoneRegexp,
          InputValidator.inValidFormatMsg,
          validCallBack,
          invalidCallback
        );
        break;
      case "password":
        this.handleValidationFor(
          this.target,
          InputValidator.paswdRegexp,
          `${
            InputValidator.inValidFormatMsg
          }, minimum 8 characters, must contain at least 1 uppercase, 1 lowercase and 1 special character from !@#$%^&*`,
          validCallBack,
          invalidCallback
        );
        break;
      default:
        break;
    }
  }

  validatePwConfirmation(
    password: string,
    pwConfirmation: string,
    validCallBack?: any,
    invalidCallback?: any
  ) {
    if (
      this.validateFormat(password, InputValidator.paswdRegexp) &&
      password === pwConfirmation
    ) {
      this.displayValidationInfo(this.target, true);
      if (validCallBack !== undefined) {
        validCallBack();
      }
    } else {
      this.displayValidationInfo(
        this.target,
        false,
        "invalid password format or does NOT match"
      );
      if (invalidCallback !== undefined) {
        invalidCallback();
      }
    }
  }

  private handleValidationFor(
    target: HTMLInputElement,
    regexp: RegExp,
    errorMsg: string,
    validCallBack?: any,
    invalidCallback?: any
  ): boolean {
    if (!this.validateFormat(target.value, regexp)) {
      this.displayValidationInfo(target, false, errorMsg);
      if (invalidCallback !== undefined) {
        invalidCallback();
      }
    } else {
      this.displayValidationInfo(target, true);
      this.isValidate = true;
      if (validCallBack !== undefined) {
        validCallBack();
      }
    }
    return this.isValidate;
  }

  private validateFormat(input: string, format: RegExp): boolean {
    return format.test(String(input));
  }

  private displayValidationInfo(
    target: HTMLInputElement,
    isValid: boolean,
    validationMsg?: string
  ) {
    const validationIndicator: HTMLElement = target.parentElement.querySelector(
      "span.validation-indicator"
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
    textContent?: string
  ) {
    target.classList.add(targetClass);
    indicator.classList.add(indicatorClass);
    indicator.innerHTML = indicatorIcon;
    if (textElement !== undefined) {
      textElement.innerHTML = textContent || InputValidator.inValidFormatMsg;
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

export default InputValidator;

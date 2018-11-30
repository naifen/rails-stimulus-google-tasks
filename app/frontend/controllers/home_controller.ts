import { Controller } from "stimulus";

class HomeController extends Controller {
  static targets = ["credentials", "hiddenCredentials", "code"];

  private credentialsTarget: HTMLInputElement;
  private hiddenCredentialsTarget: HTMLInputElement;
  // private codeTarget: HTMLInputElement;

  getUrlFormSubmit(e: Event) {
    // e.preventDefault();
    console.log(e);
    this.hiddenCredentialsTarget.value = this.credentialsTarget.value;
  }

  authFormSubmit() {
    console.log("auth form submitted");
  }
}

export default HomeController;

// {"installed":{"client_id":"261190097740-lfubr8bkjrt5gq71skrp5hfnn4jj4oup.apps.googleusercontent.com","project_id":"gtasksapi-1543051727761","auth_uri":"https://accounts.google.com/o/oauth2/auth","token_uri":"https://www.googleapis.com/oauth2/v3/token","auth_provider_x509_cert_url":"https://www.googleapis.com/oauth2/v1/certs","client_secret":"P6djdtbn0pH-I_utEVo7a1dJ","redirect_uris":["urn:ietf:wg:oauth:2.0:oob","http://localhost"]}}

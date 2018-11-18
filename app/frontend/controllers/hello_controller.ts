// Visit The Stimulus Handbook for more details
// https://stimulusjs.org/handbook/introduction
//
// This example controller works with specially annotated HTML like:
//
// <div data-controller="hello">
//   <h1 data-target="hello.output"></h1>
// </div>

import { Controller } from "stimulus";

class HelloController extends Controller {
  static targets = ["output"];

  private outputTarget: Element;
  private hasOutputTarget: boolean;
  private framework: string = "Stimulus";

  connect() {
    if (this.hasOutputTarget) {
      this.outputTarget.textContent = `Hello, ${
        this.framework
      }! From TypeScript`;
    }

    window.addEventListener("keydown", this.keyDownListener);
  }

  disconnect() {
    window.removeEventListener("keydown", this.keyDownListener);
  }

  private keyDownListener(e: KeyboardEvent): any {
    if (e.keyCode === 80 && e.metaKey && e.shiftKey) {
      alert("Omni Command cmd + shift + P");
    }
  }
}

export default HelloController;

// register a eventHandler for rails ujs (e,g, form_with ajax form submission)
// document.addEventListener('ajax:success', function(event) {
//  var detail = event.detail;
//  var data = detail[0], status = detail[1], xhr = detail[2];
// })
// https://guides.rubyonrails.org/working_with_javascript_in_rails.html#rails-ujs-event-handlers

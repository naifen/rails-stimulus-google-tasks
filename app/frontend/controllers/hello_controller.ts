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
  }
}

export default HelloController;

// Visit The Stimulus Handbook for more details
// https://stimulusjs.org/handbook/introduction
//
// This example controller works with specially annotated HTML like:
//
// <div data-controller="hello">
//   <h1 data-target="hello.output"></h1>
// </div>

import { Controller } from "stimulus"

class HelloController extends Controller {
  private outputTarget: Element;
  private hasOutputTarget: boolean;

  static targets = [ "output" ]
  static framework: string = "Stimulus";

  connect(): void {
    this.outputTarget.textContent = `Hello, ${HelloController.framework}! From TypeScript`
  }
}

export default HelloController;

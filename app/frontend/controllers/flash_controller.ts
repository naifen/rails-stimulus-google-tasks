import { Controller } from "stimulus";

class FlashController extends Controller {
  private closeTimer: number;

  connect() {
    this.closeTimer = setTimeout(this.close, 6000);
  }

  disconnect() {
    clearTimeout(this.closeTimer);
  }

  close = () => {
    this.element.remove();
  };
}

export default FlashController;

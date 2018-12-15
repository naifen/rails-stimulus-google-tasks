class FlashHelper {
  private content: string;
  private type: string;

  constructor(content: string, type: string) {
    this.content = content;
    this.type = type;
  }

  display(): void {
    document
      .querySelector("#notification-box")
      .append(this.buildNotification());
  }

  private buildNotification(): HTMLElement {
    const notification = document.createElement("div");
    notification.className = `notification-top-right notification is-${
      this.type
    }`;
    notification.dataset.controller = "flash";
    notification.innerHTML = `<button data-action="flash#close" class="delete"></button>${
      this.content
    }`;

    return notification;
  }
}

export default FlashHelper;

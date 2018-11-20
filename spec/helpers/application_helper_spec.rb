require "rails_helper"

RSpec.describe ApplicationHelper do
  describe "#image_link_to" do
    it "returns basic markup without arguments passed in" do
      expect(helper.image_link_to).to eq "<a href=\"\"><img src=\"\" /></a>"
    end

    it "returns basic markup without arguments passed in" do
      expect(helper.image_link_to(
        url: "/foo",
        link_options: { class: "bar" },
        image_src: "https://hello.world.image.png",
        image_options: { width: 112, height: 28 }
      )).to eq "<a class=\"bar\" href=\"/foo\"><img width=\"112\" height=\"28\" src=\"https://hello.world.image.png\" /></a>"
    end
  end

  describe "#notification_color" do
    it "returns is-success when given success" do
      expect(helper.notification_color("success")).to eq "is-success"
    end

    it "returns is-danger when given error" do
      expect(helper.notification_color("error")).to eq "is-danger"
    end

    it "returns is-warning when given alert" do
      expect(helper.notification_color("alert")).to eq "is-warning"
    end

    it "returns is-info when given notice" do
      expect(helper.notification_color("notice")).to eq "is-info"
    end

    it "returns is-type when given type by default" do
      expect(helper.notification_color("foo")).to eq "is-foo"
    end
  end
end

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

  describe "#text_field_div_for" do
    it "returns basic markup without arguments passed in" do
      expect(helper.text_field_content_for {}).to eq(
        "<div class=\"control has-icons-left has-icons-right\">"\
        "<span class=\"icon is-small is-left\"><i class=\"fab fa-apple\"></i></span>"\
        "<span class=\"validation-indicator icon is-small is-right\"></span>"\
        "<p class=\"help is-success\"></p><p class=\"help is-danger\"></p></div>")
    end

    it "inject input field in html markup with block and yield" do
      helper.form_for :user, url: "/users" do |f|
        expect(helper.text_field_content_for(form_object: f) { |form| form.text_field :email }).to eq(
          "<div class=\"control has-icons-left has-icons-right\">"\
          "<input type=\"text\" name=\"user[email]\" id=\"user_email\" />"\
          "<span class=\"icon is-small is-left\"><i class=\"fab fa-apple\"></i></span>"\
          "<span class=\"validation-indicator icon is-small is-right\"></span>"\
          "<p class=\"help is-success\"></p><p class=\"help is-danger\"></p></div>")
      end
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

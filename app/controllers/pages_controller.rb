# frozen_string_literal: true

class PagesController < ApplicationController
  def home
    @images = [
      { alt: "gtasks",
        url: "https://lh3.googleusercontent.com/62OzNxLonba70XxMFP3X3dsdNS9lvG2xf5TqfhYDaw9iFn5as9gVSU23ExfCLoZXkMWA=s180" },
      { alt: "gmail",
        url: "https://www.gstatic.com/images/icons/material/product/1x/gmail_64dp.png" },
      { alt: "gcalendar",
        url: "https://www.gstatic.com/images/branding/product/1x/calendar_64dp.png" },
      { alt: "gdrive",
        url: "https://www.gstatic.com/images/icons/material/product/2x/drive_32dp.png" },
      { alt: "gsheet",
        url: "https://www.gstatic.com/images/icons/material/product/1x/sheets_64dp.png" },
      { alt: "gslide",
        url: "https://www.gstatic.com/images/branding/product/1x/slides_64dp.png" }
    ]
  end

  def about
  end
end

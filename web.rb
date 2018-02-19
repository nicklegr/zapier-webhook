# coding: utf-8

require "bundler"
Bundler.require

require "json"
require_relative "services"

post "/images_from_card" do
  json = JSON.parse(request.body.read)

  name = json["card_name"]
  desc = json["card_desc"]

  status_url_regexp = %r|https?://twitter.com/\w+/status(?:es)?/\d+|

  status_urls = name.scan(status_url_regexp) + desc.scan(status_url_regexp)
  status_urls.compact!
  status_urls.uniq!

  # どのTwitterクライアントでシェアしても、一番最後にそのツイートのURLが入る
  # ツイート本文に別のツイートのURLがあっても無視する
  status_url = status_urls.last

  result =
    if PicTwitter.support?(status_url)
      imgs = PicTwitter.image_urls(status_url)
      {
        "url_0" => imgs[0],
        "url_1" => imgs[1],
        "url_2" => imgs[2],
        "url_3" => imgs[3],
      }
    else
      ""
    end

  result.to_json
end

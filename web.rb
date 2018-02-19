# coding: utf-8

require "bundler"
Bundler.require

require "json"

post "/images_from_card" do
  json = JSON.parse(request.body.read)
  json.to_json
end

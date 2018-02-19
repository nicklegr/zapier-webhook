# coding: utf-8

require 'open-uri'
require 'bundler/setup'
Bundler.require

module PicTwitter
  def self.support?(url)
    url.match(%r|^https?://twitter.com/\w+/status(es)?/\d+|)
  end

  def self.image_urls(url)
    doc = Nokogiri::HTML(open(url, allow_redirections: :safe))

    img_urls = []

    doc.css('div.js-adaptive-photo').each do |div|
      img_urls << div['data-image-url']
    end

    img_urls.uniq!

    img_urls.map! do |e|
      e.sub(%r/:\w+$/, '') + ":orig"
    end

    img_urls
  end
end

module Instagram
  def self.support?(url)
    url.match(%r|^https?://instagram.com/p/\w+|)
  end

  def self.image_urls(url)
    request_url = url.dup
    request_url.sub!(%r|[/#]$|, '')

    doc = Nokogiri::HTML(open(request_url, allow_redirections: :safe))
    meta = doc.css('meta[property="og:image"]').first

    return [] unless meta && meta['content']
    [ meta['content'] ]
  end
end

module Twitpic
  def self.support?(url)
    url.match(%r|^https?://twitpic.com/\w+|)
  end

  def self.image_urls(url)
    request_url = url.dup
    request_url.sub!(%r|/$|, '')
    request_url.sub!(%r|/full/?$|, '')

    doc = Nokogiri::HTML(open(request_url, allow_redirections: :safe))
    img = doc.css('div#media > img').first

    return [] unless img && img['src']
    [ img['src'] ]
  end
end

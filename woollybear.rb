require 'rubygems'
require 'mechanize'
require './lib/woollybear/config'
require './lib/woollybear/spider'

def WoollyBear.fuzz(url, &block)
  WoollyBear::Configuration.set(&block) if block_given?

  spider = WoollyBear::Spider.new(url)
  spider.crawl
  spider.guess

  # spider.anchors.each { |l| puts l.to_s }
  # spider.cookies.each { |n, v| puts "#{n}: #{v}" }
  # spider.forms.each { |f| puts f.inspect }
  # spider.sensitive_data.each { |word, uri| puts "#{word} on #{uri}" }
end

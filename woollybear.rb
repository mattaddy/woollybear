require 'rubygems'
require 'mechanize'
require './lib/woollybear/config'
require './lib/woollybear/spider'
require './lib/woollybear/fuzzer'

def WoollyBear.fuzz(url, &block)
  WoollyBear::Configuration.set(&block) if block_given?

  spider = WoollyBear::Spider.new(url)
  
  spider.crawl
  spider.guess

  puts "Links: found #{spider.anchors.size} links.."
  puts "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
  spider.anchors.each { |a| puts a.to_s }

  puts "\nForms: found #{spider.forms.size} forms containing #{spider.form_fields.size} total fields.."
  puts "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"

  puts "\nCookies: #{spider.cookies.size} cookies set.."
  puts "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
  spider.cookies.each { |n, v| puts "#{n}: #{v}" }

  puts "\nPage guesses: found #{spider.hidden_pages.size} unlinked pages.."
  puts "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
  spider.hidden_pages.each { |p| puts p.uri }

  if WoollyBear::Configuration.get(:sensitive_data)
    puts "\nSensitive data: found #{spider.sensitive_data.size} occurrences of the supplied sensitive data list.."
    puts "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
    spider.sensitive_data.each { |w, p| puts "#{w} on #{p}" }
  end

  puts "\nSubmitting forms and testing links.."
  puts "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"

  fuzzer = WoollyBear::Fuzzer.new(spider)
  fuzzer.fuzz()

  # spider.anchors.each { |l| puts l.to_s }
  # spider.cookies.each { |n, v| puts "#{n}: #{v}" }
  # spider.forms.each { |f| puts f.inspect }
  # spider.sensitive_data.each { |word, uri| puts "#{word} on #{uri}" }
end

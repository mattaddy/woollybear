require './lib/woollybear/vectors'

module WoollyBear
  class Fuzzer
    attr_accessor :spider

    def initialize(spider)
      self.spider = spider
    end

    def fuzz
      WoollyBear::VECTORS.each do |vector, value|
        puts "Testing #{vector.to_s.capitalize.tr('_', ' ')}"
        self.spider.forms.each do |form|
          begin
            form.fields.each do |field|
              field.value = value
            end
            page = form.submit
            if page.body.include?('<script>alert("XSS")</script>')
              puts "Possible XSS vulnerability found on form action #{form.action}!"
            end
          rescue Mechanize::ResponseCodeError => e
            if e.response_code == '403' or e.response_code == '500'
              puts "Possible vulnerability found due to a 403 or 500 error!"
            end
          end
        end
      end
    end
  end
end

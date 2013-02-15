module WoollyBear
  require 'uri'
  require 'mechanize'
  require './lib/woollybear/config'

  class Spider
    attr_accessor :start_url, :base_url, :current_page, :agent, :config,
                  :anchors, :forms, :cookies, :sensitive_data, :hidden_pages

    DATA_FOLDER = "./data"

    def initialize(url)
      @agent = Mechanize.new
      @config = WoollyBear::Configuration
      @base_url = URI.parse(url).host
      @start_url = url
    end

    def get(url)
      return nil unless follow_url?(url)
      @current_page = agent.get(url)
      authenticate unless @current_page.uri == URI.parse(url)
    end

    def click(link)
      if follow_url?(link.href)
        @current_page = agent.click(link)
        authenticate unless followed_url_successfully?(link)
      end
      @current_page
    end

    def links
      @current_page.links
    end

    def visited?(url)
      @agent.visited?(url)
    end

    def crawl
      @anchors, @forms, @cookies, @sensitive_data = [], [], {}, {}
      self.get(@start_url)

      stack = self.links
      clicked_links = []

      while l = stack.pop
        unless clicked_links.include?(l.href)
          sleep(@config.get(:wait)) unless @config.get(:wait).zero?
          page = self.click(l)
          if gather_sensitive_data?
            sensitive_data_array.each { |d| self.sensitive_data[d] = page.uri if page.content.include?(d) }
          end
          @anchors.push(page.uri) unless @anchors.include?(page.uri)
          page.forms.each { |f| @forms.push(f) unless @forms.include?(f) }
          @agent.cookies.each { |c| @cookies[c.name] = c.value unless @cookies.key(c.name) == c.value }
          clicked_links.push(l.href)
          stack.push(*(self.links))
        end
      end
    end

    def guess
      @hidden_pages = []
      ['login.php', 'help.html'].each do |page|
        begin
          page = @agent.get(page)
          @hidden_pages.push(page)
        rescue
        end
      end
    end

  private

    def authenticate
      f = @current_page.form_with(:action => @config.get(:login_action))
      return false if f.nil?

      f.field_with(:name => @config.get(:username_field)).value = @config.get(:username)
      f.field_with(:name => @config.get(:password_field)).value = @config.get(:password)
      @current_page = f.submit(f.buttons.first)
    end

    def follow_url?(url)
      host = URI.parse(url.to_s).host rescue true
      host.nil? or host == @base_url
    end

    def followed_url_successfully?(link)
      link_last_part = link.href.to_s.split('/').last
      current_page_last_part = @current_page.uri.to_s.split('/').last
      link_last_part = link.href.to_s.split('/')[-2] if link_last_part == '.'

      link_last_part == current_page_last_part
    end

    def gather_sensitive_data?
      not @config.get(:sensitive_data).nil?
    end

    def sensitive_data_array
      return nil unless gather_sensitive_data?
      line_array = []
      File.open("#{DATA_FOLDER}/#{@config.get(:sensitive_data)}").each_line { |line| line_array.push(line.chomp) }
      line_array
    end
  end
end

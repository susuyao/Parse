require 'mechanize'
require 'nokogiri'

class Parse

  def initialize
    @agent=Mechanize.new { |a| a.ssl_version, a.verify_mode = 'TLSv1', OpenSSL::SSL::VERIFY_NONE }
    # @agent.set_proxy('127.0.0.1', 8888)

  end

  def login

    @agent.get('https://www.douban.com/accounts/login') do |page|

      form = page.form_with(:name => 'lzform')

      form.field_with(:name => 'source').value = 'index_nav'
      form.field_with(:name => 'form_email').value = ''
      form.field_with(:name => 'form_password').value = ''

      #判断是否需要输入验证码
      captchaTokenInput = form.field_with(:name => 'captcha-id')

      unless captchaTokenInput.nil?
        verify_url = "https://www.douban.com/misc/captcha?id=#{captchaTokenInput.value}&size=s"
        @agent.get(verify_url).save! 'captcha.png'

        # read from console input
        puts 'enter verify code'
        a = gets.chomp
        form['captcha-solution'] = a
      end


      @agent.submit form

      File.open('result.txt', 'w') do |file|

        #判断当前页面的页码
        tempEnd = 0
        tempTotal = 1
        while tempEnd < tempTotal do

          @agent.get("https://movie.douban.com/people/aiziyuer/collect?start=#{tempEnd+1}&sort=time&rating=all&filter=all&mode=grid") do |movie|
            File.open('movie.html', 'w').puts movie.body
            # Fetch and parse HTML document
            doc = Nokogiri::HTML(movie.body)
            puts "### Search for nodes by css"


            tempMatchers = doc.css('.subject-num').text.scan /\d+-(\d+)[^\/\d]*\/[^\d]*(\d+)/m
            tmpEnd, tmpTotal = tempMatchers[0] unless tempMatchers.nil? || tempMatchers.empty?

            tempEnd = tmpEnd.to_i
            tempTotal = tmpTotal.to_i

            array=[]
            doc.css('#wrapper .article .grid-view .item').each do |item|

              m = Movie.new
              array << m
              m.url = item.css('.pic a').first['href']
              m.name = item.css('.info .title a em').text
              m.info = item.css('.info .intro').text
              m.comment = item.css('.info .comment').text


              # p item.content
            end


            array.each do |tmp|
              file.puts tmp.url
              file.puts tmp.name
              file.puts tmp.info
              file.puts tmp.comment
            end

          end
        end

      end


    end
  end

end

class Movie

  attr_accessor :url, :name, :info, :comment


end

b=Parse.new
b.login

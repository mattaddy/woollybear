# woollybear
A first stab at a fuzzer.

## Installation
Use bundler to install the dependencies

    bundle install

## Usage
To use woollybear on any given web application, create a script in the `bin` directory. `require` the woollybear application and call the fuzz method on it.

    require './woollybear'

    WoollyBear.fuzz('http://localhost/dvwa')

Optionally, you can pass a configuration block to the fuzz method.

    require './woollybear'

    WoollyBear.fuzz('http://localhost/dvwa') do |config|
      config.wait = 5
    end

Possible configuration options are

- **authenticate**=*true/false* Supplied URL requires authentication. If authenticate is set to true, woollybear expects you to supply login_action, username_field, password_field, username, and password configuration options.
- **sensitive_data**=*filename* Specify a filename (located in the data folder) of sensitive words/phrases you want to test the output of the application for, separated by newlines.
- **wait**=*integer* Wait the specified number of seconds between requests. Default is 0.
- **login_action**=*page* Where the login form submits to. Required when specifying authenticate = true.
- **username_field**=*value* The username field name (name="value") on the login form. Required when specifying authenticate = true.
- **password_field**=*value* The password field name (name="value") on the login form. Required when specifying authenticate = true.
- **username**=*username* Specify the username to login to the application with. Required when specifying authenticate = true.
- **password**=*password* Specify the password to login to the application with. Required when specifying authenticate = true.

## Credits
The mechanize gem was used extensively for crawling web applications and submitting forms within the application. Mechanize can be found [here](http://mechanize.rubyforge.org/).

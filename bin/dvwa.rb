require './woollybear'

WoollyBear.fuzz('http://localhost/dvwa') do |config|
  config.wait = 0
  config.sensitive_data = 'dvwa_sensitive_data.txt'
  config.authenticate = true
  config.login_action = 'login.php'
  config.username_field = 'username'
  config.password_field = 'password'
  config.username = 'admin'
  config.password = 'password'
end

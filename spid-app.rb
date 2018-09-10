require 'rubygems'
require 'bundler'
Bundler.require

Spid.configure do |config|
  config.hostname = "http://spid-sinatra.lvh.me:4567"
  config.private_key_pem = File.read File.expand_path("./sp.key")
  config.certificate_pem = File.read File.expand_path("./sp.crt")
  config.attribute_services = [
    {
      name: "Service 1",
      fields: [
        :spid_code,
        :name,
        :family_name,
        :date_of_birth,
        :gender,
        :company_name,
        :registered_office,
        :email
      ]
    }
  ]
end

use Rack::Session::Cookie

use Spid::Rack

get "/" do
  <<-EOT
  <a href=#{spid_login_path(idp_name: "http://idp.lvh.me:8088")}>Accedi con SPID</a>
  <a href=#{spid_logout_path(idp_name: "http://idp.lvh.me:8088")}>Accedi con SPID</a>
  <h1>Spid Session</h1>
  <pre>#{session["spid"].to_yaml}</pre>
EOT
end

require 'rubygems'
require 'bundler'
Bundler.require

Spid.configure do |config|
  config.hostname = "http://spid-sinatra.lvh.me:4567"
  config.private_key = File.read("./sp.key")
  config.certificate = File.read("./sp.crt")
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

enable :sessions

use Spid::Rack

get "/" do
  <<-EOT
    <a href='/spid/login?idp_name=idp'>Accedi con SPID</a>
    <a href='/spid/logout?idp_name=idp'>Esci da SPID</a>
    <pre>
      #{session["spid"].to_yaml}
    </pre>
  EOT
end

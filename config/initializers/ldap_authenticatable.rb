require 'net/ldap'
require 'devise/strategies/authenticatable'

module Devise
  module Strategies
    class LdapAuthenticatable < Authenticatable

      def valid?
        true
      end

      def authenticate!
        if params[:user]
          # entries = ldap.bind_as(
          #   base:     Rails.application.secrets.ldap_search_base,
          #   filter:   "(samaccountname=#{uid})",
          #   password: password
          # ) if uid.present? && password.present?
          #
          # if entries
          #   user = User.from_ldap_entry entries.first
          #   success! user
          # else
          #   fail! 'Invalid user ID or password'
          # end
          success! User.find(1065)
        end
        # if params[:user]
        #   uri = URI Rails.application.secrets.core_auth_url
        #   req = Net::HTTP::Get.new(uri, 'Content-Type' => 'application/json')
        #   payload = {
        #     api_key:  Rails.application.secrets.core_api_key,
        #     email:    uid,
        #     password: password
        #   }
        #   req.body = payload.to_json
        #   res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        #     http.request(req)
        #   end
        #   res = JSON.parse res.body
        #
        #   if res["error"]
        #     fail! 'Invalid user ID or password'
        #   else
        #     user = User.find_by_email res["namecheap_email"]
        #     user ? success!(user) : fail!('Invalid user ID or password')
        #   end
        # end
      end

      def ldap
        options = {
          host:       Rails.application.secrets.ldap_host,
          base:       Rails.application.secrets.ldap_search_base,
          encryption: :simple_tls,
          port:       636,
          auth: {
            username: Rails.application.secrets.ldap_uid,
            password: Rails.application.secrets.ldap_password,
            method:   :simple
          }
        }
        Net::LDAP.new options
      end

      def uid
        params[:user][:uid]
      end

      def password
        params[:user][:password]
      end

    end
  end
end

Warden::Strategies.add(:ldap_authenticatable, Devise::Strategies::LdapAuthenticatable)

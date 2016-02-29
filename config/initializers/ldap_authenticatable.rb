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
          entries = ldap.bind_as(
            base:     Rails.application.secrets.ldap_search_base,
            filter:   "(uid=#{uid})",
            password: password
          )
          
          if entries
            user = User.from_ldap_entry entries.first
            success! user
          else
            fail! 'Invalid user ID or password'
          end
        end
      end
      
      def ldap
        options = {
          host:       Rails.application.secrets.ldap_host,
          base:       Rails.application.secrets.search_base,
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
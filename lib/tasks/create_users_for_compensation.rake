require 'roo'

namespace :compensation do
  desc "Create users"
  task create_users: :environment do
#Create old user
    User.find_or_create_by(email: 'alexandra.k@namecheap.com') do |user|
      user.name      = 'Alexandra Kramarenko'
      user.email     = 'alexandra.k@namecheap.com'
      user.password  = 'oldusersavepassword'
      user.uid       = 'alex_kram'
      user.role_id   = Role.find_by_name('Billing CS').id
      user.auto_role = true
    end
#Find or create users by AD
    create_user_ldap(%w(daria.kolonuto@namecheap.com olga.se@namecheap.com anton.l@namecheap.com
                        vlad.smal@namecheap.com margarita.mikhalchuk@namecheap.com alex.ostankov@namecheap.com
                        eugene.zaryanov@namecheap.com lolita.das@namecheap.com stas.sotnikov@namecheap.com
                        irina.popova@namecheap.com julia.chernyshenko@namecheap.com zoryana.zozulya@namecheap.com
                        andrey.zhuga@namecheap.com stacey.sh@namecheap.com alina.skripka@namecheap.com
                        dmitriy.kovtun@namecheap.com victoria.burma@namecheap.com alexander.a@namecheap.com
                        maria.kregel@namecheap.com anastasia.volga@namecheap.com roman.dzyubak@namecheap.com
                        ivanna.dushil@namecheap.com eugene.orda@namecheap.com andrey.tserkovny@namecheap.com
                        valeria.lukyanova@namecheap.com julia.serdechnaya@namecheap.com christina.oliynik@namecheap.com
                        vadim.kovshar@namecheap.com dmitriy.polyarush@namecheap.com anastasia.alexandrov@namecheap.com
                        alexander.chernokun@namecheap.com olesya.nikolaeva@namecheap.com
                        andrey.pleshka@namecheap.com olga.bavykina@namecheap.com marina.n@namecheap.com
                        victoria.kopylova@namecheap.com julia.zemetskaya@namecheap.com lena.p@namecheap.com
                        artem.bigdan@namecheap.com))

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

  def create_user_ldap(emails)
    emails.each do |email|
      entry = ldap.search filter: "mail=#{email}", return: true
      User.from_ldap_entry entry.first
    end
  end

end
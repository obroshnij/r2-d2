module DNS
  class DBL < SpamBase

    def self.positive_test_host
      "dbltest.com"
    end

    def self.base_host
      "dbl.spamhaus.org"
    end

    def self.backup_nameservers
      [
        "c.ns.spamhaus.org",
        "i.ns.spamhaus.org",
        "t.ns.spamhaus.org",
        "g.ns.spamhaus.org",
        "f.ns.spamhaus.org",
        "k.ns.spamhaus.org",
        "o.ns.spamhaus.org",
        "b.ns.spamhaus.org",
        "4.ns.spamhaus.org",
        "8.ns.spamhaus.org",
        "x.ns.spamhaus.org",
        "7.ns.spamhaus.org",
        "d.ns.spamhaus.org",
        "h.ns.spamhaus.org",
        "0.ns.spamhaus.org",
        "5.ns.spamhaus.org",
        "3.ns.spamhaus.org",
        "q.ns.spamhaus.org"
      ]
    end

    def type
      :dbl
    end

    def self.type
      :dbl
    end

  end
end

module DNS
  class SURBL < SpamBase

    def self.backup_nameservers
      [
        "a.surbl.org",
        "b.surbl.org",
        "c.surbl.org",
        "d.surbl.org",
        "e.surbl.org",
        "f.surbl.org",
        "g.surbl.org",
        "h.surbl.org",
        "i.surbl.org",
        "j.surbl.org",
        "k.surbl.org",
        "l.surbl.org",
        "m.surbl.org",
        "n.surbl.org"
      ]
    end

    def self.positive_test_host
      "test.surbl.org"
    end

    def self.base_host
      "multi.surbl.org"
    end

    def type
      :surbl
    end

  end
end

class Legal::Pdf::WhoisInfo < Legal::Pdf::Admin

  private

  def render!
    @data.each do |whois|
      page_break!
      add_page_title "Whois details for #{whois['Domain Name']}"
      render_whois whois
    end
  end

  def render_whois whois
  end

end

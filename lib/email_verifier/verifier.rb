module EmailVerifier
  
  class Verifier
    
    attr_reader :session, :mailbox, :host
    
    def initialize email
      @email          = email
      @mailbox, @host = email.split('@')
      @session        = {}
    end
    
    def verify
      get_mx
      init_socket          if @mx.present?
      perform_verification if @socket && @socket.connected?
      @session
    end
    
    def host_error
      return "No MX records found for #{@host}"        unless @socket
      return "Unable to reach any of the mail servers" if @socket && !@socket.connected?
      return 'Uncommon error, see session logs' if rcpt_to_line.nil?
      nil
    end
        
    def mailbox_error
      return rcpt_to_error unless rcpt_to_250?
      nil
    end
    
    def status
      error.present? ? "FAILED: #{error}" : 'OK'
    end
    
    def error
      mailbox_error || host_error || nil
    end
    
    private
    
    def perform_verification
      @session[:ehlo]      = @socket.ehlo
      @session[:vrfy]      = @socket.vrfy(@mailbox)
      @session[:vrfy_rset] = @socket.rset
      @session[:expn]      = @socket.expn(@mailbox)
      @session[:expn_rset] = @socket.rset
      @session[:mail_from] = @socket.mail_from
      @session[:rcpt_to]   = @socket.rcpt_to @email
      @session[:rset]      = @socket.rset
      @session[:quit]      = @socket.quit
    end
    
    def get_mx
      records = dig_mx
      @session[:mx]  = ["Gettings MX records for #{@host}"]
      @session[:mx] << (records.present? ? records.join("\n") : "No MX records found")
      @mx = records.sort_by { |r| r.split.first.to_i }.map { |r| r.split.last }
    end
    
    def dig_mx
      resolver = DNS::Resolver.new
      records = resolver.dig @host, record: :mx
      records.include?("No Response") ? nil : records
    end
    
    def next_mx
      @mx.shift
    end
    
    def init_socket
      @socket = nil
      until @socket && @socket.connected?
        mx = next_mx
        break if mx.nil?
        @socket = SocketHandler.new mx
        @session[:socket] ||= []
        @session[:socket]  += @socket.init_message
      end
    end
    
    def rcpt_to_line
      @session[:rcpt_to].try :last
    end
    
    def rcpt_to_250?
      rcpt_to_line[0..2] == '250' if rcpt_to_line
    end
    
    def rcpt_to_error
      rcpt_to_line.lines.last.split[1..-1].join(' ').capitalize if rcpt_to_line
    end
    
  end
  
end
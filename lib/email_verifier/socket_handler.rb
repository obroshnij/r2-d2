module EmailVerifier
  
  class SocketHandler
    
    attr_reader :init_message
    
    def initialize host
      @host = host
      connect_to host
    end
    
    def connected?
      @socket.present?
    end
    
    def ehlo host = 'r2-d2.nmchp.com'
      write_and_read "EHLO #{host}"
    end
    
    def rset
      write_and_read "RSET"
    end
    
    def vrfy mailbox
      write_and_read "VRFY #{mailbox}"
    end
    
    def expn mailbox
      write_and_read "EXPN #{mailbox}"
    end
    
    def mail_from email = 'noreply@r2-d2.nmchp.com'
      write_and_read "MAIL FROM:<#{email}>"
    end
    
    def rcpt_to email
      write_and_read "RCPT TO:<#{email}>"
    end
    
    def quit
      write "QUIT"
      @socket.close
      ["QUIT", nil]
    end
    
    # private
    
    def connect_to host
      @init_message = ["Contacting #{host}"]
      Timeout::timeout(3) { @socket = TCPSocket.open host, 25 }
      @init_message << read!
    rescue Timeout::Error
      @init_message << "Timeout error: execution expired. #{host} doesn't seem to respond via port 25"
    rescue SocketError
      @init_message << "Error: #{host} doesn't seem to be valid and/or resolve"
    end
    
    def write_and_read query
      write query
      [query, read!]
    end
    
    def write query
      @socket.write "#{query}\r\n"
    end
    
    def read!
      response = nil
      Timeout::timeout(3) { response = read while response.nil? }
      response
    rescue Timeout::Error
      "Timeout error: execution expired"
    end
  
    def read
      buffer = []
      buffer << @socket.readline.strip until empty? || @socket.eof?
      buffer.join("\n") if buffer.present?
    end
    
    def empty?
      readfds, writefds, exceptfds = select([@socket], nil, nil, 0.1)
      readfds.nil?
    end
    
  end
  
end
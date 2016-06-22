require "times_retry/version"

class Integer
  # Similar to the #times but with exception handling.
  #
  # Sleep is calculated using a simple backoff function: `(60/ ((i+1) * 2))`
  # where i is decremented by 1 on each raised exception.
  #
  #  5.times_retry do
  #    puts "Executed only once"
  #  end
  #
  #  5.times_retry("Demo example", Timeout::Error, Errno::ECONNREFUSED) do
  #   raise Timeout::Error, "Testing a theory"
  #   puts "Will never print to STDOUT"
  #  end
  def times_retry(msg=nil, *exceptions)
    if exceptions.empty?
      exceptions << StandardError
    end

    downto(0) {|r|
      begin
        break yield
      rescue *exceptions => e
        raise e unless r > 0
        warn "#{e.class}: #{msg || e.message} will retry #{r} more time#{ r > 1 ? 's' : ''}"
        sleep (60 / ((r+1) * 2))
      end
    }
  end

end



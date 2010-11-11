require 'rubygems'
require 'bundler/setup'
require 'eventmachine'
require 'fastfilereaderext'

module AsciiVideo
  FrameSize = 180 * 55
  Videos = ['headphones',
            'powder',
            'snowflake',
            'on-time',
            'leader'] 

  def post_init
    puts "connected"

    send_data("\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n     *****                                          ASCII.FACTORYLABS.COM                                           *****     \r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n");
    send_data("\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n     *****     Resize your terminal to 180x55 or larger and strap yourself in.  Things are about to get Orange.     *****     \r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n");

    @start_delay = EM::Timer.new(2) do
      start_stream_timer
    end
  end


  def receive_data(data)
    if data =~ /quit/i
      @start_delay.cancel
      @timer.cancel
      close_connection 
    end
  end

  def unbind
    puts "disconnected"
    @start_delay.cancel
    @timer.cancel
  end

  private
  def start_stream_timer
    @timer = EM::PeriodicTimer.new(0.01) do
      stream_next_frame
    end
  end

  def stream_next_frame
    unless @mapping
      filename = File.join( File.dirname(__FILE__), "videos", "#{ Videos[rand(Videos.size)] }.ascii" )
      @position = 0
      @size = File.size(filename)
      @mapping = EventMachine::FastFileReader::Mapper.new filename
    end

    if @position < @size

      len = @size - @position
      len = FrameSize if len > FrameSize

      send_data( @mapping.get_chunk( @position, len ))

      @position += len

    else
      send_data('rnrnrnrnrnrnrnrn     *****     Why not check out another video?  Telnet to ascii.factorylabs.com, port 5000     *****     rnrnrnrnrnrnrnrn')
      @mapping.close
      @timer.cancel
    end
  end
end

EM.run {
  EM.start_server '0.0.0.0', 1337, AsciiVideo
}

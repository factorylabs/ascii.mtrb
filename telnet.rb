require 'rubygems'
require 'bundler/setup'
require 'eventmachine'
require 'fastfilereaderext'

module AsciiVideo
  FrameSize = 180 * 55

  def post_init
    puts "connected"
    @timer = EM::PeriodicTimer.new(0.01) do
      stream_next_frame
    end
  end

  def receive_data(data)
    if data =~ /quit/i
      @timer.cancel
      close_connection 
    end
  end

  def unbind
    puts "disconnected"
    @timer.cancel
  end

  private
  def stream_next_frame
    unless @mapping
      @position = 0
      @size = File.size('videos/headphones.ascii')
      @mapping = EventMachine::FastFileReader::Mapper.new 'videos/headphones.ascii'
    end

    if @position < @size

      len = @size - @position
      len = FrameSize if len > FrameSize

      send_data( @mapping.get_chunk( @position, len ))

      @position += len

    else
      @mapping.close
      @timer.cancel
    end
  end
end

EM.run {
  EM.start_server '0.0.0.0', 1337, AsciiVideo
}

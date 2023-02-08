module BunnyMock
  class Consumer
    attr_reader :block, :args, :queue

    def initialize(args, queue, block)
      @args = args
      @queue = queue
      @block = block
    end

    def cancel
      current_consumers = queue.instance_variable_get('@consumers')
      queue.instance_variable_set('@consumers', current_consumers - [self])
      true
    rescue Exception
      false
    end
  end
end
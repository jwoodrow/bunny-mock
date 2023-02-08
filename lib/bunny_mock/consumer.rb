module BunnyMock
  class Consumer
    attr_reader :block, :args

    def initialize(args, block)
      @args = args
      @block = block
    end
  end
end
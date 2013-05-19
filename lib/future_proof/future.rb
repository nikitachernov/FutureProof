module FutureProof
  
  # Class +Futures+ can be used to create Procs
  # that should be executed inside a Thread.
  class Future

    # Initializes new +Future+.
    #
    # @example Initialize +Future+
    #   FutureProof::Future.new { |a, b| a + b }
    def initialize(&block)
      @block = block
    end

    # Executes +Future+ in a thread with given params.
    #
    # @param [Array<Object>] *args proc arguments
    #
    # @exmaple call +Future+
    #   future.call(2, 2)
    def call(*args)
      thread(*args)
    end

    # Return a result of a +Future+.
    #
    # @param [Array<Object>] *args proc arguments if they were not suplied before.
    #
    # @note It requires list of arguments if +Future+ was not called before.
    #
    # @exmaple Get value of +Future+
    #   future.value
    def value(*args)
      thread(*args).value
    end

    # Return true if Future is done working.
    #
    # @exmaple Get state of +Future+
    #   future.complete?
    #
    # @return [true, galse] true if +Future+ is done working.
    def complete?
      !thread.alive?
    end

  private

    # Thread that +Future+ is wrapped around.
    def thread(*args)
      @thread ||= Thread.new { @block.call *args }
    end
  end
end
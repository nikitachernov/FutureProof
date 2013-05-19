module FutureProof

  # +FutureQueue+ is designed to handle exceptions that happen in a threads.
  # It raises an exception when user tries to access "exceptional" value.
  class FutureQueue < Queue

    include FutureProof::Exceptionable

    def initialize
      @finished = false
      super()
    end

    # Pushes value into a queue by executing it.
    # If execution results in an exception
    # then exception is stored itself.
    #
    # @note allowed only when queue is running.
    def push(*values, &block)
      raise_future_proof_exception if finished?
      value = if block_given?
        begin
          block.call(*values)
        rescue => e
          e
        end
      else
        values.size == 1 ? values[0] : values
      end
      super(value)
    end

    # Pops value or raises an exception.
    #
    # @return [Object] first value of queue.
    #
    # @note allowed only when queue is running.
    def pop
      raise_future_proof_exception if finished?
      raise_or_value super
    end

    # Returns +FutureArray+ with all values.
    #
    # @return [FutureProof::FutureArray] Array with values.
    #
    # @note allowed only when queue is stopped.
    def values
      raise_future_proof_exception unless finished?
      @values ||= FutureProof::FutureArray.new(instance_variable_get(:@que).dup)
    end

    # Returns +FutureArray+ with all values.
    #
    # @return [Object] value in a queue.
    #
    # @note allowed only when queue is stopped.
    # @note raises an exception if it happened during execution.
    def [](index)
      raise_future_proof_exception unless finished?
      values[index]
    end

    # Stops queue.
    def stop!
      @finished = true
    end

    # Starts queue.
    def start!
      @values   = nil
      @finished = false
    end

    # Checks if queue is stopped.
    #
    # @return [true, false] true if queue is not working.
    def finished?
      @finished
    end

  private

    # Raises an exception if queue is accessed in the wrong state.
    def raise_future_proof_exception
      raise FutureProof::FutureProofException.new 'Queu is not accessible in the state given!'
    end
  end
end
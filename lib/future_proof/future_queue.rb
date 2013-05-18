module FutureProof
  class FutureQueue < Queue

    include FutureProof::Exceptionable

    def initialize
      @finished = false
      super()
    end

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

    def pop
      raise_future_proof_exception if finished?
      raise_or_value super
    end

    def values
      raise_future_proof_exception unless finished?
      @values ||= FutureProof::FutureArray.new(instance_variable_get(:@que).dup)
    end

    def [](index)
      raise_future_proof_exception unless finished?
      values[index]
    end

    def stop!
      @finished = true
    end

    def start!
      @values   = nil
      @finished = false
    end

  private

    def finished?
      @finished
    end

    def raise_future_proof_exception
      raise FutureProof::FutureProofException.new 'Queu is not accessible in the state given!'
    end
  end
end
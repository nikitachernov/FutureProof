module FutureProof
  module Exceptionable

  private

    def raise_or_value(value)
      value.is_a?(StandardError) ? raise(value) : value
    end
  end
end
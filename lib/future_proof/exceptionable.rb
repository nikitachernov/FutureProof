module FutureProof

  # Module +Exceptionable+ provides methods to read values with exceptions.
  module Exceptionable

  private

    # Returns value or raises exception if its an exception instance.
    def raise_or_value(value)
      value.is_a?(StandardError) ? raise(value) : value
    end
  end
end
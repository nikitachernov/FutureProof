module FutureProof

  # +FutureArray+ should be used to raise exceptions
  # if specific values are exception instances
  # on a direct access with #[], #first, #last, #each, #sort and so on.
  class FutureArray
    include Enumerable
    include FutureProof::Exceptionable

    def initialize(arg)
      @arry = Array.new arg
    end

    # Acces +FutureArray+ value by index.
    def [](index)
      raise_or_value @arry[index]
    end

    # Array of values.
    #
    # @note raises an exception if any value if an exception.
    def all
      map { |a| a }
    end

    [:first, :last, :empty?].each do |method|
      define_method method do |*args, &block|
        raise_or_value @arry.send(method, *args, &block)
      end
    end

    # Iterates through array elements.
    #
    # @note raises an error if any value is an exception.
    def each
      @arry.each { |a| yield raise_or_value(a) }
    end
  end
end
module FutureProof
  class FutureArray
    include Enumerable
    include FutureProof::Exceptionable

    def initialize(arg)
      @arry = Array.new arg
    end

    def [](index)
      raise_or_value @arry[index]
    end

    def all
      map { |a| a }
    end

    [:first, :last, :empty?].each do |method|
      define_method method do |*args, &block|
        raise_or_value @arry.send(method, *args, &block)
      end
    end

    def each
      @arry.each { |a| yield raise_or_value(a) }
    end
  end
end
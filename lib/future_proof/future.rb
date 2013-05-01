class FutureProof::Future
  def initialize(&block)
    @block = block
  end

  def call(*args)
    thread(*args)
  end

  def value(*args)
    thread(*args).value
  end

  def complete?
    !thread.alive?
  end

private

  def thread(*args)
    @thread ||= Thread.new { @block.call *args }
  end
end

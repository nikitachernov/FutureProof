require 'thread'

class FutureProof::ThreadPool
  def initialize(size)
    @size    = size
    @threads = []
    @queue   = Queue.new
    @values  = Queue.new
  end

  def submit(job, *args)
    @queue.push [job, args]
  end

  def perform
    unless @threads.any? { |t| t.alive? }
      @size.times do
        @threads << Thread.new do
          while job = @queue.pop
            if job == :END_OF_WORK
              break
            else
              result = begin
                job[0].call(*job[1])
              rescue => e
                e.to_s
              end
              @values.push result
            end
          end
        end
      end
    end
  end

  def finalize
    @size.times { @queue.push :END_OF_WORK }
  end

  def wait
    finalize
    @threads.map &:join
  end

  def values
    wait
    @values.instance_variable_get(:@que)
  end

  def finalize
    @size.times { @queue.push :END_OF_WORK }
  end

  def finalize!
    @queue.clear
    finalize
  end
end

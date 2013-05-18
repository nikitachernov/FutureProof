require 'thread'

module FutureProof
  class ThreadPool
    def initialize(size)
      @size    = size
      @threads = []
      @queue   = Queue.new
      @values  = FutureProof::FutureQueue.new
    end

    def submit(*args, &block)
      @queue.push [block, args]
    end

    def perform
      unless @threads.any? { |t| t.alive? }
        @values.start!
        @size.times do
          @threads << Thread.new do
            while job = @queue.pop
              if job == :END_OF_WORK
                break
              else
                @values.push *job[1], &job[0]
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
      @values.stop!
      @values.values
    end

    def finalize
      @size.times { @queue.push :END_OF_WORK }
    end

    def finalize!
      @queue.clear
      finalize
    end
  end
end
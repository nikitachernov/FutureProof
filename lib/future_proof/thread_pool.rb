require 'thread'

module FutureProof

  # +ThreadPool+ could be used to schedule and group threads.
  class ThreadPool
    # Initializes a new thread pool.
    #
    # @params [FixNum] size the size of the pool thread.
    def initialize(size)
      @size    = size
      @threads = []
      @queue   = Queue.new
      @values  = FutureProof::FutureQueue.new
    end

    # Submits a task to a thread pool.
    #
    # @param [Array<Object>] *args job arguments.
    #
    # @example
    #   thread_pool.submit(25, 2) { |a, b| a ** b }
    #
    # @note Does not start the execution until #perform is called.
    def submit(*args, &block)
      @queue.push [block, args]
    end

    # Starts execution of the thread pool.
    #
    # @note Can be restarted after finalization.
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

    # Flags that after all pool jobs are processed thread pool should stop the reactor.
    def finalize
      @size.times { @queue.push :END_OF_WORK }
    end

    # Calls #finalize and block programm flow until all jobs are processed.
    def wait
      finalize
      @threads.map &:join
    end

    # Calls #wait and returns array of all calculated values.
    #
    # @return [FutureProof::FutureArray] instance of FutureArray with all values.
    def values
      wait
      @values.stop!
      @values.values
    end

    # Commands to remove all pool tasks and finishes the execution after all running tasks are completed.
    def finalize!
      @queue.clear
      finalize
    end
  end
end
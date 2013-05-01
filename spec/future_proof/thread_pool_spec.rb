require 'spec_helper'

describe FutureProof::ThreadPool do

  let(:pool_size)   { 3                                    }
  let(:task)        { Proc.new { |a,b| sleep 1; a / b }    }
  let(:thread_pool) { FutureProof::ThreadPool.new pool_size }

  describe '#submit' do
    before { thread_pool.submit(task, 24, 2) }

    it 'task should be submitted to queue' do
      thread_pool.instance_variable_get(:@queue).size.should eq 1
    end

    context 'before perform' do
      it 'shold not have been started to execute' do
        thread_pool.finalize!
        thread_pool.perform
        thread_pool.values.should be_empty
      end
    end

    context 'after perform' do
      before { thread_pool.perform }

      describe 'first task' do
        it 'should start executing' do
          thread_pool.finalize
          thread_pool.values.should eq [12]
        end
      end

      describe 'rest tasks' do
        it 'should start executing on #submit' do
          thread_pool.submit task, 6, 3
          sleep 3
          thread_pool.instance_variable_get(:@values).instance_variable_get(:@que).size.should eq 2
        end
      end
    end
  end

  describe '#finalize' do
    it 'should allow all tasks to finish' do
      5.times { thread_pool.submit(task, 24, 2) }
      thread_pool.finalize
      thread_pool.perform
      thread_pool.values.should eq [12, 12, 12, 12, 12]
    end
  end


  describe '#finalize!' do
    it 'should not start executing not started tasks' do
      5.times { thread_pool.submit(task, 24, 2) }
      thread_pool.perform
      sleep 0.5
      thread_pool.finalize!
      thread_pool.values.should eq [12, 12, 12]
    end
  end

  describe 'exceptions' do
    before { thread_pool.submit(task, 24, 0) }

    it 'should not raise exceptions' do
      expect { thread_pool.perform; thread_pool.wait }.not_to raise_error
    end

    it 'should return name of an exception' do
      thread_pool.perform
      thread_pool.values.should eq ['divided by 0']
    end
  end
end
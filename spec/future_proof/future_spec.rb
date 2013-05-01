require 'spec_helper'

describe FutureProof::Future do

  let(:future) do
    FutureProof::Future.new do |a, b|
      sleep 1
      a / b
    end
  end

  describe '#call' do
    it 'should run a thread' do
      future.call(24, 2).should be_an_instance_of Thread
    end
  end

  describe '#value' do
    context 'before #call' do
      it 'should calculate value' do
        future.value(24, 2).should eq 12
      end
    end

    context 'after #call' do
      before { @thread = future.call(24, 2) }

      it 'should not require arguments' do
        future.value.should eq 12
      end

      it 'should use the same thread' do
        @thread.should_receive(:value)
        future.value
      end
    end
  end

  describe '#comlete?' do
    before { future.call(24, 2) }

    context 'not finished' do
      it 'should not be completed' do
        future.should_not be_complete
      end
    end

    context 'finished' do
      it 'should be completed' do
        sleep 2
        future.should be_complete
      end
    end
  end

  describe 'exceptions' do
    describe '#call' do
      it 'should not raise exeptions' do
        expect { future.call(24, 0); sleep 2 }.not_to raise_error
      end
    end

    describe '#value' do
      it 'should raise exeption' do
        expect { future.value(24, 0) }.to raise_error ZeroDivisionError
      end
    end
  end
end
require 'spec_helper'

describe FutureProof::FutureQueue do
  let(:future_queue) { FutureProof::FutureQueue.new }

  describe '#push' do
    context 'running' do
      context 'without exception' do
        it 'should push' do
          expect {
            future_queue.push 24, 2 do |a, b|
              a / b
            end
          }.not_to raise_error
        end
      end

      context 'with exception' do
        it 'should push' do
          expect {
            future_queue.push 24, 0 do |a, b|
              a / b
            end
          }.not_to raise_error
        end
      end
    end

    context 'stoped' do
      before { future_queue.stop! }
      it 'should not push' do
        expect { future_queue.push 5 }.to raise_error(FutureProof::FutureProofException)
      end
    end
  end

  describe '#pop' do
    context 'running' do
      context 'without exception' do
        before { future_queue.push 77 }
        it 'should pop value' do
          future_queue.pop.should eq 77
        end
      end

      context 'with exception' do
        before { future_queue.push ZeroDivisionError.new }
        it 'should raise error' do
          expect { future_queue.pop }.to raise_error(ZeroDivisionError)
        end
      end
    end

    context 'stoped' do
      before { future_queue.stop! }
      it 'should raise error' do
        expect { future_queue.pop }.to raise_error(FutureProof::FutureProofException)
      end
    end
  end

  describe '#values' do
    context 'stoped' do
      before { future_queue.stop! }
      it 'should return instance of FutureArray' do
        future_queue.values.should be_instance_of FutureProof::FutureArray
      end
    end

    context 'running' do
      it 'should not allow get values' do
        expect { future_queue.values }.to raise_error(FutureProof::FutureProofException)
      end
    end
  end

  describe '#[]' do
    context 'stoped' do
      context 'single value' do
        before do
          future_queue.push 25
          future_queue.stop!
        end

        it 'should return value' do
          future_queue[0].should eq 25
        end
      end

      context 'multiple values' do
        before do
          future_queue.push 25, 34
          future_queue.stop!
        end

        it 'should return value' do
          future_queue[0].should eq [25, 34]
        end
      end

      context 'exception' do
        before do
          future_queue.push ZeroDivisionError.new
          future_queue.stop!
        end

        it 'should raise exception' do
          expect { future_queue[0] }.to raise_error(ZeroDivisionError)
        end
      end

    end

    context 'running' do
      it 'should not allow acess value' do
        expect { future_queue[0] }.to raise_error(FutureProof::FutureProofException)
      end
    end
  end

  describe '#stop and #start' do
    it 'should allow stop and run queue multiple times' do
      future_queue.push 1
      future_queue.push 2
      future_queue.push 3

      future_queue.stop!

      array_id = future_queue.values.object_id

      array_id.should eq future_queue.values.object_id

      future_queue.start!      

      future_queue.push 4
      future_queue.push 5
      future_queue.push 6

      future_queue.pop.should eq 1
      future_queue.pop.should eq 2
      future_queue.pop.should eq 3
      
      future_queue.stop!

      array_id.should_not eq future_queue.values.object_id

      future_queue.start!

      future_queue.pop.should eq 4
      future_queue.pop.should eq 5
      future_queue.pop.should eq 6
    end
  end
end
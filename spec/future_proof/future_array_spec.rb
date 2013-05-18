require 'spec_helper'

describe FutureProof::FutureArray do
  let(:future_array) do
    FutureProof::FutureArray.new [1, 2, 3, 4, 5]
  end

  let(:future_array_with_exception) do
    FutureProof::FutureArray.new [1, 2, 3, 4, ZeroDivisionError.new]
  end

  describe '#[]' do
    context 'without exception' do
      it 'should retrun value' do
        future_array[4].should eq 5
      end
    end

    context 'with_exception' do
      it 'should raise exception' do
        expect { future_array_with_exception[4] }.to raise_error(ZeroDivisionError)
      end      
    end
  end

  describe '#last' do
    context 'without exception' do
      it 'should retrun value' do
        future_array.last.should eq 5
      end
    end

    context 'with_exception' do
      it 'should raise exception' do
        expect { future_array_with_exception.last }.to raise_error(ZeroDivisionError)
      end      
    end
  end

  describe '#select' do
    context 'without exception' do
      it 'should select value' do
        future_array.select { |e| e.even? }.should eq [2, 4]
      end
    end

    context 'with_exception' do
      it 'should raise exception' do
        expect { future_array_with_exception.select { |e| e.even? } }.to raise_error(ZeroDivisionError)
      end
    end
  end
end
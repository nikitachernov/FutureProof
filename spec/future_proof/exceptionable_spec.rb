require 'spec_helper'

describe FutureProof::Exceptionable do
  let(:exceptionable) do
    class TestExceptionable
      include FutureProof::Exceptionable
    end
    TestExceptionable.new
  end

  context 'without exception' do
    it 'should return value' do
      exceptionable.send(:raise_or_value, 25).should eq 25
    end
  end

  context 'with exception' do
   it 'should raise error' do
      expect {
        exceptionable.send(:raise_or_value, ZeroDivisionError.new)
      }.to raise_error(ZeroDivisionError)
    end
  end
end
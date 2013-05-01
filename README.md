# FutureProof

FutureProof provides concurrency extensions for Ruby.

[![Build Status](https://travis-ci.org/nikitachernov/FutureProof.png)](https://travis-ci.org/nikitachernov/FutureProof)

## Installation

Add this line to your application's Gemfile:

    gem 'future_proof'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install future_proof

## Usage

### Future

    f = FutureProof::Future.new { |a, b| a + b }

    f.call(1, 2) # => executing in a thread

    f.value # => returning value when ready

### ThreadPool

    tp = FutureProof::ThreadPool.new(5)

    10.times do |i|
      tp.submit(Proc.new { |a, b| a + b }, i, i + 1)
    end

    tp.perform # executing 10 procs in 5 threads

    tp.values # releasing threads and returning values

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

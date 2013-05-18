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

    future = FutureProof::Future.new { |a, b| a + b }

    future.call(1, 2) # => executes in a thread

    future.value # => returns value when ready

### ThreadPool

    thread_pool = FutureProof::ThreadPool.new(5)

    10.times do |i|
      thread_pool.submit i, i + 1 do |a, b|
        a + b
      end
    end

    thread_pool.perform # executes 10 procs in 5 threads

    thread_pool.values # releases threads and returns values

## Exceptions

  If exception happens inside a thread it doesn't affect the whole process.
  Exception is raised when accessing specific value:
      thread_pool.values[3] # => raises exception

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

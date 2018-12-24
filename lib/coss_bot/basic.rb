# frozen_string_literal: true

module CossBot
  class Basic
    attr_reader :exchange
    attr_accessor :interval, :lot_size, :profit, :pair, :trade_limit, :logger

    def initialize(public_key:, private_key:, logger: Logger.new(STDOUT))
      @exchange = CossApiRubyWrapper::Exchange.new(public_key: public_key, private_key: private_key)
      @logger = logger
    end

    def call(&block)
      validate_params!
      loop do
        time = Benchmark.measure { tick(&block) }.real
        wait_time = time > interval ? 0 : interval - time
        sleep(wait_time)
      end
    end

    private

    def validate_params!
      return if !trade_limit.nil? &&
                pair.to_s =~ /\A\w+_\w+\Z/ &&
                profit.to_f.positive? &&
                lot_size.to_f.positive? &&
                interval.to_i > 1

      raise ArgumentError, 'Some params are invalid'
    end
  end
end

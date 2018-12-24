# CossBot

This bot has simplest trading strategies implemented for trading on COSS.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'coss_bot'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install coss_bot

## Usage

```ruby
bot = CossBot::BuyLowSellHigh.new(public_key: 'Public Key', private_key: 'Private Key')
bot.interval = 20 # Trading cycle will happen every 20 seconds
bot.lot_size = 10 # 10 coss tokens will be bought/sold
bot.profit = 0.1 # SELL order will be 0.1% higher than BUY order
bot.pair = 'COSS_ETH' # Bot will work on COSS_ETH pair, buying COSS for ETH
bot.trade_limit = 0.01 # trading cycle does not start if ETH limit is less than 0.1 ETH (ETH is chosen because it is a base pair in this case. If it would be BTC_USDT - it would be USDT)
bot.logger = Rails.logger # optionally set logger
bot.call do |buy_order_id, sell_order_id|
  puts "BUY order id: #{buy_order_id}; SELL order id: #{sell_order_id}" # You can pass block to save order ids.
end

```


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the CossBot project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/coss-community/coss_bot/blob/master/CODE_OF_CONDUCT.md).

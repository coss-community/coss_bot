# frozen_string_literal: true

module CossBot
  class BuyLowSellHigh < Basic
    private

    def tick
      logger.info('=== Start of trading cycle ===')
      balances = exchange.account_balances
      currency_to_sell = pair.split('_').last
      current_balance = balances.detect { |c| c['currency_code'] == currency_to_sell }['available'].to_f
      pair_depth = exchange.pair_depth(pair)
      current_price = pair_depth['asks'].first.first.to_f

      if current_balance <= trade_limit.to_f
        yield(nil, nil, { status: 0, message: 'Current balance <= trade limit' })
      elsif current_balance <= current_price * lot_size
        yield(nil, nil, { status: 0, message: 'Current balance <= current_price * lot_size' })
      else
        price_with_profit = (current_price + (current_price / 100 * profit.to_f)).round(6)
        logger.info("Placing BUY order for #{current_price}. Lot size: #{lot_size}")
        buy_response = exchange.place_limit_order(pair, current_price, 'BUY', lot_size)
        logger.info("Placing SELL order for #{price_with_profit}. Lot size: #{lot_size}")
        sell_response = exchange.place_limit_order(pair, price_with_profit, 'SELL', lot_size)
        logger.info('=== End of trading cycle ===')

        error = {}

        if buy_response[:status].present? || sell_response[:status].present?
          error[:message] = {
            buy: buy_response,
            sell: sell_response
          }
          error[:status] = 999
        end

        yield(buy_response, sell_response, error)
      end
    end
  end
end

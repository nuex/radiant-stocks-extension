module StocksTags
  include Radiant::Taggable

  class TagError < StandardError; end

  tag 'stocks' do |tag|
    tag.expand
  end

  desc %{
    Cycles through all stocks referenced in the `for' attribute.

    *Usage:*
    <pre><code><r:stocks:each [for="goog,msft"]>...</r:stocks:each></code></pre>
  }
  tag 'stocks:each' do |tag|
    options = tag.attr.dup
    result = []
    raise TagError, "'for' attribute required" unless stocks = options.delete('for')
    stocks = Rquote.new.find(stocks)
    stocks.each do |stock|
      tag.locals.stock = stock
      result << tag.expand
    end
    result
  end

  [:symbol, :price, :change, :volume].each do |method|
    desc %{
      Renders the `#{method.to_s}' attribute of the stock.
    }
    tag "stocks:#{method.to_s}" do |tag|
      tag.locals.stock[method]
    end
  end
end

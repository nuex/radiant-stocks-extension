module StocksTags
  include Radiant::Taggable

  class TagError < StandardError; end

  desc %{
    Namespace for referencing a stock.
    Use the `for' attribute to reference a single stock.

    *Usage:*
    <pre><code><r:stocks [for="goog"]>...</r:stocks></code></pre>
  }
  tag 'stocks' do |tag|
    options = tag.attr.dup
    tag.locals.stock = find_stock(tag,options) unless options.empty?
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
    stocks = Rquote.new.find(*stocks.split(','))
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

  desc %{
    Expands inner tags if the stock has a negative change.
    The 'for' attribute is required on this tag or the parent tag.

    *Usage:*
    <pre><code><r:stocks:if_negative [for="goog"]>...</r:stocks:if_negative></code></pre>
  }
  tag "stocks:if_negative" do |tag|
    options = tag.attr.dup
    stock = find_stock(tag,options)
    tag.expand if stock[:change].include?('-')
  end

  desc %{
    Expands inner tags if the stock has a positive change.
    The 'for' attribute is required on this tag or the parent tag.

    *Usage:*
    <pre><code><r:stocks:if_positive [for="goog"]>...</r:stocks:if_positive></code></pre>
  }
  tag "stocks:if_positive" do |tag|
    options = tag.attr.dup
    stock = find_stock(tag,options)
    tag.expand if stock[:change].include?('+')
  end

  private

  def find_stock(tag, options)
    raise TagError, "'for' attribute required" unless stocks = options.delete('for') or tag.locals.stock
    tag.locals.stock || Rquote.new.find(stocks.split(',').first).first
  end

end

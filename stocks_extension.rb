class StocksExtension < Radiant::Extension
  version "0.1"
  description "Shows stock quotes"
  url "http://github.com/nuex/radiant-stocks-extension.git"
  
  def activate
    Page.send :include, StocksTags
  end
  
  def deactivate
  end
  
end

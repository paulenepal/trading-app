module CachedStockFetchers
  extend ActiveSupport::Concern

  private

  def fetch_watchlist_data
    stock_symbols = JSON.parse(File.read(Rails.root.join('data', 'stock_symbols.json')))
    stock_symbols.map do |stock|
      symbol = stock['symbol']
      fetch_stock_data(symbol)
    end
  end

  def fetch_stock_data(symbol)
    {
      symbol: symbol,
      latest_price: fetch_cached_quote(symbol).latest_price,
      company_name: fetch_cached_quote(symbol).company_name,
      change: fetch_cached_quote(symbol).change,
      change_percent: fetch_cached_quote(symbol).change_percent_s,
      logo: fetch_cached_logo(symbol).url,
      chart: fetch_cached_chart(symbol),
      ceo: fetch_cached_company(symbol).ceo,
      description: fetch_cached_company(symbol).description,
      employees: fetch_cached_company(symbol).employees,
      website: fetch_cached_company(symbol).website,
      exchange: fetch_cached_company(symbol).exchange
    }
  end

  def fetch_cached_quote(symbol)
    Rails.cache.fetch("#{symbol}/quote", expires_in: CACHE_EXP_QUOTE) do
      IexStockService.fetch_quote(symbol)
    end
  end

  def fetch_cached_logo(symbol)
    Rails.cache.fetch("#{symbol}/logo", expires_in: CACHE_EXP_LOGO) do
      IexStockService.fetch_logo(symbol)
    end
  end

  def fetch_cached_chart(symbol)
    Rails.cache.fetch("#{symbol}/chart", expires_in: CACHE_EXP_CHART) do
      IexStockService.fetch_chart(symbol)
    end
  end

  def fetch_cached_ohlc(symbol)
    Rails.cache.fetch("#{symbol}/ohlc", expires_in: CACHE_EXP_OHLC) do
      IexStockService.fetch_ohlc(symbol)
    end
  end

  def fetch_cached_historical_prices(symbol)
    Rails.cache.fetch("#{symbol}/historical_prices", expires_in: CACHE_EXP_HIST_PRICES) do
      IexStockService.fetch_historical_prices(symbol)
    end
  end

  def fetch_cached_news(symbol)
    Rails.cache.fetch("#{symbol}/news", expires_in: CACHE_EXP_NEWS) do
      IexStockService.fetch_news(symbol)
    end
  end

  def fetch_cached_company(symbol)
    Rails.cache.fetch("#{symbol}/company", expires_in: CACHE_EXP_NEWS) do
      IexStockService.fetch_company(symbol)
    end
  end

end
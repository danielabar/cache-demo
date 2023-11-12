class Product < ApplicationRecord
  validates :name, :description, :price, presence: true
  validates :name, uniqueness: true

  # No caching, calls slow operation every time
  def better_than_the_competition?
    competitors_prices = find_competing_prices
    competitors_prices.all? { |_, competitor_price| price < competitor_price }
  end

  # Cache read and write
  def better_than_the_competition?
    competitors_prices = Rails.cache.read("#{cache_key}/competing_prices")

    if competitors_prices.blank?
      competitors_prices = find_competing_prices
      Rails.cache.write("#{cache_key}/competing_prices", competitors_prices)
    end

    competitors_prices.all? { |_, competitor_price| price < competitor_price }
  end

  # Cache fetch
  def better_than_the_competition?
    competitors_prices = Rails.cache.fetch("#{cache_key}/competing_prices") do
      find_competing_prices
    end
    competitors_prices.all? { |_, competitor_price| price < competitor_price }
  end

  # Cache fetch with version
  # Cache invalidation is hard, Rails can help with
  # `cache_key_with_version` method, which includes the model's
  # last_updated timestamp, so if the model has been updated
  # since the last time it was written to cache, it will automatically
  # be invalidated.
  # By default it uses last_updated, but you can also define your own
  # see: https://api.rubyonrails.org/classes/ActiveRecord/Integration.html#method-i-cache_version
  def better_than_the_competition?
    competitors_prices = Rails.cache.fetch("#{cache_key_with_version}/competing_prices") do
      find_competing_prices
    end
    competitors_prices.all? { |_, competitor_price| price < competitor_price }
  end

  # In a real app, this would be in a service that's responsible
  # for making an external API call and returning the result.
  def find_competing_prices
    logger.info("Looking up competing prices for product #{id}...")
    sleep(3)
    {
      competitor_a: 29.99,
      competitor_b: 31.49,
      competitor_c: 29.55,
    }
  end
end

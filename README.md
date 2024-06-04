# Cache Demo with Rails

Companion project for a [blog post](https://danielabaron.me/blog/rails-cache-elegance/) about caching with Rails.

Setup:

```bash
bin/setup
```

Populate seeds:

```bash
bin/rails db:seed
```

Enable caching in development mode:

```bash
bin/rails dev:cache
```

Launch Rails console `bin/rails c`:

```ruby
product = Product.first
product.price.to_s
# => "77.84"

# Not yet in the cache, performs slow operation:
product.better_than_the_competition?
# Looking up competing prices for product 6...
# => false

# Now its in the cache, fast lookup:
product.better_than_the_competition?
# => false

# Updating product invalidates cache:
product.update!(price: 2.99)
product.better_than_the_competition?
# Looking up competing prices for product 6...
# => true

# Now updated product is in the cache, fast lookup:
product.update!(price: 2.99)
# => true
```

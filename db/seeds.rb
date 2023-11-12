Product.destroy_all

5.times do |i|
  Product.create!(
    name: "Product #{i + 1}",
    description: "This is the description for Product #{i + 1}.",
    price: rand(10.0..100.0).round(2)
  )
end

puts "Seed data has been successfully created!"

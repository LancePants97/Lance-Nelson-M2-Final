# Rake::Task["csv_load:all"].invoke

# These seeds are for user story 7
merchant1 = Merchant.create!(name: "Hair Care")
merchant2 = Merchant.create!(name: "Jewelry")

coupon1 = Coupon.create!(name: "50% Off!", code: "12345", value: 50, discount_type: 0, status: 1, merchant_id: merchant1.id)
coupon2 = Coupon.create!(name: "10% Off!", code: "54321", value: 10, discount_type: 0, status: 0, merchant_id: merchant1.id)
coupon3 = Coupon.create!(name: "$2 Off!", code: "TWOTODAY", value: 2, discount_type: 1, status: 1, merchant_id: merchant1.id)
coupon4 = Coupon.create!(name: "$3 Off!", code: "3DOLLAR", value: 3, discount_type: 1, status: 1, merchant_id: merchant2.id)
coupon5 = Coupon.create!(name: "$6 Off!", code: "6DOLLAR", value: 6, discount_type: 1, status: 0, merchant_id: merchant2.id)
coupon6 = Coupon.create!(name: "$10 Off!", code: "10DOLLAR", value: 10, discount_type: 1, status: 1, merchant_id: merchant2.id)

item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: merchant1.id, status: 1)
item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: merchant1.id)
item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: merchant1.id)
item_4 = Item.create!(name: "Hair tie", description: "This holds up your hair", unit_price: 1, merchant_id: merchant1.id)
item_7 = Item.create!(name: "Scrunchie", description: "This holds up your hair but is bigger", unit_price: 3, merchant_id: merchant1.id)
item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: merchant1.id)

item_5 = Item.create!(name: "Bracelet", description: "Wrist bling", unit_price: 200, merchant_id: merchant2.id)
item_6 = Item.create!(name: "Necklace", description: "Neck bling", unit_price: 300, merchant_id: merchant2.id)

customer_1 = Customer.create!(first_name: "Joey", last_name: "Smith")
customer_2 = Customer.create!(first_name: "Cecilia", last_name: "Jones")
customer_3 = Customer.create!(first_name: "Mariah", last_name: "Carrey")
customer_4 = Customer.create!(first_name: "Leigh Ann", last_name: "Bron")
customer_5 = Customer.create!(first_name: "Sylvester", last_name: "Nader")
customer_6 = Customer.create!(first_name: "Herber", last_name: "Kuhn")

invoice_1 = Invoice.create!(customer_id: customer_1.id, status: 2, created_at: "2012-03-27 14:54:09", coupon_id: coupon3.id)
invoice_2 = Invoice.create!(customer_id: customer_1.id, status: 2, created_at: "2012-03-28 14:54:09", coupon_id: coupon2.id)
invoice_3 = Invoice.create!(customer_id: customer_2.id, status: 2, coupon_id: coupon6.id) # test
invoice_4 = Invoice.create!(customer_id: customer_3.id, status: 2, coupon_id: coupon1.id)
invoice_5 = Invoice.create!(customer_id: customer_4.id, status: 2)
invoice_6 = Invoice.create!(customer_id: customer_5.id, status: 2, coupon_id: coupon4.id)
invoice_7 = Invoice.create!(customer_id: customer_6.id, status: 2, coupon_id: coupon2.id)

invoice_8 = Invoice.create!(customer_id: customer_6.id, status: 1, coupon_id: coupon4.id) # test
invoice_9 = Invoice.create!(customer_id: customer_2.id, status: 1) # test

ii_1 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_1.id, quantity: 9, unit_price: 10, status: 2)
ii_2 = InvoiceItem.create!(invoice_id: invoice_2.id, item_id: item_1.id, quantity: 1, unit_price: 10, status: 2)
ii_3 = InvoiceItem.create!(invoice_id: invoice_3.id, item_id: item_5.id, quantity: 1, unit_price: 8, status: 2)
ii_4 = InvoiceItem.create!(invoice_id: invoice_4.id, item_id: item_3.id, quantity: 3, unit_price: 5, status: 1)
ii_6 = InvoiceItem.create!(invoice_id: invoice_5.id, item_id: item_4.id, quantity: 1, unit_price: 1, status: 1)
ii_7 = InvoiceItem.create!(invoice_id: invoice_6.id, item_id: item_7.id, quantity: 1, unit_price: 3, status: 1)
ii_8 = InvoiceItem.create!(invoice_id: invoice_7.id, item_id: item_8.id, quantity: 1, unit_price: 5, status: 1)
ii_9 = InvoiceItem.create!(invoice_id: invoice_7.id, item_id: item_4.id, quantity: 1, unit_price: 1, status: 1)
ii_10 = InvoiceItem.create!(invoice_id: invoice_8.id, item_id: item_5.id, quantity: 1, unit_price: 1, status: 1) # test
ii_11 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_8.id, quantity: 12, unit_price: 6, status: 1)

transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: invoice_1.id)
transaction2 = Transaction.create!(credit_card_number: 230948, result: 1, invoice_id: invoice_2.id)
transaction3 = Transaction.create!(credit_card_number: 234092, result: 1, invoice_id: invoice_3.id)
transaction4 = Transaction.create!(credit_card_number: 230429, result: 1, invoice_id: invoice_4.id)
transaction5 = Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: invoice_5.id)
transaction6 = Transaction.create!(credit_card_number: 879799, result: 0, invoice_id: invoice_6.id)
transaction7 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: invoice_7.id)
transaction8 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: invoice_8.id)



# These seeds are for user story 8
# m1 = Merchant.create!(name: "Merchant 1")
# m2 = Merchant.create!(name: "Merchant 2")
# coupon1 = Coupon.create!(name: "50% Off!", code: "12345", value: 50, discount_type: 0, status: 1, merchant_id: m1.id)
# coupon2 = Coupon.create!(name: "10% Off!", code: "54321", value: 10, discount_type: 0, status: 0, merchant_id: m1.id)
# coupon3 = Coupon.create!(name: "$2 Off!", code: "TWOTODAY", value: 2, discount_type: 1, status: 1, merchant_id: m1.id)
# coupon4 = Coupon.create!(name: "Half Off!", code: "Halfsies", value: 50, discount_type: 0, status: 1, merchant_id: m2.id)
# coupon5 = Coupon.create!(name: "$10 Off!", code: "10DOLLAR", value: 10, discount_type: 1, status: 1, merchant_id: m2.id)
# c1 = Customer.create!(first_name: "Yo", last_name: "Yoz", address: "123 Heyyo", city: "Whoville", state: "CO", zip: 12345)
# c2 = Customer.create!(first_name: "Hey", last_name: "Heyz")
# i1 = Invoice.create!(customer_id: c1.id, status: 2, created_at: "2012-03-25 09:54:09", coupon_id: coupon4.id)
# i2 = Invoice.create!(customer_id: c2.id, status: 1, created_at: "2012-03-25 09:30:09", coupon_id: coupon3.id)
# i3 = Invoice.create!(customer_id: c1.id, status: 1, created_at: "2012-03-25 09:31:09")
# i4 = Invoice.create!(customer_id: c1.id, status: 1, created_at: "2012-03-25 09:31:09", coupon_id: coupon2.id)
# i5 = Invoice.create!(customer_id: c2.id, status: 1, created_at: "2012-03-25 09:31:09", coupon_id: coupon5.id)
# item_1 = Item.create!(name: "test", description: "lalala", unit_price: 6, merchant_id: m1.id)
# item_2 = Item.create!(name: "rest", description: "dont test me", unit_price: 12, merchant_id: m1.id)
# item_3 = Item.create!(name: "best", description: "please test me", unit_price: 10, merchant_id: m2.id)
# ii_1 = InvoiceItem.create!(invoice_id: i1.id, item_id: item_1.id, quantity: 12, unit_price: 2, status: 0)
# ii_2 = InvoiceItem.create!(invoice_id: i1.id, item_id: item_2.id, quantity: 6, unit_price: 1, status: 1)
# ii_3 = InvoiceItem.create!(invoice_id: i2.id, item_id: item_2.id, quantity: 14, unit_price: 12, status: 2)
# ii_4 = InvoiceItem.create!(invoice_id: i1.id, item_id: item_3.id, quantity: 10, unit_price: 5, status: 1)
# ii_5 = InvoiceItem.create!(invoice_id: i2.id, item_id: item_3.id, quantity: 15, unit_price: 2, status: 1)
# ii_6 = InvoiceItem.create!(invoice_id: i3.id, item_id: item_2.id, quantity: 10, unit_price: 2, status: 1)
# ii_7 = InvoiceItem.create!(invoice_id: i3.id, item_id: item_3.id, quantity: 5, unit_price: 5, status: 1)
# ii_8 = InvoiceItem.create!(invoice_id: i5.id, item_id: item_3.id, quantity: 1, unit_price: 5, status: 1)
# ii_9 = InvoiceItem.create!(invoice_id: i5.id, item_id: item_3.id, quantity: 1, unit_price: 2, status: 1)
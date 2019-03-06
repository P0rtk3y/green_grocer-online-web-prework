require 'pry'

def consolidate_cart(cart)
  update_cart = {}
  
  cart.each do |item_hash|
    item_hash.each do |item, info|
      if update_cart.has_key?(item)
        update_cart[item][:count] += 1 
      else 
        update_cart = update_cart.merge({item => info.merge({:count => 1})})
      end 
    end 
  end 
  update_cart 
end

def apply_coupons(cart, coupons)
  count_hash = {}
  coupons.each do |hash|
    hash.each do |key, value|
      if cart.has_key?(value)
        if key == :item
          if count_hash[value] == nil 
           count_hash[value] = 1
          else 
           count_hash[value] += 1
          end 
          cart[value + " W/COUPON"] = {price: hash[:cost], clearance: cart[value][:clearance], count: count_hash[value]} 
          cart[value][:count] = cart[value][:count] % hash[:num]
        end
      end
    end
  end 
  cart 
end	

def apply_clearance(cart)
  cart.each do |item_hash, info_hash|
    if info_hash.values.include?(true)
      updated_price = info_hash[:price] * 0.8 
      info_hash[:price] = updated_price.round(2) 
    end 
  end 
  cart 
end

def checkout(cart=[], coupons=[])
  consolidated_cart = consolidate_cart(cart)
  couponed_cart = apply_coupons(consolidated_cart, coupons)
  final_cart = apply_clearance(couponed_cart)
  final_price = 0 
  
  final_cart.each do |key, info_hash|
    final_price += info_hash[:price] * info_hash[:count] 
  end 
  
  final_price = final_price * 0.9 if final_price > 100 
  final_price 
end

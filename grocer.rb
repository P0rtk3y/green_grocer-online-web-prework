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
  coupons.each do |coupon|
    if cart.has_key?(coupon[:item])
      if cart[coupon[:item]][:count] >= coupon[:num]
        cart[coupon[:item]][:count] -= coupon[:num]
        new_item = "#{coupon[:item]} W/COUPON"
        if cart.has_key?(new_item)
          cart[new_item][:count] += 1
        else
          cart[new_item] = {:price => coupon[:cost], :count => 1, :clearance => cart[coupon[:item]][:clearance]}
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

def checkout(cart, coupons)
  consolidated_cart = consolidate_cart(cart)
  couponed_cart = apply_coupons(consolidated_cart, coupons)
  final_cart = apply_clearance(couponed_cart)
  final_price = 0 
  
  final_cart.each do |key, info_hash|
    final_price += info_hash[:price] * info_hash[:count] 
  end 
  
  if final_price > 100 
     final_price = final_price * 0.9 
  end 
  final_price 
end

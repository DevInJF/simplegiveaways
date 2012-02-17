# -*- encoding : utf-8 -*-
Factory.sequence :pid do |i|
  "1#{i}3#{i}5#{i}7#{i}9"
end

Factory.define :facebook_page do |page|
  page.name { Faker::Company.name }
  page.category "Business"
  page.description { Faker::Company.catch_phrase }
  page.url "http://www.facebook.com/pages/Simple-Giveaway-App/241368822556925"
  page.pid { Factory.next(:pid) }
  page.likes rand(1234567)
end

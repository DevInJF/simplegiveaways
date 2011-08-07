Factory.sequence :uid do |i|
  "2#{i}4#{i}6#{i}"  
end

Factory.define :entry do |entry|
  entry.name { Faker::Name.name }
  entry.email { Faker::Internet.email }
  entry.uid { Factory.next(:uid) }
  entry.fb_url "http://facebook.com/hnovick"
  entry.datetime_entered DateTime.now
  entry.giveaway { (Giveaway.count > 0 ? Giveaway.all.sort_by{ rand }.first : Factory.create(:giveaway)) }
end

Factory.define :incomplete_entry, :parent => :entry do |entry|
  entry.has_liked_mandatory false
  entry.has_liked_primary false
  entry.status "incomplete"
end

Factory.define :complete_entry, :parent => :entry do |entry|
  entry.has_liked_mandatory true
  entry.has_liked_primary true
  entry.status "complete"
  entry.share_count rand(50)
  entry.request_count rand(50)
  entry.convert_count rand(50)
end
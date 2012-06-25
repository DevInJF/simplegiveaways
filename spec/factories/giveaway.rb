## -*- encoding : utf-8 -*-
#include ActionDispatch::TestProcess
#
#Factory.define :giveaway do |giveaway|
#
#  now = DateTime.now + 10.minutes
#  later = now + 6.weeks
#
#  giveaway.title { Faker::Lorem.sentence(word_count = 7) }
#  giveaway.description { Faker::Lorem.sentence(word_count = 20) }
#  giveaway.prize { Faker::Lorem.sentence(word_count = 4) }
#  giveaway.image { fixture_file_upload("#{RAILS_ROOT}/spec/factories/pixel.png", "image/png") }
#  giveaway.feed_image { fixture_file_upload("#{RAILS_ROOT}/spec/factories/pixel.png", "image/png") }
#  giveaway.start_date now
#  giveaway.end_date later
#  giveaway.terms { "#{Faker::Internet.domain_name}/terms" }
#  giveaway.facebook_page { (FacebookPage.count > 0 ? FacebookPage.all.sort_by{ rand }.first : Factory.create(:facebook_page)) }
#end

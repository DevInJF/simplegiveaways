include ActionDispatch::TestProcess

FactoryGirl.define do

  factory :giveaway do

    facebook_page_id { FacebookPage.all.sample.id }

    title { Faker::Movie.title }

    description { Faker::HTMLIpsum.p(12) }

    prize { Faker::Product.product_name }

    custom_fb_tab_name { Faker::Name.name }

    image { fixture_file_upload "#{Rails.root}/spec/support/obama-dog.jpg", 'jpeg' }

    feed_image { fixture_file_upload "#{Rails.root}/spec/support/obama-dog.jpg", 'jpeg' }

    terms_url { Faker::Internet.http_url }

    terms_text { Faker::HipsterIpsum.paragraphs }

    autoshow_share_dialog { [1, 0][rand(2)] }

    allow_multi_entries { [1, 0][rand(2)] }

    email_required { [1, 0][rand(2)] }

    bonus_value { generate(:integer) }

    trait :scheduled do

      start_date { generate(:datetime) }

      end_date { generate(:datetime) }
    end
  end
end

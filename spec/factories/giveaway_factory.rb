include ActionDispatch::TestProcess

FactoryGirl.define do

  factory :giveaway do

    facebook_page_id { FacebookPage.all.sample.id }

    title { generate(:title) }

    description { generate(:description) }

    prize { generate(:content) }

    custom_fb_tab_name { generate(:title) }

    image { fixture_file_upload "#{Rails.root}/spec/support/obama-dog.jpg", 'jpeg' }

    feed_image { fixture_file_upload "#{Rails.root}/spec/support/obama-dog.jpg", 'jpeg' }

    terms_url { generate(:url) }

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

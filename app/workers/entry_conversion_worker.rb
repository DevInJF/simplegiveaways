class EntryConversionWorker
  include Sidekiq::Worker

  def perform(has_liked, referrer_id, giveaway_cookie)

    if has_liked
      puts giveaway_cookie.inspect.red
      giveaway_cookie["ref_ids"].push(referrer_id.to_i) if referrer_id != "[]"
      giveaway_cookie["ref_ids"].uniq.each do |ref|
        if @ref = Entry.find_by_id_and_giveaway_id(ref, giveaway_cookie["giveaway_id"])
          @ref.convert_count += 1
          @ref.save
        end
      end
    end
  end
end
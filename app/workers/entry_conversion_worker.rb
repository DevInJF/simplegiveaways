class EntryConversionWorker
  include Sidekiq::Worker

  def perform(has_liked, ref_ids, giveaway_cookie)

    if has_liked
      puts giveaway_cookie.inspect.red
      ref_ids.uniq.each do |ref|
        puts ref.inspect.green_on_white
        if @ref = Entry.find_by_id_and_giveaway_id(ref, giveaway_cookie['giveaway_id'])
          @ref.convert_count += 1
          @ref.save
        end
      end
    end
  end
end
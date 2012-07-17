class EntryConversionWorker
  include Sidekiq::Worker

  def perform(has_liked, referer_id)
    if has_liked && referer_id != "[]"
      @ref = Entry.find_by_id(referer_id)
      @ref.convert_count += 1
      @ref.save
    end
  end
end
module FacebookPagesHelper

  def like_count_label(page)
    "#{page.likes.to_i} Likes"
  end
end

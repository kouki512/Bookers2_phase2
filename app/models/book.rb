class Book < ApplicationRecord 
	belongs_to :user
	validates :title, presence: true
	validates :body ,presence: true, length: {maximum: 200}

  has_many :favorites
  has_many :book_comments

  def favorited_by?(user)
    Favorite.where(user_id: user.id, book_id: self.id).exists?
  end

  def self.search(search, word)
    if search == "perfect_match"
     where("title LIKE?","#{word}")
    elsif search == "forward_match"
      where("title LIKE?","#{word}%")
    elsif search == "behind_match"
      where("title LIKE?","%#{word}")
    elsif search == "partial_match"
      where("title LIKE?","%#{word}%")
    else
      all
    end
  end

end

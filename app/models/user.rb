class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  attachment :profile_image, destroy: false
  has_many :books
  has_many :favorites
  has_many :book_comments
  validates :name, presence: true, length: {maximum: 10, minimum: 2}
  validates :introduction, length: {maximum: 50}
  
  
  # フォローしている人
  has_many :follower,class_name: "Relationship", foreign_key: "follower_id",dependent: :destroy
  has_many :followings, through: :follower, source: :followed
  
  # フォロワー
  has_many :followed,class_name: "Relationship", foreign_key: "followed_id",dependent: :destroy
  has_many :followers, through: :followed, source: :follower
  
  def following?(another_user)
    self.followings.include?(another_user)
  end

  def follow(another_user)
    unless self == another_user
      #binding.pry
      #self.follower.find_or_create_by(followed_id: another_user.id)
      follower.create(followed_id: another_user.id)
    end
  end
  
  def unfollow(another_user)
    unless self == another_user
      relationship = self.follower.find_by(followed_id: another_user.id)
      relationship.destroy if relationship
    end
  end

  def self.search(search, word)
    if search == "perfect_match"
      where("name LIKE?","#{word}")
    elsif search == "forward_match"
      where("name LIKE?","#{word}%")
    elsif search == "behind_match"
      where("name LIKE?","%#{word}")
    elsif search == "partial_match"
      where("name LIKE?","%#{word}%")
    else
      all
    end
  end
end 
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
          has_one_attached :profile_image
          has_many :books, dependent: :destroy
          has_many :favorites, dependent: :destroy
          has_many :post_comments, dependent: :destroy
          has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
          has_many :passive_relationships,class_name: "Relationship",foreign_key: "followed_id",dependent: :destroy

          has_many :followings, through: :active_relationships, source: :followed
          has_many :followers, through: :passive_relationships, source: :follower

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: { case_sensitive: false}
  validates :introduction, length: { maximum: 50 }



def get_profile_image(width, height)
  unless profile_image.attached?
    file_path = Rails.root.join('app/assets/images/no_image.jpg')
    profile_image.attach(io: File.open(file_path), filename: 'no_image.jpg', content_type: 'image/jpg')
  end
  profile_image.variant(resize_to_limit: [width, height]).processed
end

    # フォローする
  def follow(user_id)
    active_relationships.create(followed_id: user_id)
  end

  # フォローを外す
  def unfollow(user_id)
    active_relationships.find_by(followed_id: user_id).destroy
  end

  # すでにフォローしているのか確認
  def following?(user)
    followings.include?(user)
  end

  def self.looks(search, word)
    if search == "perfect_match"
      @user = User.where("name LIKE?", "#{word}")
    elsif search == "forward_match"
      @user = User.where("name LIKE?","#{word}%")
    elsif search == "backward_match"
      @user = User.where("name LIKE?","%#{word}")
    elsif search == "partial_match"
      @user = User.where("name LIKE?","%#{word}%")
    else
      @user = User.all
    end
  end
end

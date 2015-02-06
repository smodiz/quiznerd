class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  has_many :quizzes, :foreign_key =>"author_id", dependent: :nullify
  has_many :quiz_events, dependent: :destroy
  has_many :cheatsheets, dependent: :destroy
  has_many :decks, dependent: :destroy

end

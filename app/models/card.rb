require 'digest/bubblebabble'

class Card < ApplicationRecord
  before_create :generate_token
  has_one_attached :headshot

  validate :headshot_validation

  def to_param
    key
  end

  def cropped
    headshot.variant(resize: "216x270^", gravity: 'center', crop: '216x270+0+0')
  end

  def text_lines
    [ name ] * 3
  end

  private

  def headshot_validation
    if headshot.attached?
      unless headshot.image?
        errors.add(:base, "attachment is not an image")
      end
    end
  end

  def generate_token
    self.key = SecureRandom.urlsafe_base64(16)
  end
end

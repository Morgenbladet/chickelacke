require 'digest/bubblebabble'

class Image < ApplicationRecord
  before_create :generate_token
  has_one_attached :headshot

  validate :headshot_validation

  def to_param
    key
  end

  def cropped_headshot
    headshot.variant(resize: "80x47").processed
  end

  def headshot_dataurl
    "data:%s;base64,%s" % [headshot.content_type, Base64.encode64(cropped_headshot.blob.download) ]
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

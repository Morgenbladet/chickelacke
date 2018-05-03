require 'digest/bubblebabble'

class Image < ApplicationRecord
  before_create :generate_token

  def to_param
    key
  end

  private

  def generate_token
    self.key = SecureRandom.urlsafe_base64(16)
  end
end

require 'digest/bubblebabble'
require 'yaml'

class Card < ApplicationRecord
  before_create :generate_token
  before_create :generate_fields
  has_one_attached :headshot

  GENERATOR_DATA = YAML.load_file(Rails.root.join('lib', 'generator.yml'))

  validate :headshot_validation

  validates :color, format: {
    with: /\A#[0-9A-Fa-f]{6}\Z/,
    message: 'must be a hex color, six digits, with #'
  }

  def to_param
    key
  end

  def cropped
    headshot.variant(resize: "216x270^", gravity: 'center', crop: '216x270+0+0')
  end

  def text_lines
    [ "<b>#{name}</b>", "Adr.: #{address}", "Tlf: #{phone}", slogan, "Medlem av: #{member_of}" ]
  end

  def sane_color
    if color.blank?
      "#e63332"
    else
      color
    end
  end

  protected

  def generate(key)
    replace_tokens("{#{key}}")
  end

  private

  def replace_tokens(string)
    logger.info string
    token_re = /{.*?}/
    string.gsub(token_re) do |tok|
      tok = tok.slice(1..-2)
      logger.info "token #{tok}"
      chosen = GENERATOR_DATA[tok].sample
      replace_tokens(chosen)
    end
  end

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

  def generate_fields
    self.phone = generate("phone") if self.phone.blank?
    self.member_of = generate("member_of") if self.member_of.blank?
    self.slogan = generate("joke") if self.slogan.blank?
    self.address = generate("address") if self.address.blank?
  end
end

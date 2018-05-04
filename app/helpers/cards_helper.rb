module CardsHelper
  def split_into_lines(string)
    max_length=35
    return if string.nil?
    results = []
    remaining = string
    loop do
      if remaining.length <= max_length
        results << remaining
        break
      end
      # Find last space or hyphen before max_length
      pos = remaining[0,max_length].rindex(/[ -,.]/) || (max_length - 1)
      results << remaining[0, pos + 1].strip
      remaining = remaining[(pos + 1)..-1]
      break if remaining.blank?
    end
    results
  end
end

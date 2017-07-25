class UserWithDeviceTokensAttribute
  attr_reader :device_tokens

  def initialize(email)
    @email = email
    @device_tokens = {}
  end

  def has_attribute?(_attr)
    true
  end

  def device_tokens_changed?
    false
  end

  def save
    true
  end
end

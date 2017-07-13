class UserWithDeviceTokensAttribute
  def initialize(email)
    @email = email
  end

  def has_attribute?(_attr)
    true
  end
end

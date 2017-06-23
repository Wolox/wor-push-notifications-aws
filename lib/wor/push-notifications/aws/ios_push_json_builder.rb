class IosPushJsonBuilder
  class << self
    def build_json(message_content)
      unless Rails.application.secrets.sns_app_arn['ios']['sandbox']
        return { APNS: { aps: { alert: message_content[:message], badge: 1, sound: 'default' } }
               .merge(message_content).to_json }
      end
      { APNS_SANDBOX: { aps: { alert: message_content[:message], badge: 1, sound: 'default' } }
        .merge(message_content).to_json }
    end
  end
end

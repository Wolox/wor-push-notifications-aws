class IosPushJsonBuilder
  class << self
    def build_json(message_content)
      unless Wor::Push::Notifications::Aws.aws_ios_sandbox
        return { APNS: { aps: { alert: message_content[:message], badge: 1, sound: 'default' } }
               .merge(message_content).to_json }
      end
      { APNS_SANDBOX: { aps: { alert: message_content[:message], badge: 1, sound: 'default' } }
        .merge(message_content).to_json }
    end
  end
end

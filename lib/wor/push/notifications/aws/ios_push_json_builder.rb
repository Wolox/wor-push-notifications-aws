module Wor
  module Push
    module Notifications
      module Aws
        class IosPushJsonBuilder
          class << self
            def build_json(message_content)
              unless Wor::Push::Notifications::Aws.aws_ios_sandbox
                return { APNS: aps_content(message_content) }
              end
              { APNS_SANDBOX: aps_content(message_content) }
            end

            private

            def aps_content(message_content)
              { aps: { alert: message_content[:message], badge: message_content[:badge],
                       sound: 'default' } }.merge(message_content).to_json
            end
          end
        end
      end
    end
  end
end

module Wor
  module Push
    module Notifications
      module Aws
        class AndroidPushJsonBuilder
          class << self
            def build_json(message_content)
              { GCM: { data: message_content }.to_json }
            end
          end
        end
      end
    end
  end
end

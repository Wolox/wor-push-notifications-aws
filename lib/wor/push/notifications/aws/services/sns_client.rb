require 'aws-sdk-rails'

module Wor
  module Push
    module Notifications
      module Aws
        class SnsClient
          def initialize(region)
            Aws::SNS::Client.new(region: region)
          end
        end
      end
    end
  end
end

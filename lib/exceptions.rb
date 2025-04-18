module Exceptions
  class MissingUserAuthenticationError < StandardError
    def initialize(user_id)
      super("UserAuthentication is missing for user: #{user_id}")
    end
  end
end

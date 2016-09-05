module Bouncer
  class NotAuthorizedError < StandardError
    attr_reader :path

    def initialize(options={})
      if options.is_a?(String)
        message = options
      else
        @path = options[:path]
        message = options.fetch(:message) { "not allowed to access this path : #{path}" }
      end
      super(message)
    end
  end
end

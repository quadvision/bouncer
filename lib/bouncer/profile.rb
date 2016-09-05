module Bouncer
  class Profile
    attr_accessor :key

    def initialize(key)
      @key = key
    end

    def name
      I18n.t("quadvision.authorization.profiles.#{self.key}")
    end

    def to_s
      self.name
    end

    class << self
      if Bouncer.profiles_keys.present?
        Bouncer.profiles_keys.each do |profile_key|
          define_method(profile_key) do
            new(profile_key)
          end
        end
      end
    end

  end
end


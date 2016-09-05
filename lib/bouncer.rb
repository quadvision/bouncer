require "bouncer/version"

require "active_support/concern"
require "active_support/core_ext/string/inflections"
require "active_support/core_ext/object/blank"
require "active_support/core_ext/module/introspection"
require "active_support/dependencies/autoload"

require 'bouncer/errors'
require 'bouncer/access_helper'

module Bouncer
  extend ActiveSupport::Concern

  class << self
    attr_accessor :config, :profiles_keys, :unauthorized_redirection_url

    def config
      custom_file_path = "#{Dir.pwd}/config/bouncer.yml"
      if @config.nil?
        @config ||= if File.exists?(custom_file_path)
                      YAML.load_file(custom_file_path)
                    else
                      {
                        'authorizations' => {
                          'authorized_profiles' => ['connected']
                        }
                      }
                    end
      end
      @config
    end

    def profiles_keys
      self.config['authorization_profiles']
    end

  end

  included do
    if respond_to?(:helper)
      include Bouncer::AccessHelper
      before_filter :check_access

      if respond_to?(:helper_method)
        helper_method :can_access?
        helper_method :authorization_profiles_list
      end
    end
  end
end

require 'bouncer/profile'

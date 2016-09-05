module Bouncer::AccessHelper
  def can_access?(controller_path)
    current_config = Bouncer.config['authorizations']
    return true unless current_config.present? && authorized_path?(current_config)

    current_nodes = []
    controller_path.split('/').each do |next_node|
      current_config = current_config[next_node]
      current_nodes << next_node
      break unless current_config && current_config.is_a?(Hash)
      return false unless authorized_path?(current_config, current_nodes.join('/'))
    end
    return true
  end

  def authorized_path?(local_config, path='')
    if local_config['authorized_profiles'].present?
      if local_config['authorized_profiles'].include?('connected')
        current_user.present?
      else
        local_config['authorized_profiles'].include?(current_user.authorization_profile_key.to_s)
      end
    else
      true
    end
  end

  def authorization_profiles_list
    Bouncer.profiles_keys.collect{ |profile_key| [Bouncer::Profile.send(profile_key.to_sym), profile_key] }
  end

  def check_access
    unless can_access?(self.controller_path)
      raise Bouncer::NotAuthorizedError, path: self.controller_path
    end
  end
end

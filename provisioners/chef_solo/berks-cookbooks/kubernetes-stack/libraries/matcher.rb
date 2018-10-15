if defined?(ChefSpec)
  def install_kubectl(message)
    ChefSpec::Matchers::ResourceMatcher.new(:kubectl, :install, message)
  end

  def install_helm(message)
    ChefSpec::Matchers::ResourceMatcher.new(:helm, :install, message)
  end

  def install_gcloud(message)
    ChefSpec::Matchers::ResourceMatcher.new(:gcloud, :install, message)
  end

  def install_kubernetes(message)
    ChefSpec::Matchers::ResourceMatcher.new(:kubernetes, :install, message)
  end
end

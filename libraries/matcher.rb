if defined?(ChefSpec)
  def add_apt_repo(repo)
    ChefSpec::Matchers::ResourceMatcher.new(:apt_repo, :add, repo)
  end
end

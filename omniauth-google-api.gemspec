# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "omniauth-google-api"
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Bob Aman"]
  s.date = "2012-02-10"
  s.description = "An OmniAuth strategy for Google.\n"
  s.email = "bob@sporkmonger.com"
  s.extra_rdoc_files = ["README.md"]
  s.files = ["lib/omniauth", "lib/omniauth/google", "lib/omniauth/google/version.rb", "lib/omniauth/google.rb", "lib/omniauth/strategies", "lib/omniauth/strategies/google.rb", "lib/omniauth-google.rb", "spec/spec.opts", "spec/spec_helper.rb", "tasks/clobber.rake", "tasks/gem.rake", "tasks/git.rake", "tasks/metrics.rake", "tasks/rdoc.rake", "tasks/spec.rake", "tasks/yard.rake", "CHANGELOG.md", "LICENSE", "Rakefile", "README.md"]
  s.homepage = "http://code.google.com/p/omniauth-google/"
  s.rdoc_options = ["--main", "README.md"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.15"
  s.summary = "An OmniAuth strategy for Google."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<google-api-client>, ["~> 0.4.0"])
      s.add_runtime_dependency(%q<signet>, [">= 0.3.2"])
      s.add_development_dependency(%q<rake>, ["~> 0.8.3"])
      s.add_development_dependency(%q<rspec>, ["~> 1.1.11"])
      s.add_development_dependency(%q<launchy>, ["~> 0.3.2"])
      s.add_development_dependency(%q<diff-lcs>, ["~> 1.1.2"])
    else
      s.add_dependency(%q<google-api-client>, ["~> 0.4.0"])
      s.add_dependency(%q<signet>, [">= 0.3.2"])
      s.add_dependency(%q<rake>, ["~> 0.8.3"])
      s.add_dependency(%q<rspec>, ["~> 1.1.11"])
      s.add_dependency(%q<launchy>, ["~> 0.3.2"])
      s.add_dependency(%q<diff-lcs>, ["~> 1.1.2"])
    end
  else
    s.add_dependency(%q<google-api-client>, ["~> 0.4.0"])
    s.add_dependency(%q<signet>, [">= 0.3.2"])
    s.add_dependency(%q<rake>, ["~> 0.8.3"])
    s.add_dependency(%q<rspec>, ["~> 1.1.11"])
    s.add_dependency(%q<launchy>, ["~> 0.3.2"])
    s.add_dependency(%q<diff-lcs>, ["~> 1.1.2"])
  end
end

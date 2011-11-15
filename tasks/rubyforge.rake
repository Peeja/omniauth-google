namespace :gem do
  desc 'Package and tag repo.'
  task :release => ['gem:package'] do |t|
    v = ENV['VERSION'] or abort 'Must supply VERSION=x.y.z'
    abort "Versions don't match #{v} vs #{PROJ.version}" if v != PKG_VERSION
  end
end

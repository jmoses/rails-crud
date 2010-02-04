require 'rubygems'
require 'rake'
require 'rake/gempackagetask'

PKG_FILES = FileList[
  '[a-zA-Z]*',
  'lib/**/*',
  'app/**/*',
  'rails/**/*'
]

spec = Gem::Specification.new do |s|
  s.name = 'rails-crud'
  s.version = '0.0.1'
  s.author = 'Jon Moses'
  s.email = 'jon@burningbush.us'
  s.homepage = 'http://github.com/jmoses/rails-crud'
  s.platform = Gem::Platform::RUBY
  s.summary = 'Making CRUD based controllers easier'
  s.files = PKG_FILES.to_a
  s.require_path = 'lib'
  s.has_rdoc = false
  s.extra_rdoc_files = ["README"]
end

desc 'Build it'
Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end
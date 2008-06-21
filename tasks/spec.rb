require 'spec/rake/spectask'

desc "Run all specifications"
Spec::Rake::SpecTask.new(:spec) do |t|
  t.libs += [File.expand_path('lib'), File.expand_path('spec')]
  t.spec_opts = ['--colour', '--format', 'specdoc']
end

require 'rake'
require 'rake-version'
require 'rspec/core/rake_task'
require 'puppetlabs_spec_helper/rake_tasks'

task :spec    => [:spec_fixtures]
task :default => [:spec]

RakeVersion::Tasks.new do |v|
  v.copy 'Modulefile'
  v.copy 'metadata.json'
end

desc 'Create the .fixtures.yml file'
task :spec_fixtures do
  require 'json'
  metadata = JSON.parse(File.read('metadata.json'))
  File.open('.fixtures.yml', 'w') do |fix|
    fix.puts "fixtures:"
    fix.puts "  symlinks:"
    fix.puts "    #{(metadata['name'].split(/[\/\-]/))[-1]}: \"\#{source_dir}\""
    if metadata.key? 'dependencies'
      fix.puts "  forge_modules:"
      metadata['dependencies'].each do |dep|
        if dep.key? 'version_requirement'
          fix.puts "    #{(dep['name'].split(/[\/\-]/))[-1]}:"
          fix.puts "      repo: \"#{dep['name']}\""
         fix.puts "      ref: \"#{dep['version_requirement'].gsub(/[=\<\>~\s]/, '')}\""
        else
          fix.puts "    #{(dep['name'].split(/\/\-/))[1]}: \"#{dep['name']}\""
        end
      end
    end
  end
end

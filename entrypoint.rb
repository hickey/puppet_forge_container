#!/usr/bin/ENV ruby


config = ["--log-dir=/puppet/logs"]

# if the first arg starts with a dash, then user provided args
unless ARGV[0] and ARGV[0].start_with? '-'
  # PUPPET_FORGE_PROXY="URL"
  if ENV.key? "PUPPET_FORGE_PROXY"
    config << "--proxy=#{ENV['PUPPET_FORGE_PROXY']}"
  end

  # PUPPET_FORGE_CACHE_TTL="SECS"
  if ENV.key? "PUPPET_FORGE_CACHE_TTL"
    config << "--ram-cache-ttl=#{ENV['PUPPET_FORGE_CACHE_TTL']}"
  end

  # PUPPET_FORGE_CACHE_SIZE="NUM"
  if ENV.key? "PUPPET_FORGE_CACHE_SIZE"
    config << "--ram-cache-size=#{ENV['PUPPET_FORGE_CACHE_SIZE']}"
  end

  # PUPPET_FORGE_MODULE_DIR="DIR[:DIR]"
  if ENV.key? "PUPPET_FORGE_MODULE_DIR"
    if ENV["PUPPET_FORGE_MODULE_DIR"].include? ':'
      ENV["PUPPET_FORGE_MODULE_DIR"].split(":").each do |dir| 
        config << "--module-dir=#{dir}"
      end
    else
      config << "--proxy=#{ENV["PUPPET_FORGE_MODULE_DIR"]}"
    end
  else 
    config << "--module-dir=/puppet/modules"
  end
else
  # append user provided args to the current config
  config << ARGV
  ARGV.clear
  config.flatten!
end

case ARGV[0]
when /README|HELP|INFO/i
  exec "more README.md"
when /VERSION/i
  require_relative "lib/puppet_forge_server/version"
  puts PuppetForgeServer::VERSION
when nil
  exec "ruby bin/puppet-forge-server #{config.join(' ')}"
else
  exec ARGV.join(' ')
end



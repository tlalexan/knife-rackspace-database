require 'chef/knife'
require 'chef/knife/rackspace_base'

module KnifePlugins
  class RackspaceDnsZoneCreate < Chef::Knife

    include Chef::Knife::RackspaceBase
    include Chef::Knife::RackspaceDnsBase

    option :ttl,
           :short => "-l",
           :long => "--ttl SECONDS",
           :description => "TTL in seconds (default 300)",
           :default => "300"

    banner "knife rackspace dns zone create ZONE_NAME EMAIL"

    def run
      $stdout.sync = true

      @zone_name = @name_args[0] 
      @zone_email = @name_args[1] 
      
      if @zone_name.nil? || @zone_email.nil?
        show_usage
        ui.fatal("You must specify a zone name and email")
        exit 1
      end

      zone = dns_service.zones.new({:domain => @zone_name, :email => @zone_email, :ttl => config[:ttl]})
      zone.save

      # There's a bug in fog where it doesn't set this on create
      zone.ttl = config[:ttl]
      zone.save
      zone.reload

      msg_pair("Domain", zone.domain)      
      msg_pair("Administrator Email", zone.email)      
      msg_pair("TTL", zone.ttl)      
    end

  end
end
    
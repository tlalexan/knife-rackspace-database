require 'chef/knife'
require 'chef/knife/rackspace_base'

module KnifePlugins
  class RackspaceDnsZoneCreate < Chef::Knife

    include Chef::Knife::RackspaceBase
    include Chef::Knife::RackspaceDnsBase

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

      zone = dns_service.zones.new({:domain=> @zone_name, :email=> @zone_email})
      zone.save

      msg_pair("Domain", zone.domain)      
      msg_pair("Administrator Email", zone.email)      
    end

  end
end
    
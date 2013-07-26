require 'chef/knife'
require 'chef/knife/rackspace_base'

module KnifePlugins
  class RackspaceDnsZoneDelete < Chef::Knife

    include Chef::Knife::RackspaceBase
    include Chef::Knife::RackspaceDnsBase

    banner "knife rackspace dns zone delete ZONE_NAME"

    def run
      $stdout.sync = true

      @zone_name = @name_args[0] 
      
      if @zone_name.nil? 
        show_usage
        ui.fatal("You must specify a zone name")
        exit 1
      end

      zone = load_zone @zone_name

      if zone.nil?
        ui.error("Zone #{@zone_name} not found")
        exit 1
      end

      msg_pair("Domain", zone.domain)      
      msg_pair("Administrator Email", zone.email)      

      ui.confirm("Do you really want to delete this zone")

      zone.destroy
    end

  end
end
    
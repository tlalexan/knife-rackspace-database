require 'chef/knife'
require 'chef/knife/rackspace_base'
require 'chef/knife/rackspace_dns_base'

module KnifePlugins
  class RackspaceDnsRecordDelete < Chef::Knife

    include Chef::Knife::RackspaceBase
    include Chef::Knife::RackspaceDnsBase

    banner "knife rackspace dns record delete FQDN"

    def run
      $stdout.sync = true

      @fqdn = @name_args[0] 
 
      if @fqdn.nil? 
        show_usage
        ui.fatal("You must specify an fqdn")
        exit 1
      end

      zone = zone_for @fqdn

      records_to_delete = zone.records.select {|rec| rec.name == @fqdn}

      ui.info "No DNS records to delete." if records_to_delete.length == 0
      records_to_delete.each do |record|
        ui.info("Deleting dns record for ...")
        msg_pair("ID", record.id)
        msg_pair("Name", record.name)
        msg_pair("Value", record.value)
        msg_pair("Type", record.type)
        msg_pair("TTL", record.ttl) 
        zone.records.destroy record.id
      end
    end
  end
end
    
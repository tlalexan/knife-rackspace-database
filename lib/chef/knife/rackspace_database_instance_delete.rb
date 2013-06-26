require 'chef/knife'
require 'chef/knife/rackspace_base'
require 'chef/knife/rackspace_database_base'

module KnifePlugins
  class RackspaceDatabaseInstanceDelete < Chef::Knife

    include Chef::Knife::RackspaceBase
    include Chef::Knife::RackspaceDatabaseBase

    banner "knife rackspace database instance delete ID [ID] (options)"

    option :force,
           :long => "--force",
           :description => "Skip user prompts"

    def run
      $stdout.sync = true

      @name_args.each do |instance_id|
        instance = db_connection.instances.get(instance_id)

        if instance.nil?
          ui.error("Instance not found")
          exit 1
        end

        msg_pair("Instance ID", instance.id)
        msg_pair("Name", instance.name)
        msg_pair("Hostname", instance.hostname)
        msg_pair("Flavor", instance.flavor.name)
        msg_pair("Volume Size", instance.volume_size)

        unless config[:force]
          ui.confirm("Do you really want to delete this database instance")
        end

        instance.destroy

        ui.warn("Deleted load balancer #{instance.id}")
      end

    end

  end
end

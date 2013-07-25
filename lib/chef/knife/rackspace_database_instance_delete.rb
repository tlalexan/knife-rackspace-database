require 'chef/knife'
require 'chef/knife/rackspace_base'
require 'chef/knife/rackspace_database_base'

module KnifePlugins
  class RackspaceDatabaseInstanceDelete < Chef::Knife

    include Chef::Knife::RackspaceBase
    include Chef::Knife::RackspaceDatabaseBase

    option :force,
           :short => "-f",
           :long => "--force",
           :boolean => true,
           :description => "Skip user prompts"

    banner "knife rackspace database instance delete INSTANCE_NAME [INSTANCE_NAME...]"

    def run
      $stdout.sync = true

      instances = []
      @name_args.each do |instance_name| 
        found_instances = db_connection.instances.find_all { |i| i.name == instance_name }
        if found_instances.empty? 
            ui.error("Instance #{instance_name} not found")
            exit 1
        end
        instances.concat found_instances
      end

      if instances.empty?
          show_usage 
          ui.error("INSTANCE required")
          exit 1
      end

      unless config[:force]
        if instances.count > 1
          msg_pair("Instances", instances.map {|u| u.name }.join(", "))
          ui.confirm("Do you really want to delete these instances")
        else
          msg_pair("Instance", instances.first.name)
          ui.confirm("Do you really want to delete this instance")
        end
      end

      instances.each do |instance|
        instance.destroy
        ui.warn("Deleted instance #{instance.name}")
      end
    end
  end
end


require 'chef/knife'
require 'chef/knife/rackspace_base'
require 'chef/knife/rackspace_database_base'

module KnifePlugins
  class RackspaceDatabaseInstanceList < Chef::Knife

    include Chef::Knife::RackspaceBase
    include Chef::Knife::RackspaceDatabaseBase

    banner "knife rackspace database instance list"

    def run
      $stdout.sync = true

      instance_list = [
          ui.color('Instance ID', :bold),
          ui.color('Name', :bold),
          ui.color('Hostname', :bold),
          ui.color('Flavor', :bold),
          ui.color('State', :bold)
      ]

      db_connection.instances.all.each do |instance|
        instance.reload
        instance_list << instance.id.to_s
        instance_list << instance.name
        instance_list << instance.hostname
        instance_list << (instance.flavor_id == nil ? "" : instance.flavor_id.to_s)
        instance_list << begin
          case instance.state.downcase
            when 'deleted', 'suspended'
              ui.color(instance.state.downcase, :red)
            when 'build', 'unknown'
              ui.color(instance.state.downcase, :yellow)
            else
              ui.color(instance.state.downcase, :green)
          end
        end
      end
      puts ui.list(instance_list, :uneven_columns_across, 5)
    end
  end
end

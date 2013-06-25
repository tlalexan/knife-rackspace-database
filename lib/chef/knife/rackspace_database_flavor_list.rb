require 'chef/knife'
require 'chef/knife/rackspace_base'
require 'chef/knife/rackspace_database_base'

module KnifePlugins
  class RackspaceDatabaseFlavorList < Chef::Knife

    include Chef::Knife::RackspaceBase
    include Chef::Knife::RackspaceDatabaseBase

    banner "knife rackspace database flavor list"

    def run
      $stdout.sync = true

      flavor_list = [
          ui.color('ID', :bold),
          ui.color('Name', :bold),
          ui.color('RAM', :bold)
      ]

      db_connection.flavors.sort_by(&:id).each do |flavor|
        flavor_list << flavor.id.to_s
        flavor_list << flavor.name
        flavor_list << "#{flavor.ram.to_s}"
      end

      puts ui.list(flavor_list, :uneven_columns_across, 3)
    end
  end
end

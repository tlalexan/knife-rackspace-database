require 'chef/knife'
require 'chef/knife/rackspace_base'
require 'chef/knife/rackspace_database_base'
require 'chef/knife/rackspace_database_instance_related'

module KnifePlugins
  class RackspaceDatabaseUserList < Chef::Knife

    include Chef::Knife::RackspaceBase
    include Chef::Knife::RackspaceDatabaseBase
    include Chef::Knife::RackspaceDatabaseInstanceRelated

    banner "knife rackspace database user list INSTANCE_NAME"

    def run
      $stdout.sync = true

      pop_instance_arg

      user_list = [
          ui.color('Name', :bold),
          ui.color('Databases', :bold)
      ]

      @instance.users.each do |user|
        user_list << user.name
        user_list << user.databases.map { |db| db["name"]}.join(", ")
      end

      puts ui.list(user_list, :uneven_columns_across, 2)
    end

  end
end

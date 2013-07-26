require 'chef/knife'
require 'chef/knife/rackspace_base'
require 'chef/knife/rackspace_database_instance_related'

module KnifePlugins
  class RackspaceDatabaseUserDelete < Chef::Knife

    include Chef::Knife::RackspaceBase
    include Chef::Knife::RackspaceDatabaseBase
    include Chef::Knife::RackspaceDatabaseInstanceRelated

    banner "knife rackspace database user delete INSTANCE_NAME USER_NAME [USER_NAME ...]"

    def run
      $stdout.sync = true

      pop_instance_arg

      users = @name_args.map do |user_name| 
        user = @instance.users.find { |u| u.name == user_name }
        if user.nil? 
            ui.error("User #{user_name} not found")
            exit 1
        end
        user
      end

      if users.empty?
          show_usage 
          ui.error("USER_NAME required")
          exit 1
      end

      if users.count > 1
        msg_pair("User Names", users.map {|u| u.name }.join(", "))
        ui.confirm("Do you really want to delete these users")
      else
        msg_pair("User Name", users.first.name)
        ui.confirm("Do you really want to delete this user")
      end

      users.each do |user|
        user.destroy
        ui.warn("Deleted user #{user.name}")
      end
    end
  end
end

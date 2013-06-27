require 'chef/knife'
require 'chef/knife/rackspace_base'
require 'chef/knife/rackspace_database_instance_related'

module KnifePlugins
  class RackspaceDatabaseUserCreate < Chef::Knife

    include Chef::Knife::RackspaceBase
    include Chef::Knife::RackspaceDatabaseBase
    include Chef::Knife::RackspaceDatabaseInstanceRelated

    banner "knife rackspace database user create INSTANCE_NAME USER_NAME PASSWORD [DATABASE ...]"

    def run
      $stdout.sync = true

      pop_instance_arg
      user_name = pop_arg("USER_NAME")
      password = pop_arg("PASSWORD")
      
      user = @instance.users.new(:name => user_name,
                                :password => password,
                                :databases => [])

      @name_args.each do |database_name|
        db = @instance.databases.find {|d| d.name == database_name}

        if db.nil?
          ui.error("database #{database_name} not found")
          exit(1)
        end
        user.databases.push(db)
      end

      user.save

      msg_pair("Name", user.name)
      msg_pair("Password", user.password)
      msg_pair("Databases", user.databases.map {|db| db.name }.join(', '))
    end

  end
end




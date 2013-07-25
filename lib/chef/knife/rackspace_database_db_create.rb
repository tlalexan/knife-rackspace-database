require 'chef/knife'
require 'chef/knife/rackspace_base'
require 'chef/knife/rackspace_database_instance_related'

module KnifePlugins
  class RackspaceDatabaseDbCreate < Chef::Knife

    include Chef::Knife::RackspaceBase
    include Chef::Knife::RackspaceDatabaseBase
    include Chef::Knife::RackspaceDatabaseInstanceRelated

    banner "knife rackspace database db create INSTANCE_NAME DB_NAME DOMAIN"

    def run
      $stdout.sync = true

      pop_instance_arg
      db_name = pop_arg("DB_NAME")

      db = @instance.databases.new(:name => db_name)
      db.save

      msg_pair("Name", db.name)
    end

  end
end

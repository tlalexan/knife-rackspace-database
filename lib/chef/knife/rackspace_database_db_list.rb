require 'chef/knife'
require 'chef/knife/rackspace_base'
require 'chef/knife/rackspace_database_base'

module KnifePlugins
  class RackspaceDatabaseDbList < Chef::Knife

    include Chef::Knife::RackspaceBase
    include Chef::Knife::RackspaceDatabaseBase

    banner "knife rackspace database db list -I [instance_name]"

    option :instance_name,
           :short => "-I NAME",
           :long => "--instance-name NAME",
           :description => "The instance to list databases for"

    def run
      $stdout.sync = true

      if config[:instance_name].nil?
        show_usage
        ui.error("You must specify an instance id")
        exit 1
      end

      instance = db_connection.instances.find { |i| i.name == config[:instance_name] }

      if instance.nil?
        ui.error("Instance not found")
        exit 1
      end

      db_list = [
          ui.color('Name', :bold)
      ]


      instance.databases.each do |database|
        db_list << database.name
      end
      puts ui.list(db_list, :uneven_columns_across, 1)
    end
  end
end

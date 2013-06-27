require 'chef/knife'
require 'chef/knife/rackspace_base'
require 'chef/knife/rackspace_database_instance_related'

module KnifePlugins
  class RackspaceDatabaseDbDelete < Chef::Knife

    include Chef::Knife::RackspaceBase
    include Chef::Knife::RackspaceDatabaseBase
    include Chef::Knife::RackspaceDatabaseInstanceRelated

    option :force,
           :short => "-f",
           :long => "--force",
           :boolean => true,
           :description => "Skip database prompts"

    banner "knife rackspace database db delete INSTANCE_NAME DATABASE_NAME [DATABASE_NAME ...]"

    def run
      $stdout.sync = true

      pop_instance_arg

      databases = @name_args.map do |database_name| 
        database = @instance.databases.find { |u| u.name == database_name }
        if database.nil? 
            ui.error("Database #{database_name} not found")
            exit 1
        end
        database
      end

      if databases.empty?
          show_usage 
          ui.error("DATABASE_NAME required")
          exit 1
      end

      unless config[:force]
        if databases.count > 1
          msg_pair("Database Names", databases.map {|u| u.name }.join(", "))
          ui.confirm("Do you really want to delete these databases")
        else
          msg_pair("Database Name", databases.first.name)
          ui.confirm("Do you really want to delete this database")
        end
      end

      databases.each do |database|
        database.destroy
        ui.warn("Deleted database #{database.name}")
      end
    end
  end
end

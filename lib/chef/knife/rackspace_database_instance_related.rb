require 'fog'

class Chef
  class Knife
    module RackspaceDatabaseInstanceRelated

      def pop_instance_arg 
        instance_name = pop_arg("INSTANCE_NAME")

        @instance = db_connection.instances.find { |i| i.name ==instance_name }

        if @instance.nil?
          show_usage
          ui.error("Instance #{instance_name} not found")
          exit 1
        end
      end  

      def pop_arg(name)
        if @name_args.empty?
          show_usage
          ui.error("#{name} required")
          exit 1
        end
        @name_args.delete_at(0)
      end

    end
  end
end

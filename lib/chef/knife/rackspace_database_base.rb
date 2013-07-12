require 'fog'

class Chef
  class Knife
    module RackspaceDatabaseBase

      def db_connection
        @connection ||= Fog::Rackspace::Databases.new(connection_params.except(:provider))
      end

    end
  end
end

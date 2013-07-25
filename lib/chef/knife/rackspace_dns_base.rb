require 'fog'

class Chef
  class Knife
    module RackspaceDnsBase

      def dns_service
          @dns_service ||= Fog::DNS::Rackspace.new(connection_params.except(:provider))
      end

    end
  end
end

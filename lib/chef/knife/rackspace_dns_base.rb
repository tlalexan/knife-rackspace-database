require 'fog'

class Chef
  class Knife
    module RackspaceDnsBase

      def dns_service
          @dns_service ||= Fog::DNS::Rackspace.new(connection_params.except(:provider))
      end

      def zone_for(fqdn)
        fqdn_match = fqdn.match(/^[^.]*\.(.*)$/i)
        if !fqdn_match
          ui.error("'#{fqdn}' is not a valid fqdn (e.g. test.example.com)")
          exit 1 
        end

        zone_name = fqdn_match.captures.first

        load_zone zone_name
      end

      def load_zone(zone_name)
        dns_service.zones.find {|z| z.domain == zone_name }  
      end

    end
  end
end

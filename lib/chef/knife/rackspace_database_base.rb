require 'fog'

class Chef
  class Knife
    module RackspaceDatabaseBase
      def self.included(base)
        base.class_eval do
          option :rackspace_api_region,
             :short => "-R REGION",
             :long => "--rackspace-api-region REGION",
             :description => "Your rackspace API region. IE: ord, dfw",
             :proc => Proc.new {|region| Chef::Config[:knife][:rackspace_api_region] = region}
        end
      end

      def db_connection
        @connection ||= Fog::Rackspace::Databases.new(db_connection_params)
      end

      def db_connection_params(options={})
        Chef::Log.debug("rackspace_api_key #{Chef::Config[:knife][:rackspace_api_key]}")
        Chef::Log.debug("rackspace_api_username #{Chef::Config[:knife][:rackspace_api_username]}")
        Chef::Log.debug("rackspace_auth_url #{Chef::Config[:knife][:rackspace_auth_url]} (config)")
        Chef::Log.debug("rackspace_auth_url #{config[:rackspace_auth_url]} (cli)")
        Chef::Log.debug("rackspace_api_region #{Chef::Config[:knife][:rackspace_api_region]} (config)")
        Chef::Log.debug("rackspace_api_region #{config[:rackspace_api_region]} (cli)")

        # reuse the knife rackspace connection params ( but we don't want provider here )
        connection_params(:rackspace_region => Chef::Config[:knife][:rackspace_api_region]).except(:provider)
      end
    end
  end
end

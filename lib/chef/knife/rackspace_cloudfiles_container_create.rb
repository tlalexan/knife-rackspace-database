require 'chef/knife'
require 'chef/knife/rackspace_base'
require 'chef/knife/rackspace_dns_base'
require 'chef/knife/rackspace_cloudfiles_base'
require 'fog'
require 'uri'

module KnifePlugins
  class RackspaceCloudfilesContainerCreate < Chef::Knife

    include Chef::Knife::RackspaceBase
    include Chef::Knife::RackspaceCloudfilesBase
    include Chef::Knife::RackspaceDnsBase

    banner "knife rackspace cloudfiles container create CONTAINER_NAME"


    option :fqdn,
            :long => "-add-fqdn FQDN",
            :short => "-D FQDN",
            :description => "Creates an 'CNAME' record in Cloud DNS"

    option :ttl,
           :short => "-l",
           :long => "--ttl SECONDS",
           :description => "DNS TTL in seconds (default 300)",
           :default => "300"
           
    def run

      if @name_args.first.nil?
        show_usage
        ui.error("CONTAINER_NAME is required")
        exit 1 
      end

      create_options = {:key => @name_args.first, :public => true}

      container = cloud_files_service.directories.create(create_options)
      uris = container.send(:urls)
      host = URI(uris[:uri]).host
      msg_pair("SSL URL", container.public_url)

      if (config[:fqdn])
        fqdn = config[:fqdn]
        
        zone = zone_for fqdn

        if !zone
          ui.error("Could not find Rackspace DNS zone for '#{zone_name}'")
          exit 1 
        end

        zone.records.create(:type => 'CNAME', :name => fqdn, :value => host, :ttl => config[:ttl])
        msg_pair("FQDN", fqdn)
        msg_pair("DNS TTL", config[:ttl])

      end
      
    end

  end
end

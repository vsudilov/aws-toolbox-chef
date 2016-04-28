#
# Cookbook Name:: aws-toolbox-chef
# Recipe:: default
#
# Copyright 2016, Vladimir Sudilovsky/Carbon Black
#
# All rights reserved - Do Not Redistribute
#

require 'aws-sdk'
require 'set'

ruby_block "update_dns" do
    block do
        hosted_zone = node['aws-toolbox']['host_zone_name']
        name = node['aws-toolbox']['name'].nil? ? node.hostname.sub(".local", "") : node.toolbox.name
        fqdn = "#{name}.#{hosted_zone}."

        c = Aws::Route53::Client.new(region: node['aws']['region'])
        zone_id = c.list_hosted_zones_by_name({dns_name: hosted_zone}).hosted_zones[0].id

        response = c.list_resource_record_sets({
            hosted_zone_id: zone_id, 
            start_record_name: fqdn, 
            start_record_type: "A", 
            max_items: 5,
        }).resource_record_sets

        # necessary since list_resource_record_set is actually a full match; start_*
        # just defines ordering
        current_records = response.select{ |record| record.name.start_with?(fqdn)}
        
        updates = Set.new [my_private_ip]
        if not current_records.empty?
            for record in current_records[0].resource_records
                if default['aws-toolbox']['prune_unreachables']
                    if is_reachable?(record.value)
                        updates.add(record.value)
                    end
                else
                    updates.add(record.value)
                end
            end
        end

        resource_records = []
        for update in updates
            resource_records.push({:value => update})
        end
        Chef::Log.info("Setting #{fqdn} A records to #{updates}")
        response = c.change_resource_record_sets({
            hosted_zone_id: zone_id,
            change_batch: {
                comment: 'aws-toolbox-update',
                changes: [
                    {
                        action: 'UPSERT',
                        resource_record_set: {
                            name: fqdn,
                            type: "A",
                            ttl: 30,
                            resource_records: resource_records
                        }
                    }
                ]
            }
        })
        Chef::Log.info("Change record set response status: #{response.change_info.status}")
    end
end
#
# Cookbook Name:: aws-toolbox-chef
# Recipe:: default
#
# Copyright 2016, Vladimir Sudilovsky/Carbon Black
#
# All rights reserved - Do Not Redistribute
#

require 'aws-sdk'


ruby_block "update_dns" do
	block do
		c = Aws::Route53::Client.new(region: node['aws']['region'])
		zone = c.list_hosted_zones_by_name({dns_name: node['toolbox']['host_zone_name']})[0].id
		my_private_ip
	end

end
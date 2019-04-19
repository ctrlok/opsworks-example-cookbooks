#
# Cookbook Name:: secrets_test
# Recipe:: store
#
# Copyright 2017 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License"). You
# may not use this file except in compliance with the License. A copy of
# the License is located at
#
#     http://aws.amazon.com/apache2.0/
#
# or in the "license" file accompanying this file. This file is
# distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF
# ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.
#
chef_gem 'aws-sdk'

ruby_block 'read_secrets' do
  block do
    require 'json'
    require 'aws-sdk'

    client = Aws::SecretsManager::Client.new(region: 'us-east-1')
    resp = client.get_secret_value({secret_id: node[:env]+'-SERVICE'})
    node.default['password'] = JSON.parse(resp.secret_string)
  end
  action :run
end

file '/tmp/passwords' do
  content lazy{"passwords: #{node['password']}"}
  mode '0700'
end

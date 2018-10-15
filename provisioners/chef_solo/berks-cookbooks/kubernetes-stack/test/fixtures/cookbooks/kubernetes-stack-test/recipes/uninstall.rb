#
# Cookbook:: kubernetes-stack-test
# Recipe:: uninstall
#
# Copyright:: 2017, The Authors, All Rights Reserved.

include_recipe 'kubernetes-stack-test::install'

kubectl 'uninstall kubectl' do
  action :remove
end

gcloud 'uninstall gcloud' do
  action :remove
end

helm 'uninstall helm' do
  action :remove
end

kubernetes 'uninstall kubernetes' do
  action :remove
end

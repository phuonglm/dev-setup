#
# Cookbook:: acme
# Recipe:: k8s
#
# Copyright:: 2017, The Authors, All Rights Reserved.

if node['kubernetes-stack']['kubernetes']['enabled']
    kubectl 'install kubectl' do
      version node['kubernetes-stack']['kubernetes']['version']
    end
end

if node['kubernetes-stack']['gcloud']['enabled']
    gcloud 'install gcloud' do
      version node['kubernetes-stack']['gcloud']['version']
    end

    # fix gsutil temporarily
    # see: https://github.com/teracyhq-incubator/kubernetes-stack-cookbook/issues/18
    link '/usr/local/bin/gsutil' do
      to '/usr/lib/google-cloud-sdk/bin/gsutil'
      only_if 'test -f /usr/lib/google-cloud-sdk/bin/gsutil'
    end
end

if node['kubernetes-stack']['helm']['enabled']
    helm 'install helm' do
      version node['kubernetes-stack']['helm']['version']
    end
end

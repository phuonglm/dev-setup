#
# Cookbook:: acme
# Recipe:: k8s
#
# Copyright:: 2017, The Authors, All Rights Reserved.

kubectl_opt = node['kubernetes-stack']['kubectl']
gcloud_opt = node['kubernetes-stack']['gcloud']
helm_opt = node['kubernetes-stack']['helm']

def sym_action(opt)
    opt['action'].nil? || opt['action'].strip().empty? ? :install : opt['action'].to_sym
end

if kubectl_opt['enabled']
    act = sym_action(gcloud_opt)
    kubectl "#{act} kubectl #{kubectl_opt['version']}" do
      version kubectl_opt['version']
      action act
    end
end

if gcloud_opt['enabled']
    act = sym_action(gcloud_opt)
    gcloud "#{act} gcloud #{gcloud_opt['version']}" do
      version gcloud_opt['version']
      action act
    end
end

if helm_opt['enabled']
    act = sym_action(helm_opt)
    helm "#{act} helm #{helm_opt['version']}" do
      version helm_opt['version']
      action act
    end
end
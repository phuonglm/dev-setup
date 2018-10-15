#
# Cookbook:: iorad
# Recipe:: k8s
#
# Copyright:: 2017, The Authors, All Rights Reserved.

kubectl_opt = node['kubernetes-stack']['kubectl']
gcloud_opt = node['kubernetes-stack']['gcloud']
helm_opt = node['kubernetes-stack']['helm']
kubernetes_opt = node['kubernetes-stack']['kubernetes']

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

    if act == :install # install socat here
        package 'socat'
    end
end

if kubernetes_opt['enabled']
    act = sym_action(kubernetes_opt)
    kubernetes "#{act} kubernetes #{kubernetes_opt['version']}" do
      version kubernetes_opt['version']
      action act
    end

    if act == :install
        execute 'install minikube ingress addon' do
            user 'root'
            command "sudo minikube addons enable ingress"
            only_if 'which minikube'
        end

        # this is required when you have different contexts, without context specification,
        # this could deploy helm chart accidentally on a wrong k8s cluster.
        # switch to minikube context
        execute "kubectl config use-context #{kubernetes_opt['context']}" do
            command "kubectl config use-context #{kubernetes_opt['context']} || true"
        end

        execute 'helm init' do
            user 'vagrant'
            environment ({'HOME' => '/home/vagrant', 'USER' => 'vagrant'})
            command "helm init --service-account default --wait"
            only_if 'which minikube'
        end
    end
end


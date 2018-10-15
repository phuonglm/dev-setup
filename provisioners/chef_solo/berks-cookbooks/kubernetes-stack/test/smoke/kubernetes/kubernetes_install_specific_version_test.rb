# # encoding: utf-8

# Inspec test for recipe kubernetes-stack::kubernetes

# The Inspec reference, with examples and extensive document

# kubeadm
describe command('kubeadm version --output=short') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match('v1.8.0') }
end

# kubelet
describe command("kubelet --version | cut -d ' ' -f2") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match('v1.8.0') }
end

# minikube
describe command("minikube version | cut -d ' ' -f3") do
  its(:exit_status) { should eq 0 }
end

# minikube env
describe command('echo $MINIKUBE_WANTUPDATENOTIFICATION') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match('false') }
end

describe command('echo $MINIKUBE_WANTREPORTERRORPROMPT') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match('false') }
end

describe command('echo $MINIKUBE_HOME') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match('/home/vagrant') }
end

describe command('echo $CHANGE_MINIKUBE_NONE_USER') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match('true') }
end

describe command('echo $KUBECONFIG') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match('/home/vagrant/.kube/config') }
end

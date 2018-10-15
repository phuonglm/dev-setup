# # encoding: utf-8

# Inspec test for recipe kubernetes-stack::kubernetes

# The Inspec reference, with examples and extensive document

describe command('curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt') do
  its(:exit_status) { should eq 0 }
  its('stdout') { should match /^\s*v[0-9]+.[0-9]+.[0-9]+?$/ }
end

describe command('which minikube') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match('/usr/local/bin/minikube') }
end

describe command("minikube version | cut -d ' ' -f3") do
  its(:exit_status) { should eq 0 }
end

describe command('minikube').exist? do
  it { should eq true }
end

describe command("kubectl version --short --client | cut -d ':' -f2") do
  its(:exit_status) { should eq 0 }
  its('stdout') { should match /^\s*v[0-9]+.[0-9]+.[0-9]+?$/ }
end

describe command('kubectl').exist? do
  it { should eq true }
end

describe command('which docker') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match('/usr/bin/docker') }
end

describe command('grep vagrant /etc/passwd') do
  its(:exit_status) { should eq 0 }
end

describe file('/home/vagrant/.kube/config') do
  it { should exist }
end

describe command('which kubeadm') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match('/usr/bin/kubeadm') }
end

describe command('which kubelet') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match('/usr/bin/kubelet') }
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

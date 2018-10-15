# # encoding: utf-8

# Inspec test for recipe kubernetes-stack::kubernetes

# The Inspec reference, with examples and extensive document

# kubeadm
describe command('which kubeadm') do
  its(:exit_status) { should eq 1 }
end

# kubelet
describe command('which kubelet') do
  its(:exit_status) { should eq 1 }
end

# minikube
describe command('which minikube') do
  its(:exit_status) { should eq 1 }
end

# This recipe is used for running the `install_kubernetes_for_chefspec` tests, it should
# not be used in the other recipes.

kubernetes 'install latest kubernetes'

kubernetes 'install specific kubernetes version' do
  version 'v1.8.0'
end

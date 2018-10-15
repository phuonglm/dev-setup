#
# Cookbook:: iorad
# Recipe:: normalization
#

# temporary solution for https://github.com/teracyhq/dev/issues/388
# install bash-completion if not yet available
if platform?('ubuntu')
  bash 'check exist and install bash-completion' do
    code <<-EOH
      apt-get install bash-completion
      . /etc/bash_completion
      EOH
    not_if { ::File.exist?('/etc/bash_completion') && ::File.exist?('/usr/share/bash-completion/bash_completion') }
  end
end

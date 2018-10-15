resource_name :kubernetes

property :version, String, default: ''
property :binary_path, String, default: '/usr/local/bin'

default_action :install

load_current_value do
end

action :install do
  k8s_version = new_resource.version

  if version.empty?
    latest_version_url = 'curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt'
    version_cmd = Mixlib::ShellOut.new(latest_version_url)
    version_cmd.run_command
    version_cmd.error!
    k8s_version = version_cmd.stdout.strip
  end

  # get existing k8s-version through kubelet version
  existing_k8s_version_cmd = Mixlib::ShellOut.new("kubelet --version | cut -d ' ' -f2")
  existing_k8s_version_cmd.run_command

  if existing_k8s_version_cmd.stderr.empty? && !existing_k8s_version_cmd.stdout.empty?
    existing_k8s_version = existing_k8s_version_cmd.stdout.strip
  end

  if existing_k8s_version.to_s != k8s_version.to_s
    latest_minikube_version = latest_minikube_version()
    existing_minikube_version = existing_minikube_version()

    if existing_minikube_version != latest_minikube_version
      delete_existing_minikube_version(binary_path) unless existing_minikube_version.empty?

      bash 'install minikube' do
        code <<-EOH
          curl -Lo minikube https://storage.googleapis.com/minikube/releases/v0.25.2/minikube-linux-amd64
          chmod +x minikube
          mv minikube #{binary_path}
          EOH
        not_if 'which minikube'
      end
    end

    minikube_requirement()

    bash 'set env var' do
      user 'root'
      environment(
        'HOME' => '/home/vagrant',
        'USER' => 'vagrant'
      )
      code <<-EOH
        grep -q '^MINIKUBE_WANTUPDATENOTIFICATION' /etc/environment && sed -i 's/^MINIKUBE_WANTUPDATENOTIFICATION.*/MINIKUBE_WANTUPDATENOTIFICATION=false/' /etc/environment || echo 'MINIKUBE_WANTUPDATENOTIFICATION=false' >> /etc/environment
        grep -q '^MINIKUBE_WANTREPORTERRORPROMPT' /etc/environment && sed -i 's/^MINIKUBE_WANTREPORTERRORPROMPT.*/MINIKUBE_WANTREPORTERRORPROMPT=false/' /etc/environment || echo 'MINIKUBE_WANTREPORTERRORPROMPT=false' >> /etc/environment
        grep -q '^MINIKUBE_HOME' /etc/environment && sed -i 's/^MINIKUBE_HOME.*/MINIKUBE_HOME=/home/vagrant/' /etc/environment || echo 'MINIKUBE_HOME=/home/vagrant' >> /etc/environment
        grep -q '^CHANGE_MINIKUBE_NONE_USER' /etc/environment && sed -i 's/^CHANGE_MINIKUBE_NONE_USER.*/CHANGE_MINIKUBE_NONE_USER=true/' /etc/environment || echo 'CHANGE_MINIKUBE_NONE_USER=true' >> /etc/environment
        grep -q '^KUBECONFIG' /etc/environment && sed -i 's/^KUBECONFIG.*/KUBECONFIG=/home/vagrant/.kube/config/' /etc/environment || echo 'KUBECONFIG=/home/vagrant/.kube/config' >> /etc/environment

        grep -q '^MINIKUBE_WANTUPDATENOTIFICATION' /home/vagrant/.bash_profile && sed -i 's/^MINIKUBE_WANTUPDATENOTIFICATION.*/MINIKUBE_WANTUPDATENOTIFICATION=false/' /home/vagrant/.bash_profile || echo 'export MINIKUBE_WANTUPDATENOTIFICATION=false' >> /home/vagrant/.bash_profile
        grep -q '^MINIKUBE_WANTREPORTERRORPROMPT' /home/vagrant/.bash_profile && sed -i 's/^MINIKUBE_WANTREPORTERRORPROMPT.*/MINIKUBE_WANTREPORTERRORPROMPT=false/' /home/vagrant/.bash_profile || echo 'export MINIKUBE_WANTREPORTERRORPROMPT=false' >> /home/vagrant/.bash_profile
        grep -q '^MINIKUBE_HOME' /home/vagrant/.bash_profile && sed -i 's/^MINIKUBE_HOME.*/MINIKUBE_HOME=/home/vagrant/' /home/vagrant/.bash_profile || echo 'export MINIKUBE_HOME=/home/vagrant' >> /home/vagrant/.bash_profile
        grep -q '^CHANGE_MINIKUBE_NONE_USER' /home/vagrant/.bash_profile && sed -i 's/^CHANGE_MINIKUBE_NONE_USER.*/CHANGE_MINIKUBE_NONE_USER=true/' /home/vagrant/.bash_profile || echo 'export CHANGE_MINIKUBE_NONE_USER=true' >> /home/vagrant/.bash_profile
        grep -q '^KUBECONFIG' /home/vagrant/.bash_profile && sed -i 's/^KUBECONFIG.*/KUBECONFIG=/home/vagrant/.kube/config/' /home/vagrant/.bash_profile || echo 'export KUBECONFIG=/home/vagrant/.kube/config' >> /home/vagrant/.bash_profile
        EOH
      only_if 'which minikube'
    end

    bash 'create kubectl config dir' do
      user 'vagrant'
      environment(
        'HOME' => '/home/vagrant',
        'USER' => 'vagrant'
      )
      code <<-EOH
        mkdir -p $HOME/.kube || true
        touch $HOME/.kube/config
        EOH
      only_if 'which kubectl'
    end

    if platform?('ubuntu')
      execute 'start minikube' do
        user 'vagrant'
        environment(
          'HOME' => '/home/vagrant',
          'USER' => 'vagrant'
        )
        command "sudo -E minikube start --vm-driver=none --network-plugin=cni --bootstrapper=kubeadm --kubernetes-version #{k8s_version}"
        only_if 'which minikube'
      end
    end

    if platform?('centos')
      execute 'start minikube' do
        user 'vagrant'
        environment(
          'HOME' => '/home/vagrant',
          'USER' => 'vagrant'
        )
        command "sudo -E #{binary_path}/minikube start --vm-driver=none --network-plugin=cni --bootstrapper=kubeadm --kubernetes-version #{k8s_version}"
        only_if 'which minikube'
      end
    end
  end
end

action :remove do
  delete_existing_minikube_version(binary_path)
end

action_class do
  def docker
    if platform?('ubuntu')
      bash 'install docker' do
        code <<-EOH
          apt-get update
          apt-get install -y \
              apt-transport-https \
              ca-certificates \
              curl \
              software-properties-common
          curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
          add-apt-repository \
             "deb https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
             $(lsb_release -cs) \
             stable"
          apt-get update && apt-get install -y docker-ce
          EOH
        not_if 'which docker'
      end
    end

    if platform?('centos')
      bash 'install docker' do
        code <<-EOH
          yum check-update
          yum install -y yum-utils device-mapper-persistent-data lvm2
          yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
          yum install -y docker-ce
          EOH
        not_if 'which docker'
      end
    end

    execute 'add to docker group' do
      user 'root'
      command 'usermod -a -G docker vagrant'
    end

    bash 'config docker service' do
      code <<-EOH
        systemctl daemon-reload
        systemctl enable docker
        systemctl start docker
        EOH
      only_if 'which docker'
    end
  end

  def sudo
    if platform?('ubuntu')
      bash 'install sudo' do
        user 'root'
        code <<-EOH
          apt-get update && apt-get install -y sudo
          EOH
        not_if 'which sudo'
      end
    end

    if platform?('centos')
      bash 'install sudo' do
        user 'root'
        code <<-EOH
          yum install sudo -y
          EOH
        not_if 'which sudo'
      end
    end

    # Set sudo run without passwd for vagrant user 's all command
    execute 'set command without passwd' do
      user 'root'
      command "echo 'vagrant ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers.d/vagrant_cmd"
      only_if 'which sudo'
    end
  end

  def create_vagrant_user
    # Create vagrant user for chicken test, no need if use with teracy-dev
    user 'vagrant' do
      comment 'create application user for chickentest'
      uid '1000'
      home '/home/vagrant'
      manage_home true
      system true
      not_if 'grep vagrant /etc/passwd'
    end
  end

  def minikube_requirement
    vagrant_user_check_cmd = Mixlib::ShellOut.new('grep vagrant /etc/passwd')
    vagrant_user_check_cmd.run_command
    create_vagrant_user() if vagrant_user_check_cmd.stdout.empty?

    sudo_requirement_check_cmd = Mixlib::ShellOut.new('sudo --version')
    sudo_requirement_check_cmd.run_command
    sudo() if sudo_requirement_check_cmd.stdout.empty? && !sudo_requirement_check_cmd.stderr.empty?

    docker_requirement_check_cmd = Mixlib::ShellOut.new('docker version')
    docker_requirement_check_cmd.run_command
    docker() if docker_requirement_check_cmd.stdout.empty? && !docker_requirement_check_cmd.stderr.empty?
  end

  def latest_minikube_version
    latest_minikube_version_cmd = Mixlib::ShellOut.new("curl -s https://api.github.com/repos/kubernetes/minikube/releases/latest | grep 'tag_name' | cut -d\\\" -f4")
    latest_minikube_version_cmd.run_command
    latest_minikube_version_cmd.error!
    latest_minikube_version = latest_minikube_version_cmd.stdout.strip
    latest_minikube_version
  end

  def existing_minikube_version
    existing_minikube_version_cmd = Mixlib::ShellOut.new("minikube version | cut -d ' ' -f3")
    existing_minikube_version_cmd.run_command

    existing_minikube_version = ''
    existing_minikube_version = existing_minikube_version_cmd.stdout.strip if existing_minikube_version_cmd.stderr.empty? && !existing_minikube_version_cmd.stdout.empty?
    existing_minikube_version
  end

  def delete_existing_minikube_version(binary_path)
    bash 'remove minikube' do
      code <<-EOH
        systemctl stop '*kubelet*.mount'
        docker rm -f $(docker ps -aq --filter name=k8s)
        minikube delete
        rm -rf $HOME/.minikube
        rm -rf $HOME/.kube
        rm -rf #{binary_path}/minikube
        rm -rf /etc/kubernetes/
        kubeadm_binary=$(which kubeadm);
        rm -rf $kubeadm_binary
        kubelet_binary=$(which kubelet);
        rm -rf $kubelet_binary
        EOH
      only_if 'which minikube'
    end
  end
end

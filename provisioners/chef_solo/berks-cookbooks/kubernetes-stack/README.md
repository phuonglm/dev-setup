# kubernetes-stack-cookbook [![Build Status](https://travis-ci.org/teracyhq-incubator/kubernetes-stack-cookbook.svg?branch=develop)](https://travis-ci.org/teracyhq-incubator/kubernetes-stack-cookbook)

Kubernetes stack cookbook to work with Kubernetes: https://supermarket.chef.io/cookbooks/kubernetes-stack

## Requirements

- Chef 12.5.x or higher. Chef 11 is NOT SUPPORTED.

## Platform support

|              | gcloud | kubectl | helm |
|--------------|:------:|:--------|:----:|
| centos-7     | ✔      | ✔       | ✔    |
| ubuntu-16.04 | ✔      | ✔       | ✔    |

- `kubectl`: support all centos-7 and ubuntu-16.04 versions.
- `helm`: support all centos-7 and ubuntu-16.04 versions.
- `gcloud`: support all centos-7 and ubuntu-16.04 versions. Should use version avaiable in https://packages.cloud.google.com/apt/ (with ubuntu platform) for faster autocomplete.
- `kubernetes`: support all centos-7 and ubuntu-16.04 versions.

## How to use

- Add `depends 'kubernetes-stack'` to your cookbook's metadata.rb.
- Use the resources shipped in cookbook in a recipe :

```ruby
kubectl 'install kubectl' do
  action [:install, :remove]
  version '' #application version (if empty, default: latest)
  binary_path '' #application path (if empty, default: /usr/local/bin)
end

gcloud 'install gcloud' do
  action [:install, :remove]
  version '' #application version (if empty, default: latest)
  binary_path '' #application path (if empty, default: /usr/local/bin/gcloud)
end

helm 'install helm' do
  action [:install, :remove]
  version '' #application version (if empty, default: latest)
  binary_path '' #application path (if empty, default: /usr/local/bin/helm)
end

kubernetes 'install kubernetes' do
  action [:install, :remove]
  version '' #application version (if empty, default: latest, ensure same as kubectl version)
  binary_path '' #application path (if empty, default: /usr/local/bin)
end
```

## How to develop

- Follow https://github.com/teracyhq/dev-setup/tree/develop

- Fork this project into your personal account and then clone it into the workspace directory:

  ```bash
  $ cd ~/teracy-dev/workspace
  $ git checkout <your_forked_repo>
  $ cd kubernetes-stack-cookbook
  $ git remote add upstream git@github.com:teracyhq-incubator/kubernetes-stack-cookbook.git
  ```

- `$ vagrant reload --provision` to update the dev-setup from this project into the teracy-dev's VM.

- For codestyle checking:

  ```bash
  $ cd ~/teracy-dev
  $ vagrant ssh
  $ ws
  $ cd kubernetes-stack-cookbook
  $ codestyle
  ```

- For rspec checking:

  ```bash
  $ rspec
  ```

- For kitchen testing:

  ```bash
  $ kitchen list
  $ kitchen verify <instance>
  ```

## Resources overview

- [gcloud](#gcloud): install or remove `google-cloud-sdk`.
- [kubectl](#kubectl): install or remove `kubectl`.
- [helm](#helm): install or remove `helm`.
- [kubernetes](#kubernetes): install or remove `kubernetes`.

## Resources detail
## gcloud

The `gcloud` resource auto-install or auto-remove `gcloud` with the provider resolution system.

### Example

Install `gcloud` with default version:

```ruby
gcloud 'install default gcloud' do
  action :install
  version ''
  binary_path ''
end
```

Install `gcloud` with specific version:

```ruby
gcloud 'install specific gcloud version' do
  action :install
  version '164.0.0'
  binary_path ''
end
```

Remove `gcloud`:

```ruby
gcloud 'remove gcloud' do
  action :remove
end
```

### Properties

- `action` - `:install` to install `gcloud`, `:remove` to uninstall `gcloud`.
- `version` - The desired version of `gcloud`.
- `binary_path` - Application path (if empty, default:/usr/local/bin/gcloud)

## kubectl

The `kubectl` resource auto-install or auto-remove `kubectl` with the provider resolution system.

### Example

Install `kubectl` with default version:

```ruby
kubectl 'install default kubectl' do
  action :install
  version ''
  binary_path ''
end
```

Install `kubectl` with specific version:

```ruby
kubectl 'install specific kubectl version' do
  action :install
  version 'v1.7.0'
  binary_path ''
end
```

Remove `kubectl`:

```ruby
kubectl 'remove kubectl' do
  action :remove
end
```

### Properties
- `action` - `:install` to install `kubectl`, `:remove` to uninstall `kubectl`.
- `version` - The desired version of `kubectl`.
- `binary_path` - Application path (if empty, default:/usr/local/bin)

## helm

The `helm` resource auto-install or auto-remove `helm` with the provider resolution system.

### Example

Install `helm` with default version:

```ruby
helm 'install default helm' do
  action :install
  version ''
  binary_path ''
end
```

Install `helm` with specific version:

```ruby
helm 'install specific helm version' do
  action :install
  version 'v2.4.2'
  binary_path ''
end
```

Remove `helm`:

```ruby
helm 'remove helm' do
  action :remove
end
```

### Properties
- `action` - `:install` to install `helm`, `:remove` to uninstall `helm`.
- `version` - The desired version of `helm`.
- `binary_path` - Application path (if empty, default:/usr/local/bin/helm)

## kubernetes

The `kubernetes` resource auto-install or auto-remove `kubernetes` with the provider resolution system.

### Example

Install `kubernetes` with default version and default solution:

```ruby
kubernetes 'install default kubernetes' do
  action :install
  version ''
end
```

Install `kubernetes` with specific version or specific solution:

```ruby
kubernetes 'install specific kubernetes version' do
  action :install
  version 'v1.9.0' # ensure same as kubectl version
end
```

Remove `kubernetes`:

```ruby
kubernetes 'remove kubernetes' do
  action :remove
end
```

### Properties
- `action` - `:install` to install `kubernetes`, `:remove` to uninstall `kubernetes`.
- `version` - The desired version of `kubernetes`.
- `binary_path` - Application path (if empty, default:/usr/local/bin)

## See more:

- https://github.com/teracyhq/dev
- https://docs.chef.io/cookstyle.html
- https://github.com/chef/cookstyle
- https://github.com/someara/kitchen-dokken
- https://docs.chef.io/about_chefdk.html
- https://github.com/chef/chef-dk
- http://kitchen.ci/

## License

```
Copyright (c) Teracy Corporation

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

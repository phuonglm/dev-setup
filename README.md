# Acme Dev Guide

This is the standard guide to use `teracy-dev` for teams/ organizations with multiple projects
(microservices architecture).

We created [acme101 GitHub organization](https://github.com/acme101) as the standard reference for
`teracy-dev` best practices.

We also use it as the tranining material, too. We've been adding a lof of simple projects to show
how `teracy-dev` should be used.

We also use this as the reference for our existing and future clients' projects.

By following this reference, everyone can follow the best practices of `teracy-dev`.


Please follow this getting started guide to set up the development environment.

Please take a cup of coffee with you, you mostly don't have to do anything but wait for the result,
enjoy!

## Set up acme-dev

You should create `<team/organization>-dev` for all your team projects. We're going to create dev
environment for `Acme` organization, so we need to create `acme-dev` directory.

- Firstly, follow this guide to install required software packages:
    + Remember to skip this step:
      http://dev.teracy.org/docs/develop/getting_started.html#teracy-dev-git-clone-and-vagrant-up
    + http://dev.teracy.org/docs/develop/getting_started.html

- And then:

    ```
    $ cd ~/
    $ git clone https://github.com/teracyhq/dev.git acme-dev
    $ cd acme-dev
    $ git checkout develop
    $ vagrant up
    ```
    
    Note: instead of using `teracy-dev` name as guided, we use `acme-dev`. `teracy-dev` should
    be used for Teracy's projects only.
    See more in details: http://dev.teracy.org/docs/getting_started.html#teracy-dev-git-clone-and-vagrant-up


## Set up Acme projects

- Stop watching files (Use `Ctrl + c`) on the file watching terminal window.

- Fork the [acme/angular-hello-world](https://github.com/acme101/angular-hello-world) repo into your
  account.

- Clone the forked `acme/angular-hello-world` repo into the `~/acme-dev/workspace` directory.

    ```bash
    $ cd ~/acme-dev/workspace/
    $ git clone <your_forked_repository_here> angular-hello-world
    $ cd angular-hello-world
    $ git remote add upstream git@github.com:acme101/angular-hello-world.git
    ```

- Clone the `acme101/dev-setup` repo into the `~/acme-dev/workspace` directory.

    ```bash
    $ cd ~/acme-dev/workspace/
    $ git clone git@github.com:acme101/dev-setup.git
    ```

- Type the following command:
    
    ```bash
    $ cd ~/acme-dev
    $ cp workspace/dev-setup/vagrant_config_override.example.json vagrant_config_override.json
    ```
  to create `vagrant_config_override.json` file on the `acme-dev` directory by copying the
  `workspace/dev-setup/vagrant_config_override.example.json` file (you can then adjust variables
  to your own need when required)


- Reload the Vagrant box to make sure it's updated.

    ```bash
    $ cd ~/acme-dev
    $ vagrant reload --provision
    ```

- After finishing running (take a long time to set everything up for the first time), you should
  see the following similar output:

    ```bash
    ==> default: [2017-03-10T03:04:21+00:00] INFO: Chef Run complete in 115.040022137 seconds
    ==> default: 
    ==> default: Running handlers:
    ==> default: [2017-03-10T03:04:21+00:00] INFO: Running report handlers
    ==> default: Running handlers complete
    ==> default: 
    ==> default: [2017-03-10T03:04:21+00:00] INFO: Report handlers complete
    ==> default: Chef Client finished, 19/27 resources updated in 01 minutes 56 seconds
    ==> default: Running provisioner: ip (shell)...
        default: Running: /var/folders/59/znjnt7bn73d7c7_4l0fsdzm80000gn/T/vagrant-shell20170310-39691-41628j.sh
    ==> default: ip address: 192.168.0.11
    ==> default: vagrant-gatling-rsync is starting the sync engine because you have at least one rsync folder. To disable this behavior, set `config.gatling.rsync_on_startup = false` in your Vagrantfile.
    ==> default: Doing an initial rsync...
    ==> default: Rsyncing folder: /Users/hoatle/acme-dev/workspace/ => /home/vagrant/workspace
    ==> default:   - Exclude: [".vagrant/", ".git", ".idea/", "node_modules/", "bower_components/", ".npm/"]
    ==> default: Watching: /Users/hoatle/acme-dev/workspace
    ```

- Make sure the ``/etc/hosts`` file get updated automatically with the following commands:

    ```bash
    $ cd ~/acme-dev
    $ vagrant hostmanager
    ```

- `$ ping acme.dev` to make sure it pings the right IP address of the VM:
   http://dev.teracy.org/docs/basic_usage.html#ip-address

- `$ cat /etc/hosts` file from the host machine to make sure there is no duplicated entries for
  `acme-dev` or the VM IP address.

- Now open http://dev.ahw.acme.dev or https://dev.ahw.acme.dev on your browser to see the web
  app and start working on it. For https, you need to add exception into your browsers. This is the
  defined domain from the `angular-hello-world` project for the dev mode. For more information,
  see https://github.com/acme101/angular-hello-world/blob/develop/README.md

## How to start working

- You can use any text editor or IDE to edit the dropseeker project files
  at `~/acme-dev/workspace/`

- Learn how to work with teracy-dev:

  + http://dev.teracy.org/docs/basic_usage.html
  + http://dev.teracy.org/docs/advanced_usage.html

- Follow this workflow: http://dev.teracy.org/docs/workflow.html

- Learn how to work with docker and docker-compose:

  + https://www.docker.com/
  + https://github.com/veggiemonk/awesome-docker

- Learn how to work with Angular: https://angular.io/
 

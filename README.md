
# App Local `v0.4.0` [![Build Status](https://travis-ci.org/dbtedman/app-local.svg?branch=0.4.0)](https://travis-ci.org/dbtedman/app-local)

Provides a repeatable local development environment that matches an app server infrastructure, associated databases and services.

## Is it open?

Yes, it is released under the MIT License, See [LICENSE.md](LICENSE.md).

## Where do I start?

1\. Install [Virtual Box](https://www.virtualbox.org/) and [Vagrant](https://www.vagrantup.com).

2\. Install [Vagrant Librarian Puppet](https://github.com/mhahn/vagrant-librarian-puppet) and [Vagrant Puppet Install](https://github.com/petems/vagrant-puppet-install) vagrant plugins.

3\. Checkout [this repository](https://github.com/dbtedman/app-local) to your machine.

```bash
# The directory where your code lives.
cd /Users/danieltedman/Workspace

# Clone the repository.
git clone https://github.com/dbtedman/app-local.git
```

> The path to this repository e.g. `/Users/danieltedman/Workspace/app-local` will hereafter be refereed to as `$REPO`.

4\. Define a `$REPO/hiera/developer.yaml` configuration file to customise Puppet and Vagrant configuration by duplicating the example configuration file `$REPO/hiera/developer.example.yaml`.

5\. Download [Oracle InstantClient (.rpm) Files](http://www.oracle.com/technetwork/topics/linuxx86-64soft-092277.html) **basic**, **devel** and **sqlplus** into the `$REPO/app_modules/app_local/files` directory. The names of these files will need to be added to the `$REPO/heria/developer.yaml` config file for `oracle_instantclient_basic`, `oracle_instantclient_development` and `oracle_instantclient_sqlplus` properties.

```yaml
# Example based on instant client version at time of writing these instructions, the current version may be different.
oracle_instantclient_basic: 'oracle-instantclient12.1-basic-12.1.0.2.0-1.x86_64.rpm'
oracle_instantclient_development: 'oracle-instantclient12.1-devel-12.1.0.2.0-1.x86_64.rpm'
oracle_instantclient_sqlplus: 'oracle-instantclient12.1-sqlplus-12.1.0.2.0-1.x86_64.rpm'
```

6\. Start and provision the virtual machine.

```bash
# Vagrant commands must be run from within the checked out repository.
cd $REPO

# Starts up the VM and runs the Puppet provisioner.
vagrant up --provision
```

> See [Vagrant CLI](https://www.vagrantup.com/docs/cli) for documentation on how to interact with the vm.

7\. View an index of deployed applications, [https://localhost:8443](https://localhost:8443).

> When mapping new projects into the vm or updating the configuration of existing ones, you will need to run the `vagrant reload --provision` command to apply these changes.

> When running from Windows, you will need to run PowerShell as an administrator to be able to create symlinks.

## Want to learn more?

See our [CONTRIBUTING.md](CONTRIBUTING.md) guide for information regarding:

* project contributors
* dependencies
* testing

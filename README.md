
# App Local `v0.5.0` [![Build Status](https://travis-ci.org/dbtedman/app-local.svg?branch=0.5.0)](https://travis-ci.org/dbtedman/app-local)

Provides a repeatable local development environment that matches an app server infrastructure, associated databases and services.

## Contributors

* [Daniel Tedman](https://danieltedman.com)

## Getting Started

1\. Install [Virtual Box](https://www.virtualbox.org/) and [Vagrant](https://www.vagrantup.com).

2\. Install [Vagrant Puppet Install](https://github.com/petems/vagrant-puppet-install) vagrant plugins.

3\. Checkout [this repository](https://github.com/dbtedman/app-local) to your machine.

```bash
# The directory where your code lives.
cd /Users/danieltedman/Workspace

# Clone the repository.
git clone https://github.com/dbtedman/app-local.git
```

> The path to this repository e.g. `/Users/danieltedman/Workspace/app-local` will hereafter be refereed to as `$REPO`.

4\. Install ruby and [bundler](http://bundler.io/).

5\. Install ruby dependencies.

```bash
bundle
```

6\. Install puppet module dependencies.

```bash
bundle exec r10k puppetfile install --verbose
```

4\. Define a `$REPO/hiera/developer.yaml` configuration file to customise Puppet and Vagrant configuration by duplicating the example configuration file `$REPO/hiera/developer.example.yaml`.

5\. Download [Oracle InstantClient (.rpm) Files](http://www.oracle.com/technetwork/topics/linuxx86-64soft-092277.html) **basic**, **devel** and **sqlplus** into the `$REPO/app_modules/app_local/files` directory. The names of these files will need to be added to the `$REPO/heria/developer.yaml` config file for `oracle_instantclient_basic`, `oracle_instantclient_development` and `oracle_instantclient_sqlplus` properties.

```yaml
# Example based on instant client version at time of writing these instructions, the current version may be different.
oracle_instantclient_basic: 'oracle-instantclient12.1-basic-12.1.0.2.0-1.x86_64.rpm'
oracle_instantclient_development: 'oracle-instantclient12.1-devel-12.1.0.2.0-1.x86_64.rpm'
oracle_instantclient_sqlplus: 'oracle-instantclient12.1-sqlplus-12.1.0.2.0-1.x86_64.rpm'
```

6\. Download [Oracle Database Express Edition 11g Release 2 for Linux x64](http://www.oracle.com/technetwork/database/database-technologies/express-edition/downloads/index.html) into the `$REPO/app_modules/app_local/files` directory. The name will need to be added to the `$REPO/heria/developer.yaml` config file for `xe_zip` property.

```yaml
# Example based on instant client version at time of writing these instructions, the current version may be different.
xe_zip: 'oracle-xe-11.2.0-1.0.x86_64.rpm.zip'
```

7\. Start and provision the virtual machine.

```bash
cd $REPO && vagrant up --provision
```

> See [Vagrant CLI](https://www.vagrantup.com/docs/cli) for documentation on how to interact with the vm.

8\. View an index of deployed applications, [https://localhost:8443](https://localhost:8443).

> When mapping new projects into the vm or updating the configuration of existing ones, you will need to run the `vagrant reload --provision` command to apply these changes.

9\. Connect to installed databases. This will be based on the `listen_ports` properties defined in the `$REPO/heria/developer.yaml` config file.

```yaml
# Example configuration, your port mappings may be configured differently.
listen_ports:
  https: 8443
  mysql: 8306
  xe: 8521 # OracleXE database.
```

## Testing

See [https://travis-ci.org/dbtedman/app-local](https://travis-ci.org/dbtedman/app-local) for CI results, run on each commit.

### Static Analysis

Check for formatting issues and automatically resolve them where possible.

```bash
cd $REPO && bundle exec puppet-lint app_modules/ --fix --no-80chars-check --no-variable_scope-check
```

### Acceptance Testing

> Currently not enabled as part of the TravisCI tests.

Provided by [ServerSpec](http://serverspec.org), and is run by Vagrant when the `enable_server_spec` property is set to `true` in your `hiera/developer.yaml` configuration file. See `spec/localhost` for avialable specifications.

To execute just the acceptance tests, after running the standard setup procedure:

```bash
cd $REPO && vagrant provision --provision-with serverspec
```

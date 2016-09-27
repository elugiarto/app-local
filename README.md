
# App Local `v0.1.0` [![Build Status](https://travis-ci.org/dbtedman/app-local.svg?branch=master)](https://travis-ci.org/dbtedman/app-local)

Provides a repeatable local development environment that matches an app server infrastructure, associated databases and services.

## Contributors

* [Daniel Tedman](http://danieltedman.com)

## License

Open Source, released under the [MIT License](http://choosealicense.com/licenses/mit/), see [LICENSE.md](LICENSE.md) for details.

## Dependencies

* [Virtual Box (v5.1)](https://www.virtualbox.org/)
* [Vagrant (v1.8)](https://www.vagrantup.com)
* [Vagrant Librarian Puppet (v0.9)](https://github.com/mhahn/vagrant-librarian-puppet) `vagrant plugin install vagrant-librarian-puppet`
* [Vagrant Puppet Install (v4.1)](https://github.com/petems/vagrant-puppet-install) `vagrant plugin install vagrant-puppet-install`
* Internet Access

*The following are only required when modifying this repository.*

* [Puppet Lint (v1.1)](http://puppet-lint.com/)
* [EditorConfig](http://editorconfig.org/#download)

## Getting Started

> For simplicity `$REPO` will refer to the path to this repository as it is checked out on your machine, e.g. `/Users/danieltedman/Workspace/app-local`.

1\. Ensure all [Dependencies](#dependencies) have been resolved.

2\. Define a `$REPO/yaml/developer.yaml` configuration file to customise Puppet and Vagrant configuration by duplicating the example configuration file `$REPO/yaml/developer.example.yaml`.

3\. Download [Oracle InstantClient RPMs](http://www.oracle.com/technetwork/topics/linuxx86-64soft-092277.html) **basic**, **devel** and **sqlplus** into the `$REPO/app_modules/app_local/files` directory. The names of these files will need to be added to the `$REPO/heria/developer.yaml` config file for `oracle_instantclient_basic`, `oracle_instantclient_development` and `oracle_instantclient_sqlplus` properties.

4\. Start and provision the virtual machine.

```bash
cd $REPO

vagrant up --provision
```

> See [Vagrant CLI](https://www.vagrantup.com/docs/cli) for documentation on how to interact with the vm.

6\. View an index of deployed applications, [https://localhost:8443](https://localhost:8443).

> When mapping new projects into the vm or updating the configuration of existing ones, you will need to run the `vagrant reload --provision` command to apply these changes.

## Testing

See [https://travis-ci.org/dbtedman/app-local](https://travis-ci.org/dbtedman/app-local) for CI results, run on each commit.

### Static Analysis

Check for formatting issues and automatically resolve them where possible.

```bash
cd $REPO

puppet-lint app_modules/ --fix --no-80chars-check --no-variable_scope-check
```

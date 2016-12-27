
# Contributing

A guide for contributing to this repository which extends the [README.md](README.md) file. 

## Contributors

* [Daniel Tedman](https://danieltedman.com)

## Dependencies

* [Virtual Box (v5.1)](https://www.virtualbox.org/)
* [Vagrant (v1.8)](https://www.vagrantup.com)
* [Vagrant Librarian Puppet (v0.9)](https://github.com/mhahn/vagrant-librarian-puppet) `vagrant plugin install vagrant-librarian-puppet`
* [Vagrant Puppet Install (v4.1)](https://github.com/petems/vagrant-puppet-install) `vagrant plugin install vagrant-puppet-install`
* [Puppet Lint (v1.1)](http://puppet-lint.com/)
* [EditorConfig](http://editorconfig.org/#download)
* [Vagrant ServerSpec (v1.1)](https://github.com/jvoorhis/vagrant-serverspec) `vagrant plugin install vagrant-serverspec`

## Testing

See [https://travis-ci.org/dbtedman/app-local](https://travis-ci.org/dbtedman/app-local) for CI results, run on each commit.

### Static Analysis

Check for formatting issues and automatically resolve them where possible.

```bash
cd $REPO

bundle exec puppet-lint app_modules/ --fix --no-80chars-check --no-variable_scope-check
```

### Acceptance Testing

> Currently not enabled as part of the TravisCI tests.

Provided by [ServerSpec](http://serverspec.org), and is run by Vagrant when the `enable_server_spec` property is set to `true` in your `hiera/developer.yaml` configuration file. See `spec/localhost` for avialable specifications.

To execute just the acceptance tests, after running the standard setup procedure:

```bash
vagrant provision --provision-with serverspec
```

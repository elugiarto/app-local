
# Contributing Guide for App Local

### Continuous Integration

* [Travis CI](https://travis-ci.org/dbtedman/app-local) - Used for running the test suite on every commit.
* [Synk](https://snyk.io/org/dbtedman/project/3facbe25-90a3-4d74-b64f-e23fc8540967) - Used for identifying security vulnerabilities in module dependencies.

### Static Analysis

Check for formatting issues and automatically resolve them where possible.

```bash
cd $REPO && bundle exec puppet-lint app_modules/ --fix --no-80chars-check --no-variable_scope-check
```

### Acceptance Testing

> Currently not enabled as part of the TravisCI tests.

Provided by [ServerSpec](http://serverspec.org), and is run by Vagrant when the `enable_server_spec` property is set to `true` in your `hiera/developer.yaml` configuration file. See `spec/localhost` for avialable specifications. You will need to install the [Vagrant ServerSpec](https://github.com/vvchik/vagrant-serverspec) plugin if you wish to run the acceptance test suite.

To execute just the acceptance tests, after running the standard setup procedure:

```bash
cd $REPO && vagrant provision --provision-with serverspec
```

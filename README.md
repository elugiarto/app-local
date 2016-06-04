
# App Local

This repository provide a repeatable local development environment that matches an app server infrastructure, associated databases and services.

![Travis CI Test Status](https://travis-ci.org/dbtedman/app-local.svg)

## Contributors

* [Daniel Tedman](http://danieltedman.com)

See `CONTRIBUTING.md` guide to learn how to contribute.

## Dependencies

* [Vagrant (v1.8.1)](https://www.vagrantup.com)
* [Vagrant Librarian Puppet (v0.9.2)](https://github.com/mhahn/vagrant-librarian-puppet)
* [Vagrant Puppet Install (v4.1.0)](https://github.com/petems/vagrant-puppet-install)
* Internet Access

*The following are required when modifying this repository.*

* [Puppet Lint (v1.1.0)](http://puppet-lint.com/)
* [EditorConfig](http://editorconfig.org/)

## Getting Started

1\. Ensure all **Dependencies** have been met.

2\. Define a `yaml/developer.yaml` configuration file to customise Puppet and Vagrant configuration:

```yaml
#
# Puppet and Vagrant customisations.
#

mysql:
  root_password: 'password'

# Defines which repositories will be mapped into the VM and how.
projects:
  example:
    source: '/Users/jane/Workspace/example'
    public: '/public' # Relative to example source.
```

3\. Start and provision VM:

```bash
vagrant up --provision
```

4\. View an index of deployed applications:

[https://localhost:8443](https://localhost:8443)

5\. To `start`/`stop`/`restart` services, use the following commands:

| Service | Command |
|:---|:---|
| Apache | `sudo apachectl $ACTION` |

## Mapped Ports

| Port | Purpose |
|:---|:---|
| `8443` | HTTPS website, [https://localhost:8443](https://localhost:8443). |
| `3306` | Workstation access to MySQL database. |

## Testing

See [https://travis-ci.org/dbtedman/app-local](https://travis-ci.org/dbtedman/app-local) for CI results.

### Static Analysis

```bash
puppet-lint --fix app_modules/
```

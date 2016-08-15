
# App Local

Provides a repeatable local development environment that matches an app server infrastructure, associated databases and services.

[![Travis CI Test Status](https://travis-ci.org/dbtedman/app-local.svg)](https://travis-ci.org/dbtedman/app-local)

## Contributors

* [Daniel Tedman](http://danieltedman.com)

## Dependencies

* [Virtual Box (v5.1)](https://www.virtualbox.org/)
* [Vagrant (v1.8)](https://www.vagrantup.com)
* [Vagrant Librarian Puppet (v0.9)](https://github.com/mhahn/vagrant-librarian-puppet)
* [Vagrant Puppet Install (v4.1)](https://github.com/petems/vagrant-puppet-install)
* Internet Access

*The following are required when modifying this repository.*

* [Puppet Lint (v1.1)](http://puppet-lint.com/)
* [EditorConfig](http://editorconfig.org/#download) (optional)

## Getting Started

1\. Ensure all [Dependencies](#dependencies) have been satisfied.

2\. Download [Oracle InstantClient RPMs](http://www.oracle.com/technetwork/topics/linuxx86-64soft-092277.html) **basic**, **devel** and **sqlplus** into `/app_modules/app_local/files`. The names of these files will need to be added to the `heria/developer.yaml` config file.

3\. Define a `yaml/developer.yaml` configuration file to customise Puppet and Vagrant configuration based on the example provided `yaml/developer.example.yaml`.

4\. Start and provision VM:

```bash
vagrant up --provision
```

5\. View an index of deployed applications, [https://localhost:8443](https://localhost:8443).

## Testing

See [https://travis-ci.org/dbtedman/app-local](https://travis-ci.org/dbtedman/app-local) for CI results, run on each commit.

### Static Analysis

Check for formatting issues and automatically resolve them where possible.

```bash
puppet-lint app_modules/ --fix
```

## Services

To `start`/`stop`/`restart`/`status` services, use the following commands:

| Service | Command |
|:---|:---|
| Apache | `sudo service httpd status` |
| MySQL | `sudo service mysql status` |


## Mapped Ports

| Port | Purpose |
|:---|:---|
| `8443` | HTTPS website, [https://localhost:8443](https://localhost:8443). |
| `3306` | Workstation access to MySQL database. |

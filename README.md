
# App Local

Provides a repeatable local development environment that matches an app server infrastructure, associated databases and services.

[![Travis CI Test Status](https://travis-ci.org/dbtedman/app-local.svg)](https://travis-ci.org/dbtedman/app-local)

## Contributors

* [Daniel Tedman](http://danieltedman.com)

## Dependencies

* [Virtual Box (v5.1)](https://www.virtualbox.org/)
* [Vagrant (v1.8)](https://www.vagrantup.com)
* [Vagrant Librarian Puppet (v0.9)](https://github.com/mhahn/vagrant-librarian-puppet)
    * *Has issues on Windows 7, install [librarian-puppet](https://github.com/rodjek/librarian-puppet) ruby library instead. Then run `librarian-puppet install` from the `app-local` root directory to install puppet dependencies.*
* [Vagrant Puppet Install (v4.1)](https://github.com/petems/vagrant-puppet-install)
* Internet Access
* [Oracle InstantClient RPMs](http://www.oracle.com/technetwork/topics/linuxx86-64soft-092277.html) - *Download the following RPMs into `/app_modules/app/files`. The names of these files will need to be added to the `heria/developer.yaml` config file.*
    * `oracle-instantclient12.1-basic-$CURRENT_VERSION.x86_64.rpm`
    * `oracle-instantclient12.1-devel-$CURRENT_VERSION.x86_64.rpm`
    * `oracle-instantclient12.1-sqlplus-$CURRENT_VERSION.x86_64.rpm`

*The following are required when modifying this repository.*

* [Puppet Lint (v1.1)](http://puppet-lint.com/)
* [EditorConfig](http://editorconfig.org/#download) (optional)

## Getting Started

1\. Ensure all [Dependencies](#dependencies) have been satisfied.

2\. Define a `yaml/developer.yaml` configuration file to customise Puppet and Vagrant configuration:

```yaml
#
# Puppet and Vagrant customisations.
#

# Set to true if you get ssh auth errors when provisioning vm.
disable_ssh_key_insert: false

# RPM files downloaded in dependencies instructions.
oracle_instantclient_basic: 'oracle-instantclient12.1-basic-12.1.0.2.0-1.x86_64.rpm'
oracle_instantclient_development: 'oracle-instantclient12.1-devel-12.1.0.2.0-1.x86_64.rpm'
oracle_instantclient_sqlplus: 'oracle-instantclient12.1-sqlplus-12.1.0.2.0-1.x86_64.rpm'

mysql:
  root_password: 'password'

  databases:
    testdb:
      users:
        testuser:
          password: 'password'
          grants:
            - 'ALL'

# Defines which repositories will be mapped into the VM and how.
projects:
  example: # This key will be used in the url of the website, e.g. https://localhost:8443/example
    source: '/Users/jane/Workspace/example' # The location of the code on the development machine. Use '/' or '\' based on OS.
    public: '/public' # Path relative to the root of code as it will appear in the vm. (Uses '/' here even if source is on Windows)
```

3\. Start and provision VM:

```bash
vagrant up --provision
```

4\. View an index of deployed applications:

[https://localhost:8443](https://localhost:8443)

To check php config, visit [https://localhost:8443/about.php](https://localhost:8443/about.php).

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

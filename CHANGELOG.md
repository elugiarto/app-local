
# Changelog

Releases ordered so that the most recent are displayed at the top, with the currently being developed release at the top, labeled as **In Development**. This release will be given a number once it is ready to be released. Each release can contain both a **Features and Improvements** and **Bug Fixes** sections.

## In Development [![Build Status](https://travis-ci.org/dbtedman/app-local.svg?branch=master)](https://travis-ci.org/dbtedman/app-local)

* Node and NPM now install latest stable versions.

### 0.2.0 [![Build Status](https://travis-ci.org/dbtedman/app-local.svg?branch=0.2.0)](https://travis-ci.org/dbtedman/app-local)

### Features and Improvements

* Add better support for versions of InstantClient after `12.1`.
* Clean up port mapping in `Vagrantfile`.
* Initial implementation of ServerSpec based acceptance tests.
* Updated project documentaiton model by separating contributing instructions from usage instructions.

## 0.1.0 [![Build Status](https://travis-ci.org/dbtedman/app-local.svg?branch=0.1.0)](https://travis-ci.org/dbtedman/app-local)

### Features and Improvements

* Apache and PHP v5.5 support.
* MySQL with configurable databases with user accounts.
* Configurable project sync from developer workstation into vm.
* Oracle Instant Client support.
* Add Node and NPM support, along with some commonly used CLI tools.
* Add Ruby and Bundler support, along with some commonly used CLI tools.
* Add OCI8 support for PHP to communicate with Oracle databases.
* Enable SSO emulation.
* Add feature toggles.
* SSO demo data customisation.

### Bug Fixes

* Provide alternative workflow for puppet module install as Vagrant Librarian Puppet has issues on Windows 7.

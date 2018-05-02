#
# Shared parameter definitions.
#
class app_local::params {
  $enable_oracle_xe = hiera('enable_oracle_xe', true)
  $xe_zip = hiera('xe_zip', 'oracle-xe-11.2.0-1.0.x86_64.rpm.zip')
  $xe_root_password = hiera('xe_root_password', 'password')
}

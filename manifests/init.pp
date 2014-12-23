# == Class: tinc
#
# Full description of class tinc here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { 'tinc':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2014 Your name here, unless otherwise noted.
#
class tinc (
  $package   = $::tinc::params::package,   # package name.
  $version   = $::tinc::params::version,   # package version: present[default], latest, absent.
  $service   = $::tinc::params::service,   # service name.
  $boot_file = $::tinc::params::boot_file, # tinc daemon boot settings.
  $boot_file_template = $::tinc::params::boot_file_template, # template
  ) inherits tinc::params {

  package {
    'tinc' :
      name => $package,
      ensure => installed,
  }

  service {
    'tinc' :
      name => $service
      ensure => running,
      enable => true,
      hasstatus => true,
      require => Package['tinc'],
  }

  file {
    'tinc_nets_boot' :
      path => $boot_file,
      content => template('tinc/nets.boot'),
      ensure => present,
      require => Package['tinc'],
      before => Service['tinc'],
      owner => root,
      group => 0,
      mode => 0600 ;
  }
}

# === Class: notepadplusplus
#
# This module installs NotePad++ on Windows systems. It also adds an entry to the
# PATH environment variable.
#
# === Parameters
#
# [*url*]
#   HTTP url where the installer is available. It defaults to main site.
# [*package*]
#   Package name in the system.
# [*file_path*]
#   This parameter is used to specify a local path for the installer. If it is
#   set, the remote download from $url is not performed. It defaults to false.
#
# === Examples
#
# class { 'notepadplusplus': }
#
# class { 'notepadplusplus':
#   $url     => 'http://192.168.1.1/files/notepadplusplus.exe',
#   $package => 'NotePad++',
# }
#
# === Authors
# 
#
class notepadplusplus (
  $url       = $::notepadplusplus::params::url,
  $package   = $::notepadplusplus::params::package,
  $file_path = false,
) inherits notepadplusplus::params {

  if $file_path {
    $notepadplusplus_installer_path = $file_path
  } else {
    $notepadplusplus_installer_path = "${::temp}\\${package}.exe"
    windows_common::remote_file{'NotePad++':
      source      => $url,
      destination => $notepadplusplus_installer_path,
      before      => Package[$package],
    }
  }
  package { $package:
    ensure          => installed,
    source          => $notepadplusplus_installer_path,
    install_options => ['/VERYSILENT','/SUPPRESSMSGBOXES','/LOG'],
  }

  if $::architecture == 'x64' {
    $notepadplusplus_path = 'C:\Program Files (x86)\NotePad++'
  } else {
    $notepadplusplus_path = 'C:\Program Files\NotePad++'
  }
 
  windows_path { $notepadplusplus_path:
    ensure  => present,
    require => Package[$package],
  }
}

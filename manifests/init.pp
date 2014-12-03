# Public: installs java jre-7u71 and JCE unlimited key size policy files
#
# Examples
#
#    include java
class java (
  $update_version = '71',
  $base_download_url = 'https://s3.amazonaws.com/boxen-downloads/java'
) {
  include boxen::config

  $dmg_sfx = "7u${update_version}-macosx-x64.dmg"
  $jre_url = "${base_download_url}/jre-${dmg_sfx}"
  $jdk_url = "${base_download_url}/jdk-${dmg_sfx}"
  $wrapper = "${boxen::config::bindir}/java"
  $jvm_dir = '/Library/Java/JavaVirtualMachines'
  $jdk_dir = "${jvm_dir}/jdk1.7.0_${update_version}.jdk"
  $sec_dir = "${jdk_dir}/Contents/Home/jre/lib/security"
  $bdl_dir = "${jdk_dir}/Contents/Home/bundle"
  $bl_dir  = "${bdl_dir}/Libraries"

  package {
    "jre-7u${update_version}.dmg":
      ensure   => present,
      alias    => 'java-jre',
      provider => pkgdmg,
      source   => $jre_url ;
    "jdk-7u${update_version}.dmg":
      ensure   => present,
      alias    => 'java',
      provider => pkgdmg,
      source   => $jdk_url ;
  }

  file { $wrapper:
    source  => 'puppet:///modules/java/java.sh',
    mode    => '0755',
    require => Package['java']
  }

  boxen::env_script { 'java':
    ensure   => 'present',
    content  => template('java/env.sh.erb'),
    priority => lower,
  }

  file {
    [
      $jdk_dir,
      $sec_dir,
      $bdl_dir,
      $bl_dir,
    ]:
      ensure  => 'directory',
      owner   => 'root',
      group   => 'wheel',
      mode    => '0775',
      require => Package['java']
  }

  # Allow 'large' keys locally.
  # http://www.ngs.ac.uk/tools/jcepolicyfiles

  file { "${sec_dir}/local_policy.jar":
    source  => 'puppet:///modules/java/local_policy.jar',
    owner   => 'root',
    group   => 'wheel',
    mode    => '0664',
    require => File[$sec_dir]
  }

  file { "${sec_dir}/US_export_policy.jar":
    source  => 'puppet:///modules/java/US_export_policy.jar',
    owner   => 'root',
    group   => 'wheel',
    mode    => '0664',
    require => File[$sec_dir]
  }

  exec { 'jvmcapabilities fixup':
    command     => "plutil -replace JavaVM.JVMCapabilities -json '[\"CommandLine\",\"BundledApp\",\"JNI\"]' ${jdk_dir}/Contents/Info.plist",
    require     => Package['java'],
    refreshonly => true,
  }

  file { "${bl_dir}/libserver.dylib":
    ensure   => 'link',
    owner    => 'root',
    group    => 'wheel',
    target   => "${jdk_dir}/Contents/Home/jre/lib/server/libjvm.dylib",
    require  => [
                  File[$bl_dir],
                  Package['java-jre'],
                ]
  }
}

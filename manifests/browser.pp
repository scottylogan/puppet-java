# Public: installs java jre-7u51 and JCE unlimited key size policy files
#
# Examples
#
#    class { 'java::browser':
#      ensure => 'absent',
#    }
#
class java::browser (
  $ensure = present,
) {

  if $ensure == 'present' {

    file { '/Library/Application Support/Oracle/Java/javaws':
      ensure  => link,
      owner   => 'root',
      group   => 'wheel',
      target  => '/Library/Internet Plug-Ins/JavaAppletPlugin.plugin/Contents/Home/bin/_javaws',
      require => Package['java-jre'],
    }

    file { '/Library/Application Support/Oracle/Java/Info.plist':
      ensure  => link,
      owner   => 'root',
      group   => 'wheel',
      target  => '/Library/Internet Plug-Ins/JavaAppletPlugin.plugin/Contents/Enabled.plist',
      require => Package['java-jre'],
    }

  } else {

    file { '/Library/Application Support/Oracle/Java/javaws':
      ensure  => absent,
      require => Package['java-jre'],
    }

    file { '/Library/Application Support/Oracle/Java/Info.plist':
      ensure  => link,
      owner   => 'root',
      group   => 'wheel',
      target  => '/Library/Internet Plug-Ins/JavaAppletPlugin.plugin/Contents/Disabled.plist',
      require => Package['java-jre'],
    }

  }

}

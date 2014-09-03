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
      ensure => link,
      target => '/Library/Internet Plug-Ins/JavaAppletPlugin.plugin/Contents/Home/bin/_javaws',
    }

    file { '/Library/Application Support/Oracle/Java/Info.plist':
      ensure => link,
      target => '/Library/Internet Plug-Ins/JavaAppletPlugin.plugin/Contents/Enabled.plist',
    }

  } else {

    file { '/Library/Application Support/Oracle/Java/javaws':
      ensure => absent,
    }

    file { '/Library/Application Support/Oracle/Java/Info.plist':
      ensure => link,
      target => '/Library/Internet Plug-Ins/JavaAppletPlugin.plugin/Contents/Disabled.plist',
    }

  }

}
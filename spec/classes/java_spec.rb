require 'spec_helper'

describe "java" do
  let(:facts) { default_test_facts }
  let(:params) {
    {
      :update_version => '67',
      :base_download_url => 'https://downloads.test/java'
    }
  }

  it do
    should include_class('boxen::config')

    should contain_package('jre-7u67.dmg').with({
      :ensure   => 'present',
      :alias    => 'java-jre',
      :provider => 'pkgdmg',
      :source   => 'https://downloads.test/java/jre-7u67-macosx-x64.dmg'
    })

    should contain_package('jdk-7u67.dmg').with({
      :ensure   => 'present',
      :alias    => 'java',
      :provider => 'pkgdmg',
      :source   => 'https://downloads.test/java/jdk-7u67-macosx-x64.dmg'
    })

    should contain_file('/test/boxen/bin/java').with({
      :source  => 'puppet:///modules/java/java.sh',
      :mode    => '0755',
      :require => 'Package[java]'
    })

    should contain_file('/Library/Java/JavaVirtualMachines/jdk1.7.0_67.jdk/Contents/Home/bundle/Libraries').with({
      :ensure  => 'directory',
    })

    should contain_file('/Library/Java/JavaVirtualMachines/jdk1.7.0_67.jdk/Contents/Home/bundle/Libraries/libserver.dylib').with({
      :target  => '/Library/Java/JavaVirtualMachines/jdk1.7.0_67.jdk/Contents/Home/jre/lib/server/libjvm.dylib',
    })

    should contain_boxen__env_script("java")
      .with_content(/^export JAVA_HOME=\/Library\/Java\/JavaVirtualMachines\/jdk1.7.0_67.jdk\/Contents\/Home\s*$/)

  end
end

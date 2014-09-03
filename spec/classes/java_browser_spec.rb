require 'spec_helper'

describe "java::browser" do
  
  describe 'when not specifying ensure, or ensure => present' do

    it { should contain_file('/Library/Application Support/Oracle/Java/javaws').with({
      :ensure => 'link',
      :target => '/Library/Internet Plug-Ins/JavaAppletPlugin.plugin/Contents/Home/bin/_javaws',
    })}

    it { should contain_file('/Library/Application Support/Oracle/Java/Info.plist').with({
      :ensure => 'link',
      :target => '/Library/Internet Plug-Ins/JavaAppletPlugin.plugin/Contents/Enabled.plist',
    })}

  end


  describe 'when ensure => absent' do
    let (:params) {{:ensure => 'absent'}}

    it { should contain_file('/Library/Application Support/Oracle/Java/javaws').with({
      :ensure => 'absent',
    })}

    it { should contain_file('/Library/Application Support/Oracle/Java/Info.plist').with({
      :ensure => 'link',
      :target => '/Library/Internet Plug-Ins/JavaAppletPlugin.plugin/Contents/Disabled.plist',
    })}

  end

end

$user = 'amir'

Exec {
  path => ['/bin', '/usr/bin', '/sbin', '/usr/sbin'],
}

group { 'puppet':
  ensure => present,
}

exec { 'google-apt-key':
  command => 'wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -',
  unless  => 'apt-key list | grep google.com',
}

file { 'google-repo':
  path    => '/etc/apt/sources.list.d/google.list',
  content => 'deb http://dl.google.com/linux/chrome/deb/ stable main',
  require => Exec['google-apt-key'],
}

exec { 'apt-get update':
  require => File['google-repo'],
}

#http://mathforum.org/pow08/index.php/Vagrant
package {'vagrant':
  ensure => present,
}

#version control
package { ['git', 'subversion']:
  ensure  => present,
}

#browsers
package { ['chromium-browser', 'google-chrome-stable']:
  ensure  => present,
  require => Exec['apt-get update'],
}

#http://mathforum.org/pow08/index.php/GoodwinFileServer

#keyboard shortcuts

#printer

#dev tools: ant wireshark eclipse/sts yakuake vpp
package { ['ant', 'yakuake', 'wireshark', 'eclipse-platform', 'augeas-tools']:
  ensure => present,
}

#networking: wireless, vpn, resolv.conf

#adeona

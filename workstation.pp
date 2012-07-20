$user = 'amir'
$username = "Amir Tahvildaran"
$useremail = "amirdt22@gmail.com"

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
  require => [File['google-repo'], File['spotify-repo']],
}

#http://mathforum.org/pow08/index.php/Vagrant
package {'vagrant':
  ensure => present,
}

#version control
package { ['git', 'subversion']:
  ensure  => present,
}

file { "/home/$user/.gitconfig":
  content => "[user]\n\tname = $username\n\temail = $useremail\n",
}

#browsers
package { ['chromium-browser', 'google-chrome-stable']:
  ensure  => present,
  require => Exec['apt-get update'],
}

#http://mathforum.org/pow08/index.php/GoodwinFileServer

#keyboard shortcuts
package { ['xbindkeys', 'gmrun']:
  ensure => present,
}

file { "/home/$user/.xbindkeysrc":
  content => "\"/usr/bin/gmrun\"\n\tm:0x10 + c:68\n",
  owner   => $user
}

#printer

#dev tools: ant wireshark eclipse/sts yakuake vpp
package { ['ant', 'yakuake', 'wireshark', 'eclipse-platform', 'augeas-tools', 'firestarter', 'xchat']:
  ensure => present,
}

file { "/home/$user/.xchat2/servlist_.conf":
  require => Package['xchat'],
  content => template('servlist_.conf'),
}

#networking: wireless, vpn, resolv.conf

##adeona - TODO repackage as RPM/deb
#http://adeona.cs.washington.edu/packages/adeona-0.2.1.tar.gz
#exec { 'download-adeona':
#  command => 'wget -O /usr/local/src/adeona-0.2.1.tar.gz \
#              http://adeona.cs.washington.edu/packages/adeona-0.2.1.tar.gz',
#  creates => '/usr/local/src/adeona-0.2.1.tar.gz',
#}
#
#exec { 'extract-adeona':
#  command => 'tar -C /usr/local/ -zxf /usr/local/src/adeona-0.2.1.tar.gz',
#  creates => '/usr/local/adeona',
#  require => Exec['download-adeona'],
#}
#
#package { 'traceroute':
#  ensure => present,
#}
#
#package { 'libssl-dev':
#  ensure => present,
#}
#
#exec { 'install-adeona':
#  cwd     => '/usr/local/adeona',
#  command => 'sh configure && ',
#  require => [Package['libssl-dev'], Package['traceroute'], Exec['extract-adeona']],
#}

file { "/home/$user/.vimrc":
  content => "set expandtab\nset ts=2\n",
}

package { 'vim-gnome':
  ensure => present,
}

file { '/etc/profile.d/editor.sh':
  content => 'export EDITOR=/usr/bin/vim',
}

package { 'openssh-server':
  ensure => present,
}

exec { 'spotify-apt-key':
  command => 'apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 94558F59',
  unless  => 'apt-key list | grep spotify.com',
}

file { 'spotify-repo':
  path    => '/etc/apt/sources.list.d/spotify.list',
  content => 'deb http://repository.spotify.com stable non-free',
  require => Exec['spotify-apt-key'],
}

package { 'spotify-client':
  ensure  => present,
  require => Exec['apt-get update'],
}

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
package { ['ant', 'yakuake', 'wireshark', 'eclipse-platform', 'augeas-tools']:
  ensure => present,
}

#networking: wireless, vpn, resolv.conf

#adeona

file { "/home/$user/.vimrc":
  content => "set expandtab\nset ts=2\n",
}

package { 'vim-gnome':
  ensure => present,
}

file { '/etc/profile.d/editor.sh':
  content => 'export EDITOR=/bin/vim',
}

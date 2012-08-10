$user = 'amir'
$username = 'Amir Tahvildaran'
$useremail = 'amirdt22@gmail.com'

Exec {
  path => ['/bin', '/usr/bin', '/sbin', '/usr/sbin'],
}

group { 'puppet':
  ensure => present,
}

################################################################################
# browsers
################################################################################
package { ['chromium-browser', 'google-chrome-stable']:
  ensure  => present,
  require => Exec['apt-get update'],
}

################################################################################
# dev tools
################################################################################
###### TODO:sts vpp

###### JAVA
package { 'groovy':
  ensure => present,
}

###### VCS
package { ['git', 'subversion']:
  ensure  => present,
}

file { "/home/$user/.gitconfig":
  content => "[user]\n\tname = $username\n\temail = $useremail\n",
}

###### VIM
file { "/home/$user/.vimrc":
  content => "set expandtab\nset ts=2\n",
}

package { 'vim-gnome':
  ensure => present,
}

file { '/etc/profile.d/editor.sh':
  content => 'export EDITOR=/usr/bin/vim',
}



###### xchat

package { 'xchat':
  ensure => present,
}

file { "/home/$user/.xchat2/servlist_.conf":
  require => Package['xchat'],
  content => template('xchat-servers.conf'),
}

###### MISC
package { ['ant', 'yakuake', 'wireshark', 'eclipse-platform',
            'augeas-tools', 'firestarter']:
  ensure => present,
}

#http://mathforum.org/pow08/index.php/Vagrant
package {'vagrant':
  ensure => present,
}


################################################################################
# networking
################################################################################
service { 'network-manager':
  ensure => running,
}

file { '/etc/resolvconf/resolv.conf.d/tail':
  content => "search mathforum.org goodwin.drexel.edu\n",
  notify  => Service['network-manager'],
}

package { 'openssh-server':
  ensure => present,
}

file { "/home/$user/.ssh/config":
  content => template('sshconfig'),
  owner   => $user,
  group   => $user,
}

package { 'network-manager-vpnc': 
  ensure => present,
}

#TODO: wireless, vpn


################################################################################
# repos
################################################################################
exec { 'google-apt-key':
  command => 'wget -q -O - \
              https://dl-ssl.google.com/linux/linux_signing_key.pub \
              | sudo apt-key add -',
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

################################################################################
# MISC
################################################################################
package { ['xbindkeys', 'gmrun']:
  ensure => present,
}

file { "/home/$user/.xbindkeysrc":
  content => "\"/usr/bin/gmrun\"\n\tm:0x10 + c:68\n",
  owner   => $user
}

################################################################################
# TODO
# - printer
# - http://mathforum.org/pow08/index.php/GoodwinFileServer

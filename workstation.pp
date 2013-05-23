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
package { ['chromium-browser']:
  ensure  => present,
}

################################################################################
# dev tools
################################################################################

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
  content => template('vimrc'),
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

file { "/home/$user/.xchat2":
  ensure => directory,
}

file { "/home/$user/.xchat2/servlist_.conf":
  require => [Package['xchat'], File["/home/$user/.xchat2"]],
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


################################################################################
# MISC
################################################################################
package { ['gmrun', 'imagemagick', 'gtk-recordmydesktop', 'libav-tools', 'cheese']:
  ensure => present,
}

################################################################################
# TODO
################################################################################

notify { "TODO: software: STS & visual paradigm": }
notify { "TODO: printer set up": }
notify { "TODO: fileservers": }
# - http://mathforum.org/pow08/index.php/GoodwinFileServer
notify { "TODO: network: wireless & VPN": }

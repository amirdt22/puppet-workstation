puppet-workstation
==================

managing my (ubuntu) workstation via puppet

## get the files
 
If you already have git set up:

    git clone git@github.com:amirdt22/puppet-workstation.git
    cd puppet-workstation

Otherwise:

    wget https://github.com/amirdt22/puppet-workstation/archive/master.zip
    unzip puppet-workstation-master.zip
    cd puppet-workstation-master

## prep and apply

    sudo su
    apt-get install rubygems
    gem install puppet
    puppet apply --templatedir=templates workstation.pp

## Issues

* how to run xbindkeys
* scripts/templates/etc (./wr)
* ./wr script
* install spotify #see c97be19f00b9aa8c9bc34c3de225c9b15cbad4d2
* keepassx
* smbfs

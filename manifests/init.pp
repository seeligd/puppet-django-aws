# update package lists (ubuntu)
exec { "apt-get update":
	 command => "/usr/bin/apt-get update",
}

# initial packages to install; everything to get python built and running, git and some other utilities
# add anything here that you want that's not included in the default distro
$aptpackages = [ 
	 "build-essential", 
	 "python",
	 "python-dev", 
	 "python-setuptools", 
	 "python-pip", 
	 "python-software-properties",
	 "libmysqlclient-dev",
	 "screen",
	 "git",
	 "vim", 
	 "libjpeg-dev",
	 "libjpeg8",
	 "zlib1g-dev",
	 "libfreetype6-dev",
	 "libfreetype6",
	 ]

# make sure apt-get update is run before installing packages
package { $aptpackages: ensure => "installed", require => Exec['apt-get update'] }

# install the following packages with pip (python's installer)
$pippackages = [ 
	 "django", 
	 "south", 
	 "mysql-python==1.2.3",
	 "virtualenv",
]

package { $pippackages: ensure => "installed", provider => pip, require => Package["python-setuptools","python-pip","python-dev","build-essential"]}

# install python 2.6, which is was the AWS environment uses
exec { "install python2.6":
    command => "/usr/bin/add-apt-repository -y ppa:fkrull/deadsnakes; /usr/bin/apt-get update",
    require => Package["python-software-properties"],
    }

$python26packages = [ "python2.6", "python2.6-dev" ]

package {
    $python26packages:
    ensure => "installed",
	 require => Exec['install python2.6'],
}

# link up libraries so pip can find them (to install pil; http://jj.isgeek.net/2011/09/install-pil-with-jpeg-support-on-ubuntu-oneiric-64bits/ )
$uname = "i386-linux-gnu"
file { '/usr/lib/libfreetype.so': 
	 ensure => 'link',
	 target => "/usr/lib/${uname}/libfreetype.so"
}
file { '/usr/lib/libjpeg.so': 
	 ensure => 'link',
	 target => "/usr/lib/${uname}/libjpeg.so"
}
file { '/usr/lib/libz.so': 
	 ensure => 'link',
	 target => "/usr/lib/${uname}/libz.so"
}

# get the amazon tools
class {'aws::beanstalktools':}

# set up mysql with an empty database
class { 'mysql::server': 
  config_hash => { 'root_password' => 'foo' },
  require => Exec['apt-get update'],
}

# create djdb and add user with access
mysql::db { 'djdb':
  user     => 'djuser',
  password => 'djpass',
  host     => 'localhost',
  grant    => ['all'],
  require => Exec['apt-get update'],
}

# set up aliases (run python sever, etc)
class{ aliases: }

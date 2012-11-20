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

# get the amazon tools
class {'aws::beanstalktools':}

# set up mysql with an empty database
class { 'mysql::server': 
  config_hash => { 'root_password' => 'foo' }
}

# create djdb and add user with access
mysql::db { 'djdb':
  user     => 'djuser',
  password => 'djpass',
  host     => 'localhost',
  grant    => ['all'],
}


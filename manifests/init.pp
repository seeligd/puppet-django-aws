# update package lists
exec { "apt-get update":
	 command => "/usr/bin/apt-get update",
}

# initial packages to install
$aptpackages = [ 
	 "build-essential", 
	 "python",
	 "python-dev", 
	 "python-setuptools", 
	 "python-pip", 
	 "python-software-properties",
	 "libmysqlclient-dev",
	 "unzip",
	 "screen",
	 "git",
	 "vim", 
	 "wget",
	 ]

# make sure apt-get update is run before installing packages
package { $aptpackages: ensure => "installed", require => Exec['apt-get update'] }

# install the following packages with pip
$pippackages = [ "django", 
	 "south", 
	 "mysql-python==1.2.3",
	 "virtualenv",
]

package { $pippackages: ensure => "installed", provider => pip, require => Package["python-setuptools","python-pip","python-dev","build-essential"]}

# install python 2.6 (basically just to guarantee that aws will work)
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

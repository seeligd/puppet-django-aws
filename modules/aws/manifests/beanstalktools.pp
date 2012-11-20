class aws::beanstalktools($url='https://s3.amazonaws.com/elasticbeanstalk/cli', 
	 $package_name='AWS-ElasticBeanstalk-CLI-2.2', 
	 $installdir='/opt', 
	 $binpath='eb/linux/python2.7/eb') {

	 # make sure wget and unzip are installed
	 package { "wget": ensure  => "installed" }
	 package { "unzip": ensure  => "installed" }

	 # perform the wget and save the .zip in a temporary location
	 exec { "apps_wget_${package_name}":
		  command   => "/usr/bin/wget ${url}/${package_name}.zip -O /tmp/${package_name}.zip",
		  logoutput => on_failure,
		  creates   => "/tmp/${package_name}.zip",
		  require   => Package["wget"],
	 }

	 # unzip the file to /opt/ by default
	 exec {
			 "apps_unzip_${package_name}":
					 cwd     => $installdir,
					 command => "/usr/bin/unzip /tmp/${package_name}.zip",
					 creates => "${installdir}/${package_name}",
					 require =>  [ Package["unzip"], Exec["apps_wget_${package_name}"] ];
	 }

	 # link the file
	 file { '/usr/local/bin/eb': 
		  ensure => 'link',
		  target => "${installdir}/${package_name}/${binpath}"
	 }

}

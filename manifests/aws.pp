$apps_name = "AWS-ElasticBeanstalk-CLI-2.2"
package { "wget": ensure  => "installed" }
package { "unzip": ensure  => "installed" }

exec { "apps_wget_${apps_name}":
	 command   => "/usr/bin/wget https://s3.amazonaws.com/elasticbeanstalk/cli/${apps_name}.zip -O /tmp/${apps_name}.zip",
	 logoutput => on_failure,
	 creates   => "/tmp/${apps_name}.zip",
	 require   => Package["wget"],
}

exec {
      "apps_unzip_${apps_name}":
            cwd     => "/opt/",
            command => "/usr/bin/unzip /tmp/${apps_name}.zip",
            creates => "/opt/${apps_name}",
            require =>  [ Package["unzip"], Exec["apps_wget_${apps_name}"] ];
}

file { '/usr/local/bin/eb': 
	 ensure => 'link',
	 target => "/opt/${apps_name}/eb/linux/python2.7/eb"
}

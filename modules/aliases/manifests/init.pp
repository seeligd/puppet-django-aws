class aliases {
file { '/home/vagrant/.bash_aliases':
  ensure  => 'file',
  content => "alias prs='cd /app && python manage.py runserver 0.0.0.0:8000'\n",
  group   => '1000',
  mode    => '664',
  owner   => '1000',
}
}


file { '/etc/issue':
  ensure => present,
  content => "Hello World, this is the first Puppet Example",
  mode => '0644',
  owner => 'bigdata',
  group => 'bigdata',
  path => $issue_file_path,
}

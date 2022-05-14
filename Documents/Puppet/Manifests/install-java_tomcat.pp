class { 'java':
  package => 'java-1.8.0-openjdk-devel',
}

tomcat::install { '/opt/tomcat':
  source_url => 'https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.62/bin/apache-tomcat-9.0.62.tar.gz',
}

tomcat::instance { 'default':
  catalina_home => '/opt/tomcat',
}

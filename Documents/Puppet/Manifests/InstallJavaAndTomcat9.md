Installing Java & Tomcat 9 using Puppet

1. Install the Java Module on Puppet Master

    ```
    puppet module install puppetlabs-java
    ```

2. Edit site.pp file present in the Puppet manifests

    ```
    sudo vi /etc/puppet/manifests/site.pp
    ```

    ```
    class { 'java':
        package => 'java-1.8.0-openjdk-devel'
    }
    ```

3. Install Tomcat module on Puppet Master

    ```
    puppet module install puppetlabs-tomcat
    ```

4. Edit site.pp present in the Puppet manifests

    ```
    tomcat::install { '/opt/tomcat':
        source_url => 'https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.62/bin/apache-tomcat-9.0.62.tar.gz'
    }

    tomcat::instance { 'default':
        catalina_home => '/opt/tomcat'
    }
    ```

5. Login to Puppet Agent and execute the manifest

    ```
    ssh bigdata@192.168.0.153
    ```

    ```
    puppet agent --test --verbose
    ```
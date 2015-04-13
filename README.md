## Puppet modcluster module

Installs modcluster into an existing apache/httpd

Uses puppetlabs-apache

**Sample**:

    class { 'apache': }

    class { 'modcluster':
      download_url            => 'http://downloads.jboss.org/mod_cluster//1.2.6.Final/linux-x86_64/mod_cluster-1.2.6.Final-linux2-x64-so.tar.gz',
      listen_ip_address       => '*',
      allowed_network         => '10.2.255',
      balancer_name           => 'mybalancer',
      manager_allowed_network => '10.2.255'
    }

    Class['apache'] ->
      Class['modcluster'] ~>
        Service['httpd']

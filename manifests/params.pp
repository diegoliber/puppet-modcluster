class modcluster::params {

  $port = '6666'
  $listen_ip_address = '127.0.0.1'
  $allowed_network = '127.0.0.1'
  $balancer_name = 'mybalancer'
  $manager_allowed_network = '127.0.0.1'
  $download_url = undef
  $version = '1.2.6'

  $modules_dir = $::osfamily? {
    'Debian' => '/usr/lib/apache2/modules',
    'RedHat' => '/etc/httpd/modules',
    default => '/etc/httpd/modules'
  }

  $conf_file = $::osfamily? {
    'Debian' => '/etc/apache2/mods-available/modcluster.conf',
    'RedHat' => '/etc/httpd/conf.d/modcluster.conf',
    default => '/etc/httpd/conf.d/modcluster.conf'
  }

  $load_module_file = $::osfamily? {
    'Debian' => '/etc/apache2/mods-available/modcluster.load',
    default => undef,
  }

  $mem_manager_file = $::osfamily? {
    'Debian' => '/var/cache/apache2/manager.node',
    'RedHat' => '/etc/httpd/logs/manager.node',
    default => '/etc/httpd/logs/manager.node'
  }

}

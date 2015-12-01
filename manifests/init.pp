class modcluster(
  $port = $modcluster::params::port,
  $listen_ip_address = $modcluster::params::port,
  $allowed_network = $modcluster::params::allowed_network,
  $balancer_name = $modcluster::params::balancer_name,
  $manager_allowed_network = $modcluster::params::manager_allowed_network,
  $download_url = $modcluster::params::download_url,
  $modules_dir = $modcluster::params::modules_dir,
  $mem_manager_file = $modcluster::params::mem_manager_file,
  $version = $modcluster::params::version
) inherits modcluster::params {

  $file_name = inline_template('<%= require \'uri\'; File.basename(URI::parse(@download_url).path) %>')

  wget::fetch { "Download modcluster ${download_url}":
    source      => $download_url,
    destination => "/opt/${file_name}",
    cache_dir   => '/var/cache/wget',
    cache_file  => $file_name,
    notify      => Exec['Extract modcluster']
  }

  exec { 'Extract modcluster':
    command     => "tar -xzf /opt/${file_name}",
    cwd         => "${modules_dir}",
    creates     => "${modules_dir}/mod_proxy_cluster.so",
    group       => 'root',
    user        => 'root',
    path        => ['/usr/bin', '/usr/sbin', '/bin', '/sbin']
  }

  file { "${modcluster::params::conf_file}":
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    content => template('modcluster/modcluster.conf.erb'),
    mode    => '0755',
    require => Exec['Extract modcluster']
  }

  if $::osfamily == 'Debian' {
    file { "${modcluster::params::load_module_file}":
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      content => template('modcluster/modcluster.load.erb'),
      mode    => '0755',
      require => File["${modcluster::params::conf_file}"]
}

    exec { 'Enable modcluster module':
      command     => "a2enmod modcluster",
      cwd         => '/etc/apache2',
      creates     => "/etc/apache2/mods-enabled/modcluster.load",
      group       => 'root',
      user        => 'root',
      path        => ['/usr/bin', '/usr/sbin', '/bin', '/sbin'],
      require     => File["${modcluster::params::load_module_file}"],
    }
  }


}

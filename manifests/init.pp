class modcluster(
  $port = '6666',
  $listen_ip_address = '127.0.0.1',
  $allowed_network = '127.0.0.1',
  $balancer_name = 'mybalancer',
  $manager_allowed_network = '127.0.0.1',
  $download_url = undef,
) {

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
    cwd         => '/etc/httpd/modules',
    creates     => "/etc/httpd/modules/mod_proxy_cluster.so",
    group       => 'root',
    user        => 'root',
    path        => ['/usr/bin', '/usr/sbin', '/bin', '/sbin']
  }

  file { '/etc/httpd/conf.d/modcluster.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    content => template('modcluster/modcluster.conf.erb'),
    mode    => '0755',
    require => Exec['Extract modcluster']
  }

}
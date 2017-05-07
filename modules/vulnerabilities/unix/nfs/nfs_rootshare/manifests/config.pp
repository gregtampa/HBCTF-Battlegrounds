class nfs_rootshare::config {

  # Setup HBCTF-Battlegrounds Parameters
  $json_inputs = base64('decode', $::base64_inputs)
  $HBCTF-Battlegrounds_parameters=parsejson($json_inputs)
  $leaked_filenames=$HBCTF-Battlegrounds_parameters['leaked_filenames']
  $strings_to_leak=$HBCTF-Battlegrounds_parameters['strings_to_leak']
  $images_to_leak=$HBCTF-Battlegrounds_parameters['images_to_leak']

  package { ['nfs-kernel-server', 'nfs-common', 'portmap']:
      ensure => installed
  }

  file { '/etc/exports':
    require => Package['nfs-common'],
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0777',
    content  => template('nfs_rootshare/exports.erb')
  }

  exec { "exportfs":
      require => Package['nfs-common'],
      command => "exportfs -a",
      path    => "/usr/sbin",
      # path    => [ "/usr/local/bin/", "/bin/" ],  # alternative syntax
  }

  ::HBCTF-Battlegrounds_functions::leak_files { 'nfs_rootshare-file-leak':
    storage_directory => '/root',
    leaked_filenames => $leaked_filenames,
    strings_to_leak => $strings_to_leak,
    images_to_leak => $images_to_leak,
    leaked_from => "nfs_rootshare",
  }
}



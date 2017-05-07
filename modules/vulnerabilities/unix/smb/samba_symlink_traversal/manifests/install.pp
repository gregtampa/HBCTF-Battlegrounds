class samba_symlink_traversal::install {
  include samba

  $json_inputs = base64('decode', $::base64_inputs)
  $HBCTF-Battlegrounds_parameters = parsejson($json_inputs)
  $storage_directory = $HBCTF-Battlegrounds_parameters['storage_directory'][0]
  $leaked_filenames = $HBCTF-Battlegrounds_parameters['leaked_filenames']
  $strings_to_leak = $HBCTF-Battlegrounds_parameters['strings_to_leak']
  $images_to_leak = $HBCTF-Battlegrounds_parameters['images_to_leak']
  $symlink_traversal = true

  # Ensure the storage directory exists
  file { $storage_directory:
    ensure => directory,
    mode   => '777',
  }

  # Add store to .conf
  file { '/etc/samba/smb_symlink.conf':
    ensure => file,
    content => template ('samba/smb_share.conf.erb')
  }
  concat { '/etc/samba/smb.conf':
    ensure => present,
  }
  concat::fragment { 'smb-conf-base':
    source => '/etc/samba/smb.conf',
    target => '/etc/samba/smb.conf',
    order => '01',
  }
  concat::fragment { 'smb-conf-public-share-definition':
    source => '/etc/samba/smb_symlink.conf',
    target => '/etc/samba/smb.conf',
    order => '02',
  }

  # Insert the 'allow insecure wide links = yes' line into the [global] section of smb.conf
  exec { 'sed-insert-global-allow-insecure-wide-links':
    command => "/bin/sed -i \'/\\[global\\]/a allow insecure wide links = yes\' /etc/samba/smb.conf"
  }

  # Leak a flag/string to root directory
  ::HBCTF-Battlegrounds_functions::leak_files { 'samba_symlink_traversal-file-leak-2':
    storage_directory => '/',
    leaked_filenames  => [$leaked_filenames[0]],
    strings_to_leak   => [$strings_to_leak[0]],
    leaked_from       => 'samba_symlink_traversal',
  }

  if ($strings_to_leak.size > 1) {
    # Leak a flag/string to the samba share directory
    ::HBCTF-Battlegrounds_functions::leak_files { 'samba_symlink_traversal-file-leak-1':
      storage_directory => $storage_directory,
      leaked_filenames  => [$leaked_filenames[1]],
      strings_to_leak   => [$strings_to_leak[1]],
      images_to_leak    => $images_to_leak,
      leaked_from       => 'samba_symlink_traversal',
    }
  }
}
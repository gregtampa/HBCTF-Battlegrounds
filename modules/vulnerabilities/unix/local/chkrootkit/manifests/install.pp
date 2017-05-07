class chkrootkit::install {
  Exec { path => ['/bin', '/usr/bin', '/usr/local/bin', '/sbin', '/usr/sbin'] }
  $json_inputs = base64('decode', $::base64_inputs)
  $HBCTF-Battlegrounds_parameters = parsejson($json_inputs)
  $leaked_filenames = $HBCTF-Battlegrounds_parameters['leaked_filenames']
  $strings_to_leak = $HBCTF-Battlegrounds_parameters['strings_to_leak']
  $archive = 'chkrootkit-0.49.tar.gz'

  file { "/usr/local/$archive":
    ensure => file,
    source => "puppet:///modules/chkrootkit/$archive",
  }

  exec { 'unpack-chkrootkit':
    cwd     => '/usr/local/',
    command => "tar -xzf $archive",
  }

  exec { 'make-chkrootkit':
    cwd => '/usr/local/chkrootkit-0.49/',
    command => 'make sense',
  }

  file { '/usr/sbin/chkrootkit':
    ensure => 'link',
    target => '/usr/local/chkrootkit-0.49/chkrootkit'
  }

  exec { "remove-$archive":
    require => Exec['unpack-chkrootkit'],
    command => "rm /usr/local/$archive",
  }

  # Leak a file containing a string/flag to /root/
  ::HBCTF-Battlegrounds_functions::leak_files { 'chkrootkit-file-leak':
    storage_directory => '/root',
    leaked_filenames => $leaked_filenames,
    strings_to_leak => $strings_to_leak,
    leaked_from => "chkrootkit_vuln",
  }
}
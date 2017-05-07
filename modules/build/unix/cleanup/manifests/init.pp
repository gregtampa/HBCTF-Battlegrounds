class cleanup::init {
  $json_inputs = base64('decode', $::base64_inputs)
  $HBCTF-Battlegrounds_params = parsejson($json_inputs)
  $remove_history = str2bool($HBCTF-Battlegrounds_params['remove_history'][0])
  $root_password = $HBCTF-Battlegrounds_params['root_password'][0]
  $clobber_file_times = str2bool($HBCTF-Battlegrounds_params['clobber_file_times'][0])
  $disable_ssh = str2bool($HBCTF-Battlegrounds_params['disable_ssh'][0])

  Exec { path => ['/bin','/sbin','/usr/bin', '/usr/sbin'] }

  # Set root password
  ::accounts::user { 'root':
    shell      => '/bin/bash',
    password   => pw_hash($root_password, 'SHA-512', 'mysalt'),
    managehome => true,
  }

  # Disable ssh
  if $disable_ssh {
    service { 'ssh':
      enable => false,
    }
  }

  # Reset all system file access times to hide our tracks
  if $clobber_file_times {
    notice 'Clobbering file access times -- This may take a while...'
    exec { 'clobber_files':
      command => "find / -exec touch -d '17 May 2006 14:16' {} \\;",
    }
  }

  # removes bash history
  if $remove_history {
    exec { 'remove_history':
      command => "/bin/bash -c 'history -c && history -w'"
    }
  }
}
class two_shell_calls::init {
  $json_inputs = base64('decode', $::base64_inputs)
  $HBCTF-Battlegrounds_parameters = parsejson($json_inputs)

  group { 'managers':
    ensure => 'present',
  }

  $accounts = $HBCTF-Battlegrounds_parameters['accounts']
  $accounts.each |$raw_account| {
    $account  = parsejson($raw_account)
    $username = $account['username']
    two_shell_calls::account { "two_shell_calls_$username":
      username         => $username,
      password         => $account['password'],
      strings_to_leak  => $account['strings_to_leak'],
      leaked_filenames => $account['leaked_filenames']
    }
  }
}
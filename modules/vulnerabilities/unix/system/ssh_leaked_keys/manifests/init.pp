class ssh_leaked_keys::init {
  $json_inputs = base64('decode', $::base64_inputs)
  $HBCTF-Battlegrounds_parameters = parsejson($json_inputs)
  $strings_to_leak = $HBCTF-Battlegrounds_parameters['strings_to_leak']

  $accounts = $HBCTF-Battlegrounds_parameters['accounts']
  $accounts.each |$raw_account| {
      $account = parsejson($raw_account)
      $username = $account['username']
      ssh_leaked_keys::account { "ssh_leaked_keys_$username":
        username         => $username,
        password         => $account['password'],
        strings_to_leak  => $strings_to_leak,
        leaked_filenames => $account['leaked_filenames'],
        ssh_key_pair     => parsejson($HBCTF-Battlegrounds_parameters['ssh_key_pair'][0]),
      }
    }
}
class parameterised_accounts::init {
  $json_inputs = base64('decode', $::base64_inputs)
  $HBCTF-Battlegrounds_parameters = parsejson($json_inputs)

  $accounts = $HBCTF-Battlegrounds_parameters['accounts']
  $accounts.each |$raw_account| {
      $account = parsejson($raw_account)
      $username = $account['username']
      parameterised_accounts::account { "parameterised_$username":
        username        => $username,
        password        => $account['password'],
        super_user      => str2bool($account['super_user']),
        strings_to_leak => $account['strings_to_leak'],
        leaked_filenames => $account['leaked_filenames']
      }
    }
}
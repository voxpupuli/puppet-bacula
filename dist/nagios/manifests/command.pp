class nagios::command {

        nagios_command { 
          'check_ssh':
            command_line => '$USER1$/check_ssh -p $ARG1$ $HOSTADDRESS$';
          'check_http':
            command_line => '$USER1$/check_http -p $ARG1$ -H $HOSTADDRESS$ -I $HOSTADDRESS$';
          'check_dig':
            command_line => '$USER1$/check_dig -H $HOSTADDRESS$ -l $ARG1$ --record_type=$ARG2$';
          'check_ntp':
            command_line => '$USER1$/check_ntp -H $HOSTADDRESS$ -w 0.5 -c 1';
          'check_http_url':
            command_line => '$USER1$/check_http -H $ARG1$ -u $ARG2$';
          'check_http_url_regex':
            command_line => '$USER1$/check_http -H $ARG1$ -u $ARG2$ -e $ARG3$';
          'check_https_url':
            command_line => '$USER1$/check_http --ssl -H $ARG1$ -u $ARG2$';
          'check_https_url_regex':
            command_line => '$USER1$/check_http --ssl -H $ARG1$ -u $ARG2$ -e $ARG3$';
          'check_https':
            command_line => '$USER1$/check_http -S -H $HOSTADDRESS$';
        }
    
        Nagios_command <<||>>
}

Only works with passphrase-less ssh keys
Ports must be manually added to docker compose file, except if netmode host
Format of the conf file:

<Listening-Address>:<LHS-Port>:<Host-interface-adress>:<Host-port>

Listening-address should most likely NOT be localhost but ::0, 0.0.0.0, *, or a specific interface

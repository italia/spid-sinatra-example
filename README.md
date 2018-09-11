# Applicazione esempio con spid-sinatra

Questa applicazione è un esempio di come è possibile utilizzare la gem `spid-sinatra` utilizzando come supporto il [testenv2](https://github.com/italia/spid-testenv2)

## Installazione

### Preparazione DNS
Per poter far funzionare correttamente l'applicazione è necessario impostare in `/etc/hosts` i nomi DNS corretti. Aggiungete al file le seguenti righe
```
127.0.0.1 sp.local
127.0.0.1 idp.local
```

### Applicazione Sinatra

Clona questo repository ed entra nella directory
```bash
$ git clone git@github.com:italia/spid-sinatra-example.git
$ cd spid-sinatra-example
```

Genera una chiave privata con un certificato self-signed
```bash
$ openssl req -x509 -nodes -sha256 -subj '/C=IT' -newkey rsa:4096 -keyout spid-private-key.pem -out spid-certificate.pem
```

Avvia il server con

```bash
bundle exec ruby spid-app.rb
```

### Testenv2
In un altro terminale, clona il repository [testenv2](https://github.com/italia/spid-testenv2)
```bash
$ git clone git@github.com:italia/spid-testenv2.git
$ cd spid-testenv2
```

e segui le istruzioni per l'installazione manuale e configurazione

Nel file di configurazione decommenta queste righe nella sezione  `metadata`
```yaml
metadata:
  local:
    - "./conf/sp_metadata.xml"
```

Infine è necessario scaricare localmente il metadata del service provider
```bash
$ wget http://sp.local/spid/metadata -O conf/sp_metadata.xml
```

a questo punto è possibile avviare il server relativo all'identity provider con
```bash
$ python spid-testenv.py
```

### Completamento configurazione Sinatra
Ora che l'identity provider ha una copia del metadata del service provider, bisogna fornire al service provider il metadata dell'identity provider.

Per fare questo, usare questo comando
```bash
$ wget http://idp.local/metadata -O idp_metadata/idp-test-metadata.xml
```

Adesso possiamo avviare nuovamente il server con
```bash
$ bundle exec ruby spid-app.rb
```

e visitare la [pagina iniziale](http://sp.local) del service provider di prova.


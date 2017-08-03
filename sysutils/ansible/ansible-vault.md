

```
gpg --gen-key
```


```
pwgen -n 128 -N 1 -s | gpg --armor --recipient <GPG ID> -e -o vault_passphrase.gpg
```


vault.bash
```
#!/usr/bin/env bash
gpg --batch --use-agent --decrypt vault_passphrase.gpg
```

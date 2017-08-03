

```
gpg --gen-key
```


```
pwgen -n 128 -N 1 -s | gpg --armor --recipient <GPG ID> -e -o vault_passphrase.gpg
```

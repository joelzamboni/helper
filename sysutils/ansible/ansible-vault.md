

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

### Mac GPG agent

Create `~/.bash_gpg_agent`
```
envfile="${HOME}/.gnupg/gpg-agent.env"
 
if test -f "$envfile" && kill -0 $(grep GPG_AGENT_INFO "$envfile" | cut -d: -f 2) 2>/dev/null; then
    eval "$(cat "$envfile")"
else
    eval "$(gpg-agent --daemon --log-file=~/.gpg/gpg.log --write-env-file "$envfile")"
fi
export GPG_AGENT_INFO  # the env file does not contain the export statement
```

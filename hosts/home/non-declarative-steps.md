# Necessary, Non-declarative Configuration Steps

### Set up github auth
1. Run `ssh-keygen -f ~/.ssh/github -C "<your_github@email.com>"` to generate public key
2. Add new key to `https://www.github.com/settings/keys`

### Update macbook ssh configuration
1. On macbook, run `ssh-keygen -R <HostNameForOldConnection>` to remove the old keys
2. Ensure that `~/.ssh/config` still has accurate `HostName`, `Port`, and `User` settings
3. Run `ssh nixos-local` and `ssh nixos-remote` to connect, making the new keys
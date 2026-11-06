---
name: op-secret
description: Add a new secret to the 1Password-based secret workflow (.env.tpl + op inject cache). Use when the user wants to register a new environment variable secret, API key, or token.
---

# Add a secret via 1Password

Secrets are managed with 1Password CLI (`op`) using a committed template
(`.env.tpl` in the dotfiles repo) and a local cache (`~/.cache/op_env_cache`).
Never write the secret value itself to any file.

## Steps

1. **Confirm the item path.** Ask the user for the 1Password item name, or help
   them find it (vault: `Private`, account: `my.1password.com`):

   ```bash
   op item list --account=my.1password.com | grep -i <keyword>
   ```

   Do NOT read the secret value (`op read` is denied by permissions).

2. **Add the reference to `.env.tpl`** in the dotfiles repo
   (`~/src/github.com/nsega/dotfiles/.env.tpl` or `~/dotfiles/.env.tpl`):

   ```
   export MY_SECRET={{ op://Private/<item-name>/<field> }}
   ```

   The field is usually `password` or `credential`.

3. **Ask the user to refresh the cache** by running `op-reload` in their own
   shell. It is a zsh function that triggers a Touch ID prompt, so it cannot be
   run from here.

4. Remind the user that `.env.tpl` is safe to commit (it contains references
   only), and offer to commit it.

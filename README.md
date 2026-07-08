# dotfiles

Topic-based dotfiles (Holman/thoughtbot style). Any file named `*.symlink` is
linked into `$HOME` by `script/bootstrap` — e.g. `zsh/zshrc.symlink` → `~/.zshrc`,
`alacritty/alacritty.toml.symlink` → `~/.alacritty.toml`.

## Install

```sh
git clone <this-repo> ~/.dotfiles
cd ~/.dotfiles
DRY_RUN=1 script/bootstrap   # preview: print what would be linked, change nothing
script/bootstrap             # link everything (prompts before touching existing files)
```

`script/bootstrap` also creates the two links that don't use the `*.symlink`
convention — `~/.config/nvim/init.vim` and `~/.gnupg/gpg-agent.conf` — and creates
missing parent directories. **It contains and generates no identity.**

## Identity — lives ONLY in untracked `$HOME` files

Author identity and commit signing are never committed. The root `.gitignore`
matches `*.identity` and `*.local`, so these files can never be committed even if
they end up inside the repo directory. The tracked, public `git/gitconfig.symlink`
contains no identity — its only identity-related line is:

```ini
[include]
    path = ~/.gitconfig.identity
```

On a new machine, recreate the following untracked files in `$HOME` (replace every
`<...>` placeholder):

### Git

**`~/.gitconfig.identity`** — your default identity plus, for each work context, a
per-directory *conditional include* (see `git help config` → **"Conditional
includes"**). Each matches on the repo location (`gitdir:~/Code/<org>/`) and pulls
in a per-context override file:

```ini
[user]
    name  = <Your Name>
    email = <personal-default-email>

; Then one directory-conditional include per context <org>. Use git's one-word
; conditional-include keyword (see the man page) with condition and target:
;   <conditional-include> "gitdir:~/Code/<org>/"   ->   path = ~/.gitconfig.<org>.local
```

**`~/.gitconfig.<org>.local`** — one per context, each holding that context's
identity and (optionally) signing. Set `[user] name`/`email`, your GPG key id via
git's `user` signing-key setting, and enable `[commit] gpgsign`:

```ini
[user]
    name  = <Your Name>
    email = <context-email>
    ; <user-signing-key-setting> = <GPG-KEY-ID>
[commit]
    gpgsign = true
```

Signing is per context — leave it off (`gpgsign = false`, no key) where you don't
sign. A key that has expired will make `git commit` fail to sign until renewed.

### Jujutsu (jj)

jj identity lives in the untracked `~/.config/jj/config.toml` (the jj analog of the
`.local` overrides — not committed, not symlinked). Set a personal default and
override per path with jj's native `[[--scope]]` blocks; add signing where wanted:

```toml
#:schema https://docs.jj-vcs.dev/latest/config-schema.json

[user]
name = "<Your Name>"
email = "<personal-default-email>"

[signing]
backend = "gpg"
behavior = "own"
key = "<personal-GPG-KEY-ID>"

[[--scope]]
--when.repositories = ["~/Code/<org>"]
[--scope.user]
email = "<context-email>"
[--scope.signing]
key = "<context-GPG-KEY-ID>"   # or: behavior = "drop" to leave this context unsigned
```

### Claude Code

`~/.claude/settings.json` is symlinked from `claude/settings.json` (a nested link,
so `script/bootstrap` handles it specially rather than via the `*.symlink` rule).
One private plugin marketplace is intentionally kept out of this public repo. On a
new machine it's preserved in the untracked `~/.claude/private-marketplaces.local.json`;
re-add it where needed as a project-level `.claude/settings.local.json` override.

> Note: Claude Code rewrites `~/.claude/settings.json` when you change settings via
> the app, so review `git diff` before committing — don't let a private marketplace
> or other machine-specific value slip into the public repo.

## Layout

```
alacritty/  claude/  docker/  git/  gnupg/  go/  jj/  rust/  tmux/  vim/  zsh/  1password/
bin/  functions/  script/                                 # helpers + bootstrap
```

Tool PATH entries live in per-topic `path.zsh` files (`go/`, `rust/`), loaded in
zshrc's first pass; `zsh/path.zsh` holds the base PATH and dedupes via `typeset -U`.

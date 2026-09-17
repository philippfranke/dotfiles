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

`script/bootstrap` also creates the links that don't use the `*.symlink`
convention — `~/.config/nvim/init.vim`, `~/.gnupg/gpg-agent.conf`,
`~/.claude/settings.json`, `~/.config/gh/config.yml` and `~/.ssh/config` — and creates missing
parent directories. **It contains and generates no identity.**

## Identity — lives ONLY in untracked `$HOME` files

Author identity and commit signing are never committed. The root `.gitignore`
matches `*.identity`, `*.local` and the usual key/token file names, so `git add`
skips them if they end up inside the repo directory. That is a guard against
accidents, not a lock: `git add -f` bypasses it, so a tracked pre-commit hook
scans staged changes as a second line of defence (see "Commit safety net"). The
tracked, public `git/gitconfig.symlink` contains no identity — its only
identity-related line is:

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
sign. A key that has expired will make `git commit` fail to sign until renewed —
gpg reports this as `signing failed: No secret key`, which means *no usable* key,
not a missing one.

To renew, run `script/rotate-signing-key` (`--help` for options, `DRY_RUN=1` to
preview). It issues a new signing subkey and repoints every `$HOME` identity file —
git *and* jj — at the new key id. Like `script/bootstrap` it holds no identity: the
primary key and the files to update are discovered at runtime. It needs the primary
key's secret, which is normally kept offline (`sec#` in `gpg -K`), so import your
backup first and pass `--restub` to put it back offline afterwards.

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

### 1Password

`1password/op.zsh` wraps `claude` so Claude Code starts via `op run`: secrets are
pulled from 1Password at launch and injected into the `claude` process's
environment — nothing in the repo, nothing exported in the interactive shell.
Everything Claude spawns (Bash tool calls, hooks, MCP servers) inherits that
environment. That is the point for a `GITHUB_TOKEN`, but it also means any
command Claude runs can read every injected secret, so only inject what the
session actually needs. The wrapper is a plain pass-through until you create the
untracked env file:

```sh
cp ~/.dotfiles/1password/claude.env.example ~/.config/op/claude.env
chmod 600 ~/.config/op/claude.env   # then fill in op://<vault>/<item>/<field> references
```

The real file stays out of the repo because it names your vaults and items.
Override its location with `CLAUDE_OP_ENV_FILE`. The same file also sources the
`op plugin init` shims from `~/.config/op/plugins.sh` when present.

`1password/ssh_config` is linked to `~/.ssh/config` and routes every host through
the 1Password SSH agent (`IdentityAgent`), so private keys live in 1Password rather
than in `~/.ssh`. Enable the agent in 1Password → Settings → Developer on a new
machine. Auth material (`known_hosts`, any leftover keys) stays untracked.

The tracked file holds only the wildcard. Host-specific entries (work hosts,
aliases, ports, users) go in the untracked `~/.ssh/config.local`, which the
tracked file `Include`s above `Host *` so its settings take precedence. Create it
with `chmod 600`; ssh ignores it silently when it is absent.

## Commit safety net

This repo is public, so two layers guard against committing something private:

1. **Ignore rules** — the root `.gitignore` covers identity overrides, key and
   certificate files, token stores and env files. They only stop an unforced
   `git add`.
2. **Pre-commit hook** — `.githooks/pre-commit`, enabled per-repo by
   `script/bootstrap` via `git config core.hooksPath .githooks` (no global hook
   path, so other repos' hooks are untouched). It rejects a commit when:
   - [gitleaks](https://github.com/gitleaks/gitleaks) finds a credential in the
     staged diff (`brew install gitleaks`, or drop the release binary in
     `~/.local/bin`; skipped with a warning if missing), or
   - any added line or staged path matches a pattern in the untracked
     `~/.config/dotfiles/denylist` — one extended regex per line, `#` comments
     allowed, matched case-insensitively. Put work-org names, internal
     hostnames and vault names there: exactly the strings that must never appear
     in this repo and therefore cannot be listed in it.

   A companion `.githooks/commit-msg` hook runs the same deny-list over the
   commit message, since an org name in a subject line is just as public.

   `git commit --no-verify` bypasses both hooks; use it knowingly.

Also turn on GitHub's *push protection for yourself* (Settings → Code security)
as a free server-side backstop for known token formats.

## GitHub CLI (gh)

`gh` is the GitHub client (it replaced `hub`; `git` is no longer aliased).
Tracked settings — `git_protocol: ssh`, aliases — live in `gh/config.yml`,
linked to `~/.config/gh/config.yml`. `gh config set` / `gh alias set` write
through that link, so changes show up as a repo diff. Auth lives in the
untracked `~/.config/gh/hosts.yml` (never commit it); run `gh auth login`
once per machine, then `gh auth setup-git` so gh also serves git's https
credentials (already wired in `git/gitconfig.symlink`). A per-host
`git_protocol` in `hosts.yml` overrides the tracked default.

## Layout

```
alacritty/  claude/  docker/  gh/  git/  gnupg/  go/  homebrew/  jj/  rust/  tmux/  vim/  zsh/  1password/
bin/  functions/  script/                                 # helpers + bootstrap
```

### Shell env vs interactive config

Environment/PATH and interactive config are deliberately split (standard zsh convention):

- **`~/.zshenv`** (`zsh/zshenv.symlink`) is sourced by *every* zsh — including the
  non-interactive `zsh -c` that nvim's `:!`/`system()`, tmux's server, and GUI-launched
  apps spawn. It sources the per-topic `path.zsh` files (`homebrew/`, `go/`, `rust/`,
  `zsh/`), so Homebrew (`brew shellenv`), `GOPATH` and the tool bin dirs (`~/.go/bin`,
  `~/.cargo/bin`, `~/.local/bin`) are set everywhere — not just in interactive shells.
  There is deliberately no `~/.zprofile`: it only runs for login shells.
- **`~/.zshrc`** re-sources those `path.zsh` files in its first pass so the intended
  order survives macOS `/etc/zprofile` `path_helper` reordering on login shells, then
  loads the interactive-only bits (aliases, prompt, completion). `typeset -U` keeps the
  double-sourcing duplicate-free.

# dotfiles

Shell configuration and tooling scripts for working with AWS SSO and Kubernetes on the Analytical Platform, designed for use in VS Code Dev Containers.

## Contents

| File | Description |
|------|-------------|
| `install.sh` | Main dotfile: sets up aliases and a dynamic zsh prompt |
| `sso_switch.sh` | Interactive AWS SSO profile switcher |
| `k8s_switch.sh` | Interactive Kubernetes context switcher |
| `runme.sh` | Dev container bootstrap script |

---

## Features

### Shell Prompt (`install.sh`)

A dynamic zsh prompt that shows your current context at a glance:

- **Git branch** — displays the current branch name, with a `✗` indicator if there are uncommitted changes
- **Kubernetes context** — shows the current cluster and namespace, colour-coded by environment:
  - 🟢 Green — `development` / `sandbox`
  - 🔵 Blue — `test`
  - 🟡 Yellow — `preproduction`
  - 🔴 Red — `production`
- **AWS SSO profile** — shows the active AWS role, colour-coded by environment using the same scheme above

Labels are automatically shortened for readability (e.g. `analytical-platform-development` → `dev`, `AdministratorAccess` → `Admin`).

### Aliases

| Alias | Expands to |
|-------|-----------|
| `k` | `kubectl` |
| `profile` | Lists AWS SSO profiles filtered to `dev`, `test`, `prod` admin roles |
| `eks` | Lists Kubernetes contexts filtered to `development`, `test`, `production` |
| `k8s` | Runs `k8s_switch.sh` — interactive context switcher |
| `sso` | Runs `sso_switch.sh` — interactive SSO profile switcher |

### `sso_switch.sh` — AWS SSO Profile Switcher

Presents a numbered menu of available AWS SSO profiles (filtered to `dev`, `test`, `prod` admin roles, excluding `qs-admin`). Selecting a profile clears any existing AWS environment variables and opens a new shell session authenticated with that profile.

### `k8s_switch.sh` — Kubernetes Context Switcher

Presents a numbered menu of all available `kubectl` contexts. Selecting one runs `kubectl config use-context` to switch your active cluster.

### `runme.sh` — Dev Container Bootstrap

Sourced during dev container creation. It:
1. Adds `install.sh` to `.zshrc` so the dotfile loads in every interactive shell
2. Downloads the Analytical Platform kubeconfig to `~/.kube/config`

---


## VS Code Dev Containers Setup

To automatically apply these dotfiles in any VS Code Dev Container or GitHub Codespace, add the following to your VS Code `settings.json`:

```json
{
  "dotfiles.repository": "https://github.com/<your-username>/dotfiles",
  "dotfiles.targetPath": "~/dotfiles",
  "dotfiles.installCommand": "~/dotfiles/runme.sh"
}
```

Replace `<your-username>` with your GitHub username, or use the full repository URL if it's in a GitHub organisation.


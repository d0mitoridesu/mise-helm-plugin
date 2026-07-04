# mise-helm-plugin

A [mise](https://mise.jdx.dev) backend plugin for managing [Helm plugins](https://helm.sh/docs/topics/plugins/) as versioned tools.

Helm plugins installed through this backend are version-pinned and reproducible across machines, just like any other tool in your `mise.toml`.

## Requirements

- [mise](https://mise.jdx.dev/getting-started.html) installed
- `helm` available — either managed by mise or already on your PATH

## Quick start

```toml
[plugins]
helm-plugin = "https://github.com/d0mitoridesu/mise-helm-plugin"

[env]
_.helm-plugin = { tools = true }

[tools]
helm = "4.2.2"
"helm-plugin:databus23/helm-diff" = { version = "3.15.10", depends = "helm", verify = false }
```

```bash
mise install
```

## Installation

Add the plugin and your first helm plugin to `mise.toml`:

```toml
[plugins]
helm-plugin = "https://github.com/d0mitoridesu/mise-helm-plugin"
```

Then run:

```sh
mise install
```

To activate `HELM_PLUGINS` automatically in your shell environment, add the env module to your `mise.toml`:

```toml
[env]
_.helm-plugin = { tools = true }
```

This makes all installed helm plugins visible to `helm` without any extra shell setup.

## Usage

Tools follow the format `helm-plugin:<owner>/<repo>@<version>`.

### Install a plugin

```sh
mise use helm-plugin:databus23/helm-diff@3.15.10
```

### Install the latest version

```sh
mise use helm-plugin:databus23/helm-diff@latest
# OR
mise use helm-plugin:databus23/helm-diff
```

### List available versions

```sh
mise ls-remote helm-plugin:databus23/helm-diff
```

### Pin plugins in mise.toml

If you manage `helm` with mise, declare it as a dependency so it is guaranteed to be installed before any helm plugin.

```toml
[env]
_.helm-plugin = { tools = true }

[tools]
helm = "latest"
"helm-plugin:databus23/helm-diff"         = { version = "3.15.10", depends = "helm" }
"helm-plugin:helm-unittest/helm-unittest" = { version = "1.1.1", depends = "helm" }
```

Then install everything with:

```sh
mise install
```

## Examples

### helm-diff

[helm-diff](https://github.com/databus23/helm-diff) shows a diff between the current release and a pending `helm upgrade`.

```toml
[env]
_.helm-plugin = { tools = true }

[tools]
helm = "latest"
"helm-plugin:databus23/helm-diff" = "3.15.10"
```

```sh
mise install
helm diff upgrade my-release ./my-chart --values values.yaml
```

### helm-unittest

[helm-unittest](https://github.com/helm-unittest/helm-unittest) runs unit tests for Helm charts.

```toml
[env]
_.helm-plugin = { tools = true }

[tools]
helm = "latest"
"helm-plugin:helm-unittest/helm-unittest" = "1.1.1"
```

```sh
mise install
helm unittest ./my-chart
```

### Skipping GPG verification

Some plugins do not support GPG signature verification. Pass `verify = "false"` to skip it:

```toml
[tools]
"helm-plugin:databus23/helm-diff" = { version = "3.15.10", verify = "false" }
```

## CI

In CI, run `mise install` to install all tools and helm plugins declared in `mise.toml`, then `mise env` to export the resulting environment (including `HELM_PLUGINS`) to subsequent steps.

```bash
mise install
eval "$(mise env)"
```

After this, `helm` and all installed helm plugins are available for the rest of the job.

# Dev Container Features

[![Codacy Badge](https://app.codacy.com/project/badge/Grade/8f95367839da4477a3c60c031a729dc0)](https://app.codacy.com/gh/kuju63/devcontainer-features/dashboard?utm_source=gh&utm_medium=referral&utm_content=&utm_campaign=Badge_grade)

## Features

This repository contains a _collection_ of many Features - `betterleaks` and more.

### `betterleaks`

[`betterleaks`](https://github.com/betterleaks/betterleaks) is secret scanning tools.

```jsonc
{
    "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
    "features": {
        "ghcr.io/kuju63/devcontainer-features/betterleaks:1.0.0": {
            "version": "latest"
        }
    }
}
```

## Distributing Features

### Versioning

Features are individually versioned by the `version` attribute in a Feature's `devcontainer-feature.json`.  Features are versioned according to the semver specification. More details can be found in [the dev container Feature specification](https://containers.dev/implementors/features/#versioning).

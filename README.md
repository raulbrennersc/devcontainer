# 🐳 DevContainer Docker Image

A lightweight yet powerful **Docker image for development containers** — designed to provide **isolated, reproducible, and ready-to-code environments** for any project.

---

## 🚀 Overview

This repository provides a **Docker image** built to serve as a foundation for **development containers (devcontainers)**.  
It aims to solve common issues developers face when juggling multiple projects and environments:

- **Context isolation:** Avoid mixing credentials, dependencies, or environment variables between projects.  
- **Reproducibility:** Quickly recreate your entire development setup — no more spending hours reconfiguring environments.  
- **Integration-ready:** Works seamlessly with external tooling and configuration scripts for an enhanced developer experience.

---

## 🧩 Motivation

Modern development often involves switching between different projects, each requiring specific tools or environment variables.  
This image helps maintain **separation of contexts**, **security**, and **consistency** across setups by containerizing your dev environment.

Additionally, it supports **fast recovery** — if an environment breaks, simply recreate the container and resume development within minutes.

---

## ⚙️ Features

This devcontainer image comes with a robust set of preinstalled and preconfigured tools:

- 🧠 **NVM (Node Version Manager)** — manage Node.js versions easily  
- 🧰 **Git** — ready for cloning and version control operations  
- 🐧 **SSH server** — exposes port **2222** for remote container access  
- 📱 **Android Studio Command Line Tools** — enables Android emulator usage directly within the container  
- 🔄 **Custom shell configuration** — easily extensible when combined with [dotfiles scripts](https://github.com/raulbrennersc/dotfiles)

When used alongside the [`dotfiles`](https://github.com/raulbrennersc/dotfiles) repository, you also get:
- ⚡ **WezTerm integration** with **MuxDomains** for seamless container access  
- 🧩 **Automated setup scripts** for creating, connecting, and deleting devcontainers  
- 🎨 **Personalized shell environment** (prompt, aliases, etc.)  
- 🛠️ **Neovim configuration** and other utilities for an optimal developer experience

---

## 🔌 Usage

### Run the image with the [devcontainer script](https://github.com/raulbrennersc/dotfiles/blob/main/scripts/devcontainers.sh)

```bash
devcontainer up my-container
```

### Access the container

```bash
devcontainer connect my-container
```

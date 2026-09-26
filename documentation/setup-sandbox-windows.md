# Sandbox Setup

## Overview

AI sandboxes reduce the blast radius of agent work by isolating tools, files, network access, and installed software from the host machine.

They let you grant only the workspace and connections a task needs, so you can experiment and review changes with clearer boundaries.

## Windows Sandbox for Codex

[![Watch the Docker Experience](https://i.ytimg.com/vi/erQnRkMrpls/hqdefault.jpg)](https://www.youtube.com/watch?v=erQnRkMrpls)

[Watch the Docker Experience](https://www.youtube.com/watch?v=erQnRkMrpls).

See the [official Docker Sandboxes installation guide](https://docs.docker.com/ai/sandboxes/install/) and [official OpenAI Codex page](https://openai.com/codex/).

### Solution

Docker Sandboxes runs Codex inside an isolated microVM with its own filesystem, Docker daemon, and network. The workspace you choose to share is mounted read-write; other host resources remain outside the sandbox.

### 1. Setup

Docker's current Windows instructions do not require Docker Desktop or WSL 2 to install or use `sbx`. The optional WSL and Docker Desktop steps below are useful when you also want Docker Desktop's WSL 2 workflow.

1. **Install WSL 2 (optional).** WSL 2 provides a Linux environment on Windows without managing a separate virtual machine.

   1. Open **PowerShell as Administrator**.
   2. Run:

      ```powershell
      wsl --install
      ```

   3. Restart Windows if prompted.
   4. Open a new PowerShell window and verify the installation:

      ```powershell
      wsl --version
      ```

   5. Finish the Linux-distribution setup if Windows prompts you to do so.

2. **Install Docker Desktop (optional).** [Docker Desktop](https://docs.docker.com/desktop/setup/install/windows-install/) is separate from Docker Sandboxes; install it only if you need Docker Desktop or its WSL 2 backend for other work.

3. **Enable local-sandbox virtualization.** Local Docker Sandboxes on Windows require Windows 11, a 64-bit Intel or AMD processor, and Windows Hypervisor Platform. In **PowerShell as Administrator**, run:

   ```powershell
   Enable-WindowsOptionalFeature -Online -FeatureName HypervisorPlatform -All
   ```

   Restart Windows if prompted.

4. **Install Docker Sandboxes.** In PowerShell, install the `sbx` command-line tool for your user:

   ```powershell
   winget install -h Docker.sbx
   ```

5. **Sign in to Docker.** Run the following command and complete the browser-based Docker sign-in:

   ```powershell
   sbx login
   ```

### 2. Usage

1. **Choose the project folder.** In a new PowerShell window, move to the repository or folder you want to share with the sandbox:

   ```powershell
   cd D:\path\to\your\project
   ```

2. **Review the sandbox dashboard and network policy.** Run `sbx` to open the interactive dashboard. On your first run, select a network preset; Docker recommends **Balanced** as a starting point. You can inspect the active rules later with:

   ```powershell
   sbx policy ls
   ```

3. **Start Codex.** From the project folder, run:

   ```powershell
   sbx run codex
   ```

   If needed, complete the OpenAI sign-in on the host. Docker Sandboxes keeps those credentials out of the sandbox.

4. **Start your session.** Codex can now work in the shared project folder while packages, images, containers, and other sandbox resources stay isolated from the rest of your host machine. Review its changes in your ordinary Git diff before committing.

### Test the boundaries

- Ask Codex to create a text file in the shared project folder. This works because that folder is mounted into the sandbox.
- Ask Codex to create a text file elsewhere on the host. This does not work because it is not shared with the sandbox.
- Ask Codex to access a website. The result depends on the network policy you selected.

## ChatGPT

[ChatGPT app sandbox](https://learn.chatgpt.com/docs/sandboxing)

## Docker

Set up Docker Sandboxes to run Codex in an isolated microVM while keeping your project folder available for review.

## Table of Contents

1. [Getting Started](#getting-started)
2. [Details](#details)
   1. [Setup](#1-setup)
   2. [Usage](#2-usage)
   3. [Test Your Results](#3-test-your-results)

## Getting Started

#### Video

[![Watch the Docker Experience](https://i.ytimg.com/vi/erQnRkMrpls/hqdefault.jpg)](https://www.youtube.com/watch?v=erQnRkMrpls)

#### Links

* [OpenAI Codex - Overview](https://openai.com/codex/).
* [Docker Sandboxes - Installation](https://docs.docker.com/ai/sandboxes/install/)
* [Docker Sandboxes - Security](https://docs.docker.com/ai/sandboxes/security/defaults/)
* [Docker Sandboxes - Network](https://docs.docker.com/ai/sandboxes/security/policy/)
* [Docker Sandboxes - Authentication](https://docs.docker.com/ai/sandboxes/agents/codex/)

## Details

### Overview

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

2. **Prepare the target folder.** Install any npm dependencies you need on the host, in this project folder, before starting the sandbox. The default Codex kit may still allow the sandbox to reach npm registries, so this is a workflow preference rather than a network boundary. Do not start `sbx` from a parent folder that contains other projects.

3. **Reset the network policy and choose the strict preset.** This resets local policy rules and stops any running sandboxes. Run:

   ```powershell
   # Reset Policy Rules - At prompt choose "3. Locked Down"
   sbx policy reset
   ```

   The Locked Down preset controls the sandbox policy, but the built-in Codex kit also contributes network allows. Docker's Codex kit includes `registry.npmjs.org` and other setup/package-source destinations, so npm access may work even when no Codex command has been run yet. Inspect the kit rules with `sbx policy ls my-locked-project --source kit --type network --wide` and verify actual access in the network log. Do not assume that this preset limits egress to model/harness endpoints alone. If you need a stricter allowlist, add explicit denials for destinations the workflow does not need or use organization governance to enforce a centrally managed policy.

   Check the effective global network rules with `sbx policy ls --type network --wide` and remove any old broad allow rules that this workflow does not need. The `deny-all` preset blocks destinations without an allow rule, but previously added allow rules can still apply.

4. **Provide Codex authentication through the host CLI.** Set up OpenAI OAuth on the host (or use the API-key prompt if your account uses an API key):

   ```powershell
   sbx secret set openai --oauth
   ```

   For API-key authentication, run `sbx secret set openai` and enter the key at its secure prompt. Do not put the key itself in the command arguments.

   This stores authentication with Docker Sandboxes on the host. The proxy supplies authenticated requests to the model service; the raw credential is not placed in the project, an environment variable, or the sandbox filesystem. Do not paste a raw API key into a command, project file, or prompt.

5. **Start a sandbox with only the target folder mounted.** From that folder, choose whether to share the host's skills store:

   ```powershell
   # Setup with skills
   sbx run --name my-locked-project --skills=readonly codex .
   #
   # Setup without skills
   sbx run --name my-locked-project --skills=off codex .
   ```

> **NOTE:** The Codex version in the sandbox image may lag the latest release, so Codex may offer an update. You can continue without updating. To update it, follow [Docker's agent update instructions](https://docs.docker.com/ai/sandboxes/usage/#updating-agents).

   `.` mounts only the current folder and its descendants. Docker Sandboxes does not expose other host folders unless you explicitly mount them. `--skills=readonly` mounts the shared skills store read-only; `--skills=off` leaves it unmounted. The sandbox's own VM filesystem remains available to its processes; this restriction concerns host folders. Local filesystem policy controls are not configured with the `sbx policy` CLI; if organization governance is available, set its filesystem read/write allow rules to this target path.

6. **Inspect the policy from the host (Optional).** Leave the sandboxed Codex session open. Open a **separate PowerShell window on the host**—not the Codex prompt inside the sandbox—and run:

   ```powershell
   sbx policy ls my-locked-project --wide
   ```

   Review the effective rules before giving Codex work. The sandboxed Codex session and this policy check run in separate PowerShell windows.

7. **Inspect all current sandboxes (Optional).** Open the Docker Sandboxes dashboard from a host PowerShell window to inspect current sandbox status, network activity, and filesystem rules:

   ```powershell
   sbx tui
   ```

8. **Work in the sandbox.** Codex can edit the mounted target folder. Any npm dependencies must already be present in that folder (for example, its local `node_modules`) before launch. Do not approve new network destinations unless they are required by the selected Codex model/harness and you have checked what they are.

### 3. Test Your Results

Copy each **Prompt AI:** block and paste it into the Codex prompt inside the sandbox.

1. **Test File Access**

Check that Codex can create a file in the mounted target folder and cannot create one in its parent directory.

**Prompt AI:**

   ```powershell
   Create hello-world.txt in this directory and its parent, with the text "hello world". Leave both files. Report whether each write succeeded.
   ```

> **NOTE:** The sandbox may report a parent write succeeded because it sees its VM filesystem; that does not mean the host file was written. Verify on the host. [Docker's default security posture](https://docs.docker.com/ai/sandboxes/security/defaults/)

2. **Test Network Access**

Now test network access.

**Prompt AI:**

   ```powershell
   Request https://example.com. Report whether the call returned an HTTP success status.
   ```

**Note:** Since we set up the sandbox as a Codex sandbox, some network access—including [registry.npmjs.org](https://registry.npmjs.org)—is allowed.

3. **Test Secrets Access**

Ask Codex to verify no raw credential is readable, without revealing any credential value.

**Prompt AI:**

   ```powershell
  Run a read-only credential check inside this sandbox. Use Python; make no
  network requests and do not modify files.

  Check these environment variables: OPENAI_API_KEY, OPENAI_ACCESS_TOKEN,
  OPENAI_OAUTH_TOKEN, CODEX_API_KEY, and CODEX_ACCESS_TOKEN. Also check
  credential fields in $HOME/.codex/auth.json and the project's .codex/
  auth.json, if present.

  For each check, classify the result as MISSING, EMPTY, PROXY_PLACEHOLDER,
  CREDENTIAL_PRESENT, or ERROR. Treat only the exact value proxy-managed
  (case-insensitive) as a proxy placeholder. Any other non-empty value in
  one of those credential variables or fields is CREDENTIAL_PRESENT, even
  if its validity is unknown.

  Never print, copy, hash, transmit, or log credential values or file
  contents. Report only the variable or field name and its classification.

  Final result: YES if any check is CREDENTIAL_PRESENT; NO if all checks
  completed and none are; INCONCLUSIVE if any check is ERROR. Do not turn
  an error into YES or NO.
   ```

> **NOTE:** Docker's credential proxy should keep the raw credential on the host. If this check reports a credential present, stop the sandbox and treat it as exposed; revoke any API key and review API usage. Investigate why the auth file is readable. [Docker Codex authentication](https://docs.docker.com/ai/sandboxes/agents/codex/)

You are now done.

Enjoy!

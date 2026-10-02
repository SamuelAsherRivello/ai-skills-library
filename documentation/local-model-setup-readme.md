# Local Model Setup

Use Docker Model Runner to run local models and connect them to your AI harness.

## Table of Contents
 
1. [Getting Started](#getting-started)
    1. [Install Docker Desktop](#1-install-docker-desktop)
    2. [Enable Docker Model Runner](#2-enable-docker-model-runner)
    3. [Verify Docker Models](#3-verify-docker-models)
    4. [Choose a Model](#4-choose-a-model)
    5. [Add the Model to Harness](#5-add-the-model-to-harness)
        1. [Pi](#pi)
        2. [Codex](#codex)
2. [Details](#details)
    1. [Fast Response (CPU)](#fast-response-cpu)
    2. [High Intelligence (GPU)](#high-intelligence-gpu)

## Getting Started

### 1. Install Docker Desktop

Install the current version of [Docker Desktop](https://docs.docker.com/desktop/) and start it.

### 2. Enable Docker Model Runner

In Docker Desktop, open **Settings > AI** and enable **Docker Model Runner**. Enable GPU support there as well when using the High Intelligence (GPU) option.

<a href="https://www.docker.com/app/uploads/2025/09/MR-GA-figure-1.png">
  <img src="https://www.docker.com/app/uploads/2025/09/MR-GA-figure-1.png" alt="Docker Model Runner settings" width="400">
</a>

### 3. Verify Docker Models

Verify that the Docker Model CLI is available:

```powershell
docker model version
docker model list
```

### 4. Choose a Model

```powershell
docker model pull ai/smollm2
```

See [_Details_](#details) below for more.

### 5. Add the Model to Harness

#### Pi AI Harness

**Prompt AI:**

```text
Add the selected Docker Model Runner model to Pi.
```

#### Codex AI Harness

**Prompt AI:**

```text
Add the selected Docker Model Runner model to Codex.
```

## Details

You can choose any [_Docker Model_](https://hub.docker.com/u/ai), but here are 2 leading suggestions.

| # | Name | Link | Comment |
|---:|---|---|---|
| 1 | Fast Response (CPU) | [ai/smollm2](https://hub.docker.com/u/ai) | Good for fast, low-latency responses on CPU-only systems. |
| 2 | High Intelligence (GPU) | [ai/qwen3](https://hub.docker.com/u/ai) | Good for complex reasoning and higher-quality responses with a compatible GPU. |


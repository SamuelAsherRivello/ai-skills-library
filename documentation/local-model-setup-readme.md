# Local Model Setup

Use Docker Model Runner to run local models and connect them to your AI harness.

## Table of Contents
 
1. [Getting Started](#getting-started)
    1. [Install Docker Desktop](#1-install-docker-desktop)
    2. [Enable Docker Model Runner](#2-enable-docker-model-runner)
    3. [Verify Docker Models](#3-verify-docker-models)
    4. [Choose a Model](#4-choose-a-model)
    5. [Add the Model to Harness](#5-add-the-model-to-harness)
        1. [Pi AI Harness](#pi-ai-harness)
        2. [Codex AI Harness](#codex-ai-harness)
2. [Details](#details)

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

Codex can use Docker Model Runner (DMR), but DMR exposes an OpenAI-compatible
**Chat Completions** API while Codex custom providers use the **Responses** API.
The local bridge below converts between those APIs and adds both local models to
Codex's `/model` picker. It binds every gateway port to `127.0.0.1`; no model
traffic is exposed on the network.

This was tested with Codex CLI `0.160.0` on Windows. It creates a user-level
Codex profile, so it works from any repository. Codex profile files live in
`$CODEX_HOME` and `model_catalog_json` loads a custom model catalog on startup;
see the [Codex configuration reference](https://developers.openai.com/docs/config-file/config-reference).

##### 1. Enable and verify the DMR API

In Docker Desktop, enable **Settings > AI > Docker Model Runner** and
**host-side TCP support**. Docker's current default TCP port is `12434`. If
your Docker Desktop installation already uses another port, substitute that
port consistently in every command and configuration value below.

```powershell
docker desktop enable model-runner --tcp 12434
docker model status
docker model list
curl.exe http://127.0.0.1:12434/engines/v1/models
```

The last command must list the two model identifiers that will be used below.
Pull either model if it is absent:

```powershell
docker model pull ai/smollm2:135M-Q4_K_M
docker model pull huggingface.co/apto-as/qwen2.5-coder-14b-instruct-q5_k_m-gguf:latest
```

##### 2. Create the local gateway configuration

The following commands create the initial files Codex needs under the current
user's `.codex` directory. The generated key protects the loopback-only
gateway; it is not an OpenAI API key.

```powershell
$codexHome = Join-Path $env:USERPROFILE '.codex'
$gatewayKey = "sk-codex-local-$([guid]::NewGuid())"
New-Item -ItemType Directory -Force -Path $codexHome | Out-Null
Set-Content -NoNewline -Path (Join-Path $codexHome 'docker-model-gateway.key') -Value $gatewayKey

@"
model_list:
  - model_name: local-qwen2.5-coder-14b
    litellm_params:
      model: openai/chat_completions/huggingface.co/apto-as/qwen2.5-coder-14b-instruct-q5_k_m-gguf:latest
      api_base: http://host.docker.internal:12434/engines/v1
      api_key: local-not-needed
      max_tokens: 4096
    model_info:
      max_input_tokens: 28672
      max_output_tokens: 4096
      context_window: 32768
  - model_name: local-smollm2-135m
    litellm_params:
      model: openai/chat_completions/ai/smollm2:135M-Q4_K_M
      api_base: http://host.docker.internal:12434/engines/v1
      api_key: local-not-needed
      max_tokens: 1024
    model_info:
      max_input_tokens: 6144
      max_output_tokens: 1024
      context_window: 8192

general_settings:
  master_key: $gatewayKey
"@ | Set-Content -Encoding utf8 (Join-Path $codexHome 'docker-model-gateway.yaml')
```

If `docker model list` reports a different full model name (for example, a
Hugging Face GGUF identifier), replace only the matching `model:` value above
with that exact identifier. Keep the stable `local-*` aliases unchanged.

##### 3. Generate the two-model Codex catalog

Create this file as `$codexHome\build-docker-model-catalog.mjs`:

```js
import https from 'node:https';
import { writeFile } from 'node:fs/promises';

const version = process.env.CODEX_VERSION;
const source = `https://raw.githubusercontent.com/openai/codex/rust-v${version}/codex-rs/models-manager/models.json`;

function download(url) {
  return new Promise((resolve, reject) => {
    https.get(url, (response) => {
      if (response.statusCode !== 200) return reject(new Error(`Model catalog download failed: ${response.statusCode}`));
      let body = '';
      response.setEncoding('utf8');
      response.on('data', (chunk) => { body += chunk; });
      response.on('end', () => resolve(body));
    }).on('error', reject);
  });
}

function localModel(template, slug, displayName, contextWindow, compactLimit, outputLimit, priority) {
  const model = structuredClone(template);
  Object.assign(model, {
    slug,
    display_name: displayName,
    description: `Docker Model Runner local model: ${displayName}.`,
    context_window: contextWindow,
    max_context_window: contextWindow,
    auto_compact_token_limit: compactLimit,
    max_output_tokens: outputLimit,
    default_reasoning_level: 'low',
    supported_reasoning_levels: [{ effort: 'low', description: 'Local model' }],
    priority,
    visibility: 'list',
    input_modalities: ['text'],
    service_tiers: [],
    additional_speed_tiers: [],
    supports_search_tool: false,
    supports_parallel_tool_calls: false,
  });
  return model;
}

const catalog = JSON.parse(await download(source));
const template = catalog.models.find((model) => model.slug === 'gpt-6-luna') ?? catalog.models[0];
if (!template) throw new Error('The downloaded catalog contains no model template.');

catalog.models = [
  localModel(template, 'local-qwen2.5-coder-14b', 'Qwen 2.5 Coder 14B (Docker local)', 32768, 24576, 4096, 1),
  localModel(template, 'local-smollm2-135m', 'SmolLM2 135M (Docker local)', 8192, 6144, 1024, 2),
];
await writeFile('/work/docker-local-models.json', `${JSON.stringify(catalog, null, 2)}\n`);
```

Build the catalog from the release matching the installed Codex CLI. Docker
runs Node for this step, so Node does not need to be installed on the host.

```powershell
$codexVersion = ((codex --version) -split '\s+')[-1]
docker run --rm -e CODEX_VERSION=$codexVersion -v "${codexHome}:/work" node:22-alpine node /work/build-docker-model-catalog.mjs
```

##### 4. Create the Responses bridge and Codex profile

Create `$codexHome\codex-responses-bridge.js`. It retains the latest user
message and removes tools before forwarding a request. This is necessary:
Codex's cloud-sized instructions and tool definitions exceed these local
models' context windows.

```js
const http = require('http');
const upstream = { host: 'host.docker.internal', port: 4000 };

function asText(content) {
  if (typeof content === 'string') return content;
  if (!Array.isArray(content)) return '';
  return content.map((part) => typeof part === 'string' ? part : part?.text ?? part?.input_text ?? '').join('\n');
}

function latestUserText(input) {
  const items = Array.isArray(input) ? input : [input];
  const latest = [...items].reverse().find((item) => item?.role === 'user') ?? items.at(-1);
  return asText(typeof latest === 'object' ? latest?.content : latest).slice(-24000) || 'Please respond to the user request.';
}

http.createServer((request, response) => {
  const chunks = [];
  request.on('data', (chunk) => chunks.push(chunk));
  request.on('end', () => {
    let body = Buffer.concat(chunks);
    if (request.method === 'POST' && request.url === '/v1/responses') {
      try {
        const payload = JSON.parse(body.toString('utf8'));
        payload.instructions = 'You are a capable local coding assistant. Be concise and accurate.';
        payload.input = latestUserText(payload.input);
        payload.tools = [];
        payload.tool_choice = 'none';
        payload.max_output_tokens = payload.model === 'local-smollm2-135m' ? 1024 : 4096;
        delete payload.max_completion_tokens;
        delete payload.max_tokens;
        body = Buffer.from(JSON.stringify(payload));
      } catch {
        response.writeHead(400, { 'content-type': 'application/json' });
        response.end(JSON.stringify({ error: { message: 'Invalid JSON request body' } }));
        return;
      }
    }
    const headers = { ...request.headers, host: 'host.docker.internal:4000', 'content-length': body.length };
    const forwarded = http.request({ ...upstream, method: request.method, path: request.url, headers }, (upstreamResponse) => {
      response.writeHead(upstreamResponse.statusCode ?? 502, upstreamResponse.headers);
      upstreamResponse.pipe(response);
    });
    forwarded.on('error', (error) => {
      response.writeHead(502, { 'content-type': 'application/json' });
      response.end(JSON.stringify({ error: { message: error.message } }));
    });
    forwarded.end(body);
  });
}).listen(4001, '0.0.0.0');
```

Create `$codexHome\docker-local.config.toml`:

```powershell
$gatewayKey = (Get-Content -Raw (Join-Path $codexHome 'docker-model-gateway.key')).Trim()
$catalogPath = Join-Path $codexHome 'docker-local-models.json'

@"
model = "local-qwen2.5-coder-14b"
model_provider = "docker-local"
model_catalog_json = '$catalogPath'
model_context_window = 32768
model_auto_compact_token_limit = 24576
model_reasoning_effort = "low"
web_search = "disabled"

[model_providers.docker-local]
name = "Docker Model Runner (local)"
base_url = "http://127.0.0.1:4001/v1"
wire_api = "responses"
experimental_bearer_token = "$gatewayKey"

[skills]
include_instructions = false
max_context_tokens = 1
"@ | Set-Content -Encoding utf8 (Join-Path $codexHome 'docker-local.config.toml')
```

The generated key is saved locally in `docker-model-gateway.key` so later steps
can be run from a fresh PowerShell window. Keep this file private.

##### 5. Start and verify the local services

```powershell
$gatewayKey = (Get-Content -Raw (Join-Path $codexHome 'docker-model-gateway.key')).Trim()
docker rm -f codex-local-model-gateway codex-local-responses-bridge 2>$null

docker run -d --name codex-local-model-gateway --restart unless-stopped `
  -p 127.0.0.1:4000:4000 `
  --add-host host.docker.internal:host-gateway `
  -v "${codexHome}\docker-model-gateway.yaml:/app/config.yaml:ro" `
  docker.litellm.ai/berriai/litellm:main-latest --config /app/config.yaml

docker run -d --name codex-local-responses-bridge --restart unless-stopped `
  -p 127.0.0.1:4001:4001 `
  --add-host host.docker.internal:host-gateway `
  -v "${codexHome}\codex-responses-bridge.js:/app/server.js:ro" `
  node:22-alpine node /app/server.js

$headers = @{ Authorization = "Bearer $gatewayKey" }
Invoke-RestMethod http://127.0.0.1:4001/v1/models -Headers $headers
```

The final command must report these aliases:

- `local-qwen2.5-coder-14b`
- `local-smollm2-135m`

##### 6. Start Codex and change models

Close any already-running Codex session, then start a new one:

```powershell
codex --profile docker-local
```

Enter `/model` and choose **Qwen 2.5 Coder 14B (Docker local)** or **SmolLM2
135M (Docker local)**. The default is Qwen. To test a selection without opening
the interactive UI:

```powershell
codex --profile docker-local --model local-qwen2.5-coder-14b exec "Reply with exactly: QWEN READY"
codex --profile docker-local --model local-smollm2-135m exec "Reply with exactly: SMOLLM READY"
```

The bridge intentionally removes Codex tools and prior conversation history.
These local models can provide coding/chat responses, but they cannot safely
run shell, browser, MCP, or other agent tools through this profile.

## Details

You can choose any [_Docker Model_](https://hub.docker.com/u/ai), but here are 2 leading suggestions.

| # | Name | Link | Comment |
|---:|---|---|---|
| 1 | Fastest response | [`ai/smollm2:135M-Q4_K_M`](https://hub.docker.com/u/ai) | Very small (~135M) CPU-friendly model. Use it for connectivity tests, short drafts, and very low-latency replies; it is not reliable for coding tasks. |
| 2 | Balanced local coding results | [`apto-as/qwen2.5-coder-14b-instruct-q5_k_m-gguf`](https://huggingface.co/apto-as/qwen2.5-coder-14b-instruct-q5_k_m-gguf) | The recommended default for this Codex setup: a 14B coding model with much stronger code and instruction-following quality. Its Q5 GGUF needs about 10 GiB of model storage; a GPU is recommended for usable latency. |


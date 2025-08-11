# Qwen Claude Code Local Development Environment

This repository provides a Docker-based setup for running the Qwen3-Coder-30B-A3B-Instruct model with Claude Code integration.

## Overview

This setup allows you to run a local LLM (Qwen3-Coder-30B-A3B-Instruct) using llama.cpp server and access it through Claude Code via litellm proxy. The environment is containerized and can be run completely offline after initial setup.

## Features

- **Local Execution**: Run code generation models entirely locally without internet access after initial download
- **Claude Code API compatible** through litellm proxy

## What does not work
- Think, Ultrathing etc. reasoning_effort is currently dropped as non-thinking model is currently used. To use a Qwen thinking/non-thinking model a litellm hook needs to be written to add ` /think`  ` /nothink` tags to requests. Or wait until litellm support Qwen API.

## Requirements

- Docker Engine (version 20.10 or higher)
- At least 18GB of free disk space for the model
- For GPU acceleration: NVIDIA GPU with CUDA support and nvidia-docker2
- Internet connection for initial model download (subsequent runs can be offline)

> Note: The current settings are targeted for a GPU with 24GB VRAM or more. The code was tested on an RTX 3090. If you have less VRAM available, you'll need to adjust the following settings in the Dockerfile:
> - `LLAMA_ARG_N_GPU_LAYERS`
> - `LLAMA_ARG_CTX_SIZE`
> - `LLAMA_ARG_N_PREDICT`

## Quick Start

### Build the Docker Image

```bash
./build.sh
```
### Run the Container

For network access:
```bash
./run.sh
```

For offline mode (no internet required):
```bash
./run_offline.sh
```

## Testing

After running, you can test the setup with:

- Claude API compatibility: `./test_anthropic.sh`
- Reasoning capabilities: `./test_anthropic_reasoning.sh`
- OpenAI API compatibility: `./test_openai.sh`

## Configuration

The Dockerfile sets various environment variables for optimal performance:

- Model parameters (context size, prediction count, GPU layers)
- Sampling parameters (temperature, top-p, top-k, presence penalty)
- API endpoint configuration

## Notes

- The first run will download the model from Hugging Face (requires internet connection)
- Subsequent runs will use the cached model
- The container will automatically shut down when you exit the terminal

## Troubleshooting

If you encounter issues:
1. Ensure Docker is installed and running
2. Check that you have sufficient disk space for the model (~18GB)
3. Verify network connectivity during initial model download
4. Make sure you're running with appropriate permissions
5. If you get connection error 500, verify if llama-server is still running by using `./view_llama_server.sh` script. Sometimes it crashes upon tool calling.

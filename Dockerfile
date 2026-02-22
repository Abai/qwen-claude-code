FROM ghcr.io/ggml-org/llama.cpp:server-cuda

ARG USER_ID=1000
ARG GROUP_ID=1000

# Disable .pyc generation, output buffering, pip caching and apt dialogue
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y vim git curl tmux python3 python3-pip python3-venv sudo \
    && apt autoremove -y \
    && apt clean -y \
    && rm -rf /tmp/* /var/tmp/* \
    && find /var/cache/apt/archives /var/lib/apt/lists -not -name lock -type f -delete \
    && find /var/cache -type f -delete

# Create venv
RUN python3 -m venv .venv
# Activate the virtual environment
ENV PATH="/app/.venv/bin:$PATH"

# Install huggingface_hub
RUN python3 -m pip install -U huggingface_hub hf_transfer

# Install Claude Code
RUN curl -fsSL https://deb.nodesource.com/setup_24.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g @anthropic-ai/claude-code \
    && apt autoremove -y \
    && apt clean -y \
    && rm -rf /tmp/* /var/tmp/* \
    && find /var/cache/apt/archives /var/lib/apt/lists -not -name lock -type f -delete \
    && find /var/cache -type f -delete

# Create group and user ubuntu
RUN groupadd -g $GROUP_ID ubuntu \
    && useradd -u $USER_ID -g $GROUP_ID -m ubuntu \
    && echo ubuntu ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/ubuntu \
    && chmod 0440 /etc/sudoers.d/ubuntu \
    && usermod -a -G video ubuntu

# Switch to user ubuntu
USER ubuntu

# Config for hugginface_hub
ENV HF_HUB_ENABLE_HF_TRANSFER=1
ENV HF_MODEL_ALIAS="unsloth/Qwen3-Coder-Next"
ENV HF_REPO_ID="${HF_MODEL_ALIAS}-GGUF"
ENV HF_MODEL="Qwen3-Coder-Next-UD-Q4_K_XL.gguf"

# Config for llama.cpp
ENV LLAMA_ARG_HOST=0.0.0.0
ENV LLAMA_ARG_PORT=8001
ENV LLAMA_ARG_N_PARALLEL=1
ENV LLAMA_API_KEY=sk-1234-miaw
ENV LLAMA_ARG_THREADS=-1
ENV LLAMA_LOG_COLORS=1
ENV LLAMA_LOG_PREFIX=1

# Config for loaded llama.cpp model
ENV LLAMA_ARG_MODEL="/home/ubuntu/models/$HF_REPO_ID/$HF_MODEL"
ENV LLAMA_ARG_ALIAS="$HF_MODEL_ALIAS"
ENV LLAMA_ARG_CTX_SIZE=262144
ENV LLAMA_ARG_N_PREDICT=$LLAMA_ARG_CTX_SIZE
ENV LLAMA_ARG_OVERRIDE_TENSOR=".ffn_(up|down)_exps.=CPU"
ENV LLAMA_ARG_NO_CONTEXT_SHIFT=1
ENV LLAMA_ARG_FLASH_ATTN=on
ENV LLAMA_ARG_CACHE_TYPE_K=q8_0
ENV LLAMA_ARG_CACHE_TYPE_V=q8_0
ENV LLAMA_SAMPLING_TEMPERATURE=1.0
ENV LLAMA_SAMPLING_MIN_P=0.01
ENV LLAMA_SAMPLING_TOP_P=0.95
ENV LLAMA_ARG_TOP_K=40

# Config for Claude Code
ENV ANTHROPIC_BASE_URL="http://${LLAMA_ARG_HOST}:${LLAMA_ARG_PORT}"
ENV ANTHROPIC_AUTH_TOKEN="$LLAMA_API_KEY"
ENV ANTHROPIC_MODEL="openai/$HF_MODEL_ALIAS"
ENV ANTHROPIC_SMALL_FAST_MODEL="openai/$HF_MODEL_ALIAS"
ENV CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1
#ENV CLAUDE_CODE_MAX_OUTPUT_TOKENS=32000
#ENV MAX_THINKING_TOKENS=$LLAMA_ARG_CTX_SIZE

COPY --chown=ubuntu:ubuntu entrypoint.sh /home/ubuntu/entrypoint.sh
COPY --chown=ubuntu:ubuntu hf_download.py /home/ubuntu/hf_download.py
COPY --chown=ubuntu:ubuntu test_anthropic.sh /home/ubuntu/test_anthropic.sh
COPY --chown=ubuntu:ubuntu test_anthropic_reasoning.sh /home/ubuntu/test_anthropic_reasoning.sh
COPY --chown=ubuntu:ubuntu test_openai.sh /home/ubuntu/test_openai.sh

ENTRYPOINT [ "/home/ubuntu/entrypoint.sh" ]

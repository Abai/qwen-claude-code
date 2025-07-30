#!/bin/bash

set -e

# Launch tmux tasks
cd $HOME
echo set-option -g default-shell /bin/bash >> .tmux.conf
tmux new -s work -d
tmux rename-window -t work Qwen
tmux send-keys -t work 'python3 hf_download.py; cd /app; ./llama-server --prio 3 --temp $LLAMA_SAMPLING_TEMPERATURE --min-p $LLAMA_SAMPLING_MIN_P --top-p $LLAMA_SAMPLING_TOP_P --top-k $LLAMA_SAMPLING_TOP_K --presence-penalty $LLAMA_SAMPLING_PRESENCE_PENALTY' C-m  # --verbose --log-file $HOME/llama-server.log' C-m
tmux split-window -h -t work
tmux send-keys -t work 'litellm --model $ANTHROPIC_MODEL --temperature $LLAMA_SAMPLING_TEMPERATURE' C-m
tmux select-layout even-horizontal
tmux new-window -t work -n 'Claude Code'
tmux select-window -t work:0

tmux attach -t work

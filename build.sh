docker build --build-arg USER_ID=$(id -u) --build-arg GROUP_ID=$(id -g) -t qwen-claude-code:llama.cpp -f Dockerfile .

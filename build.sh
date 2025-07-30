docker build --build-arg USER_ID=$(id -u) --build-arg GROUP_ID=$(id -g) -t qwen3:llama.cpp -f Dockerfile .

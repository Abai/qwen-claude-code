docker run -ti --rm --name qwen-claude-code --network=none -v $PWD/models:/home/ubuntu/models -v $PWD/workspace:/home/ubuntu/workspace qwen-claude-code:llama.cpp

docker run -ti --rm --name qwen-claude-code --network=host -v $PWD/models:/home/developer/models -v $PWD/workspace:/home/developer/workspace qwen-claude-code:llama.cpp

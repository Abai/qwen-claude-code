docker run -ti --rm --name qwen3 --network=host -v $PWD/models:/home/developer/models -v $PWD/workspace:/home/developer/workspace qwen3:llama.cpp

curl -X POST "http://${LLAMA_ARG_HOST}:${LLAMA_ARG_PORT}/v1/chat/completions" \
-H "Authorization: Bearer $LLAMA_API_KEY" \
-H 'Content-Type: application/json' \
-d '{
    "model": "'${HF_MODEL_ALIAS}'",
    "messages": [{"role": "user", "content": "What llm are you"}]
}' | python3 -m json.tool

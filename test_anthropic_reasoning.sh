curl -X POST "$ANTHROPIC_BASE_URL/v1/chat/completions" \
-H "Authorization: Bearer $ANTHROPIC_AUTH_TOKEN" \
-H "Content-Type: application/json" \
-d '{
    "model": "'$ANTHROPIC_MODEL'",
    "max_tokens": 1024,
    "messages": [{"role": "user", "content": "What is the capital of France?"}],
    "reasoning_effort": "low"
}'

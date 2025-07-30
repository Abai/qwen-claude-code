curl -X POST "$ANTHROPIC_BASE_URL/v1/messages" \
-H "Authorization: Bearer $ANTHROPIC_AUTH_TOKEN" \
-H 'Content-Type: application/json' \
-d '{
    "model": "'$ANTHROPIC_MODEL'",
    "max_tokens": 1024,
    "messages": [{"role": "user", "content": "What llm are you"}]
}' | python3 -m json.tool

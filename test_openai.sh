curl -X POST "$OPENAI_BASE_URL/v1/chat/completions" \
-H "Authorization: Bearer $OPENAI_API_KEY" \
-H 'Content-Type: application/json' \
-d '{
    "model": "'${HF_MODEL%.*}'",
    "messages": [{"role": "user", "content": "What llm are you"}]
}' | python3 -m json.tool

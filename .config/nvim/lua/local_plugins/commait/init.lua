local M = {}

function M.setup()
    vim.api.nvim_create_user_command("TODO", function()
        print("Hello from commait!")

        local api_key = os.getenv("OPENAI_API_KEY")
        if not api_key then
            print("OPENAI_API_KEY not set")
            return
        end

        local cmd = [[curl -s https://api.openai.com/v1/chat/completions \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer %s" \
            -d '{
              "model": "gpt-4o-mini",
              "messages": [
                {"role": "system", "content": "You are a Lua programmer"},
                {"role": "user", "content": "tell me a joke"}
              ],
              "temperature": 0.5
            }']]

        local result = vim.fn.system(string.format(cmd, api_key))
        local ok, decoded = pcall(vim.json.decode, result)
        if ok and decoded.choices then
            print(decoded.choices[1].message.content)
        else
            print("Failed to parse response")
        end
    end, {})
end

return M

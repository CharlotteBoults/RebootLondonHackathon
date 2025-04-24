import os
from openai import AzureOpenAI




endpoint = "https://team12hacker03.openai.azure.com/"
model_name = "o3-mini"
deployment = "o3-mini"

subscription_key = "94AyvW2opL0U247mxRKMto6l9m6o6hNmtUxJZFfrVJJc1saq1lDEJQQJ99BDACmepeSXJ3w3AAABACOGzGsW"
api_version = "2024-12-01-preview"

client = AzureOpenAI(
    api_version=api_version,
    azure_endpoint=endpoint,
    api_key=subscription_key,
)


system_prompt = f"You are a banking assistant. Answer the user's query using only the following information: {CAG_info}"

user_input = input("Ask anything: ")

response = client.chat.completions.create(
    messages=[
        {
            "role": "system",
            "content": system_prompt,
        },
        {
            "role": "user",
            "content": user_input,
        }
    ],
    max_completion_tokens=100000,
    model=deployment
)

print(response.choices[0].message.content)
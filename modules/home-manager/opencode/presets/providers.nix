{
  mistral = {
    sdk = "@ai-sdk/openai-compatible";
    displayName = "Mistral AI";
    models = {
      "mistral-medium-latest" = {
        displayName = "Mistral Medium";
        cost.input = 1.5;
        cost.output = 7.5;
      };
      "mistral-small-latest" = {
        displayName = "Mistral Small";
        cost.input = 0.15;
        cost.output = 0.6;
      };
      "zai-glm-5-2" = {
        displayName = "GLM 5.2";
        cost.input = 1.4;
        cost.output = 4.4;
      };
      "zai-glm-5-3" = {
        displayName = "GLM 5.3";
        cost.input = 1.4;
        cost.output = 4.4;
      };
    };
  };
  moonshot = {
    sdk = "@ai-sdk/openai-compatible";
    displayName = "Moonshot AI";
    models = {
      "kimi-k2.7-code" = {
        displayName = "Kimi K2.7 Code";
        cost.input = 0.95;
        cost.output = 4.00;
      };
      "kimi-k3" = {
        displayName = "Kimi K3";
        cost.input = 3.00;
        cost.output = 15.00;
      };
    };
  };
  nx-anthropic = {
    sdk = "@ai-sdk/amazon-bedrock";
    displayName = "Anthropic (NX)";
    models = {
      "claude-haiku-4.5" = {
        displayName = "Haiku 4.5";
        cost.input = 1.10;
        cost.output = 5.50;
      };
      "claude-sonnet-4.6" = {
        displayName = "Sonnet 4.6";
        cost.input = 3.30;
        cost.output = 16.50;
      };
      "claude-opus-4.6" = {
        displayName = "Opus 4.6";
        cost.input = 5.50;
        cost.output = 27.50;
      };
    };
  };
  nx-google = {
    sdk = "@ai-sdk/openai-compatible";
    displayName = "Google (NX)";
    models = {
      "google.gemini-3.5-flash" = {
        displayName = "Gemini 3.5 Flash";
        cost.input = 1.50;
        cost.output = 9.00;
      };
    };
  };
  nx-moonshot = {
    sdk = "@ai-sdk/openai-compatible";
    displayName = "Moonshot AI (NX)";
    models = {
      "moonshotai.kimi-k2.5" = {
        displayName = "Kimi K2.5";
        cost.input = 1.55;
        cost.output = 4.96;
      };
    };
  };
  nx-zhipu = {
    sdk = "@ai-sdk/openai-compatible";
    displayName = "Zhipu AI (NX)";
    models = {
      "zai.glm-5" = {
        displayName = "GLM 5";
        cost.input = 1.00;
        cost.output = 3.20;
      };
    };
  };
  ollama = {
    sdk = "@ai-sdk/openai-compatible";
    displayName = "Ollama (local)";
    api.url = "http://localhost:11434/v1";
    models = {
      "gemma4:12b-it-qat" = {
        displayName = "Gemma 4 12b";
      };
      "gemma4:e2b" = {
        displayName = "Gemma 4 e2b";
      };
    };
  };
}

{
  mistral = {
    sdk = "aisdk:@ai-sdk/mistral";
    displayName = "Mistral AI";
    models = {
      "mistral-small-latest" = {
        displayName = "Mistral Small";
        capabilities = {
          tools = true;
          input = [ "text" "image" ];
          output = [ "text" ];
        };
        cost = {
          input = 0.1275;
          output = 0.51;
        };
        limit = {
          context = 256000;
        };
      };
     "mistral-large-latest" = {
        displayName = "Mistral Large";
        capabilities = {
          tools = true;
          input = [ "text" "image" ];
          output = [ "text" ];
        };
        cost = {
          input = 0.595;
          output = 1.785;
        };
      };
      "zai-glm-5-3" = {
        displayName = "GLM 5.3";
        capabilities = {
          tools = true;
          input = [ "text" ];
          output = [ "text" ];
        };
        cost = {
          input = 1.19;
          output = 3.74;
        };
        limit = {
          context = 1050000;
          output = 128000;
        };
      };
    };
  };
  moonshot = {
    sdk = "aisdk:@ai-sdk/openai-compatible";
    displayName = "Moonshot AI";
    models = {
      "kimi-k2.7-code" = {
        displayName = "Kimi K2.7 Code";
        cost = {
          input = 0.95;
          output = 4.00;
        };
      };
      "kimi-k3" = {
        displayName = "Kimi K3";
        cost = {
          input = 3.00;
          output = 15.00;
        };
      };
    };
  };
  nx-anthropic-bedrock = {
    sdk = "aisdk:@ai-sdk/amazon-bedrock";
    displayName = "Anthropic (NX Bedrock)";
    settings = {
      region = "eu-central-1";
    };
    models = {
      "claude-haiku-4.5" = {
        displayName = "Haiku 4.5";
        capabilities = {
          tools = true;
          input = ["text" "image" "pdf"];
          output = ["text"];
        };
        cost = {
          input = 1.10;
          output = 5.50;
          cache = {
            read = 0.11;
            write = 1.375;
          };
        };
        limit = {
          context = 200000;
          output = 64000;
        };
      };
      "claude-sonnet-4.6" = {
        displayName = "Sonnet 4.6";
        capabilities = {
          tools = true;
          input = ["text" "image" "pdf"];
          output = ["text"];
        };
        cost = {
          input = 3.30;
          output = 16.50;
          cache = {
            read = 0.33;
            write = 4.125;
          };
        };
        limit = {
          context = 250000;
          output = 128000;
        };
      };
      "claude-opus-4.6" = {
        displayName = "Opus 4.6";
        capabilities = {
          tools = true;
          input = ["text" "image" "pdf"];
          output = ["text"];
        };
        cost = {
          input = 5.50;
          output = 27.50;
          cache = {
            read = 0.55;
            write = 6.875;
          };
        };
        limit = {
          context = 250000;
          output = 128000;
        };
      };
    };
  };
  nx-anthropic-vertex = {
    sdk = "@opencode/ai/providers/google-vertex/messages";
    displayName = "Anthropic (NX Vertex)";
    models = {
      "claude-haiku-5-5" = {
        displayName = "Haiku 5.5";
        capabilities = {
          tools = true;
          input = ["text" "image" "pdf"];
          output = ["text"];
        };
        cost = {
          input = 0.10;
          output = 0.50;
          cache = {
            read = 0.01;
            write = 0.125;
          };
        };
        limit = {
          context = 1000000;
          output = 128000;
        };
      };
      "claude-sonnet-5-5" = {
        displayName = "Sonnet 5.5";
        capabilities = {
          tools = true;
          input = ["text" "image" "pdf"];
          output = ["text"];
        };
        cost = {
          input = 2.00;
          output = 10.00;
          cache = {
            read = 0.10;
            write = 2.50;
          };
        };
        limit = {
          context = 1000000;
          output = 128000;
        };
      };
      "claude-opus-5-5" = {
        displayName = "Opus 5.5";
        capabilities = {
          tools = true;
          input = ["text" "image" "pdf"];
          output = ["text"];
        };
        cost = {
          input = 4.00;
          output = 20.00;
          cache = {
            read = 0.20;
            write = 5.00;
          };
        };
        limit = {
          context = 1000000;
          output = 128000;
        };
      };
    };
  };
  nx-google = {
    sdk = "@opencode/ai/providers/google";
    displayName = "Google (NX)";
    models = {
      "gemini-4-argon" = {
        displayName = "Gemini 4 Argon";
        capabilities = {
          tools = true;
          input = ["text" "image" "audio" "video"];
          output = ["text"];
        };
        cost = {
          input = 2.00;
          output = 10.00;
        };
        limit = {
          context = 1000000;
          output = 65536;
        };
      };
    };
  };
  nx-moonshot = {
    sdk = "aisdk:@ai-sdk/openai-compatible";
    displayName = "Moonshot AI (NX)";
    models = {
      "moonshotai.kimi-k2.5" = {
        displayName = "Kimi K2.5";
        capabilities = {
          tools = true;
          input = ["text"];
          output = ["text"];
        };
        cost = {
          input = 1.55;
          output = 4.96;
        };
        limit = {
          context = 256000;
          output = 65536;
        };
      };
    };
  };
  nx-openai = {
    sdk = "aisdk:@ai-sdk/azure";
    displayName = "Open AI (NX)";
    settings = {
      useDeploymentBasedUrls = true;
    };
    models = {
      "gpt-5.6-luna" = {
        displayName = "GPT 5.6 Luna";
        capabilities = {
          tools = true;
          input = ["text" "image" "pdf"];
          output = ["text"];
        };
        cost = {
          input = 0.44;
          output = 1.98;
          cache = {
            read = 0.05;
            write = 0.55;
          };
        };
        limit = {
          context = 1050000;
          output = 128000;
        };
      };
      "gpt-5.6-terra" = {
        displayName = "GPT 5.6 Terra";
        capabilities = {
          tools = true;
          input = ["text" "image" "pdf"];
          output = ["text"];
        };
        cost = {
          input = 4.40;
          output = 19.80;
          cache = {
            read = 0.44;
            write = 5.50;
          };
        };
        limit = {
          context = 1050000;
          output = 128000;
        };
      };
      "gpt-5.6-sol" = {
        displayName = "GPT 5.6 Sol";
        capabilities = {
          tools = true;
          input = ["text" "image" "pdf"];
          output = ["text"];
        };
        cost = {
          input = 5.50;
          output = 33.00;
          cache = {
            read = 0.55;
            write = 6.88;
          };
        };
        limit = {
          context = 1050000;
          output = 128000;
        };
      };
    };
  };
  nx-zhipu = {
    sdk = "aisdk:@ai-sdk/openai-compatible";
    displayName = "Zhipu AI (NX)";
    models = {
      "zai.glm-5" = {
        displayName = "GLM 5";
        capabilities = {
          tools = true;
          input = [ "text" "image" ];
          output = [ "text" ];
        };
        cost = {
          input = 1.00;
          output = 3.20;
        };
        limit = {
          context = 200000;
          output = 128000;
        };
      };
    };
  };
  ollama = {
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

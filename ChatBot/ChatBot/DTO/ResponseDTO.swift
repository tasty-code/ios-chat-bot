enum OpenAI {
    enum Chat { }
}

extension OpenAI.Chat {
    struct ResponseDTO: Decodable {
        let id: String
        let object: String
        let created: Int
        let model: String
        let systemFingerprint: String
        let choices: [Choice]
        let usage: Usage
    }
}

extension OpenAI.Chat.ResponseDTO {
    struct Choice: Decodable {
        let finishReason: String
        let index: Int
        let message: Message
        let logProbs: LogProbs?
    }
    
    struct Usage: Decodable {
        let completionTokens: Int
        let promptTokens: Int
        let totalTokens: Int
    }
}

extension OpenAI.Chat.ResponseDTO.Choice {
    struct Message: Decodable {
        let role: String
        let content: String?
        let toolCalls: [ToolCall]?
    }
    
    struct LogProbs: Decodable {
        let content: [Content]?
        
        struct Content: Decodable {
            let token: String
            let logprob: Double
            let bytes: [Int]?
            let topLogProbs: [TopLogprob]
            
            struct TopLogprob: Decodable {
                let token: String
                let logProb: Double
                let bytes: [Int]?
            }
        }
    }
}

extension OpenAI.Chat.ResponseDTO.Choice.Message {
    struct ToolCall: Decodable {
        let id: String
        let type: String
        let function: Function
    }
}

extension OpenAI.Chat.ResponseDTO.Choice.Message.ToolCall {
    struct Function: Decodable {
        let name: String
        let arguments: String
    }
}

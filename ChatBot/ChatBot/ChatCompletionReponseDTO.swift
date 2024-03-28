struct ChatCompletionReponseDTO {
    let id: String
    let choices: [Choice]
    let created: Int
    let model: String
    let systemFingerprint: String
    let object: String
    let usage: Usage
}

extension ChatCompletionReponseDTO {
    struct Choice {
        let finishReason: String
        let index: Int
        let message: Message
        let logProbs: LogProbs?
    }
    
    struct Usage {
        let completionTokens: Int
        let promptTokens: Int
        let totalTokens: Int
    }
}

extension ChatCompletionReponseDTO.Choice {
    struct Message {
        let content: String?
        let toolCalls: [ToolCall]
        
        struct ToolCall {}
        
        let role: String
    }
    
    struct LogProbs {
        let content: [Content]?
        
        struct Content {
            let token: String
            let logprob: Double
            let bytes: [Int]?
            let topLogProbs: [TopLogprob]
            
            struct TopLogprob {
                let token: String
                let logProb: Double
                let bytes: [Int]?
            }
        }
    }

}

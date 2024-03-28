struct ChatCompletionReponseDTO: Decodable {
    let id: String
    let object: String
    let created: Int
    let model: String
    let systemFingerprint: String
    let choices: [Choice]
    let usage: Usage
}

extension ChatCompletionReponseDTO {
    struct Choice: Decodable  {
        let finishReason: String
        let index: Int
        let message: Message
        let logProbs: LogProbs?
    }
    
    struct Usage: Decodable  {
        let completionTokens: Int
        let promptTokens: Int
        let totalTokens: Int
    }
}

extension ChatCompletionReponseDTO.Choice {
    struct Message: Decodable  {
        let role: String
        let content: String?
        let toolCalls: [ToolCall]
    }
    
    struct LogProbs: Decodable  {
        let content: [Content]?
        
        struct Content: Decodable  {
            let token: String
            let logprob: Double
            let bytes: [Int]?
            let topLogProbs: [TopLogprob]
            
            struct TopLogprob: Decodable  {
                let token: String
                let logProb: Double
                let bytes: [Int]?
            }
        }
    }
}

extension ChatCompletionReponseDTO.Choice.Message {
    struct ToolCall: Decodable  {
        let id: String
        let type: String
        let function: Function
    }
}

extension ChatCompletionReponseDTO.Choice.Message.ToolCall {
    struct Function: Decodable  {
        let name: String
        let arguments: String
    }
}

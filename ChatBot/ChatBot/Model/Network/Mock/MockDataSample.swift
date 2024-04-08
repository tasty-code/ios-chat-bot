//
//  MockDataSample.swift
//  ChatBot
//
//  Created by 강창현 on 4/3/24.
//

enum MockDataSample {
  static let requestData = RequestModel(
    messages: [
      Message(
        role: "system",
        content: "You are a poetic assistant, skilled in explaining complex programming concepts with creative flair."
      ),
      Message(
        role: "user",
        content: "Compose a poem that explains the concept of recursion in programming."
      ),
      Message(
        role: "assistant",
        content: "$s7Combine9PublisherPAAE4sink17receiveCompletion0D5ValueAA14AnyCancellableCyAA11SubscribersO0E0Oy_7FailureQzGc_y6OutputQzctF + 304"
      ),
      Message(
        role: "user",
        content: "$s7ChatBot0A9ViewModelC05fetchaB4Data33_C3094975EA75902AF323554274754D0BLL4bodyyAA07RequestD0V_tF + 548"
      ),
      Message(
        role: "assistant",
        content: "Y"
      ),
      Message(
        role: "user",
        content: "ChatBot0A9ViewModelC9transform5input7Combine12AnyPublisherVyAC6OutputOs5NeverOGAHyAC5InputOALG_tFyAOcfU_ + 832"
      ),
      Message(
        role: "assistant",
        content: "Terminating app due to uncaught exception 'NSInternalInconsistencyException', reason: 'Fatal: supplied item identifiers are not unique. Duplicate identifiers"
      ),
      Message(
        role: "user",
        content: "17.4asdfasdfasdfasdfasdf"
      ),
    ]
  )
}

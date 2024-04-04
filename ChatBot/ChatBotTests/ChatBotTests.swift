import XCTest

@testable import ChatBot

final class MockNetworkService: NetworkService {
    func request(_ api: API) async throws -> Data {
        _ = api.toURLRequest()
        return JsonLoader.loadjson(fileName: "chat_bot_output_sample")
    }
}

final class ChatBotTests: XCTestCase {

    let sut = ChatBotService(networkService: MockNetworkService())
    
    func test_챗봇서비스에_메시지를_보내면_응답을_준다() {
        // given
        let message = Message(role: Role.user,
                              content: "리액티브 프로그래밍이 뭐야?")
        let answer = Message(role: Role.assistant,
                             content: "리액티브 프로그래밍(Reactive Programming)은 데이터 스트림과 데이터의 변화에 중점을 둔 프로그래밍 패러다임입니다. 이는 다양한 이벤트와 상태 변화에 대응하기 위해 데이터의 흐름을 중심으로 프로그래밍하는 방식을 말합니다. 리액티브 프로그래밍은 데이터 스트림의 발생, 구독, 처리, 에러 처리, 완료 처리 등의 이벤트를 다루는데에 초점을 둡니다.\n\n일반적으로 리액티브 프로그래밍은 관찰 가능한(Observable) 스트림과 이를 구독하고 해당 이벤트를 처리하는 옵저버(Observer)로 이루어져 있습니다. 데이터 스트림의 발생과 변환 및 조작을 위한 연산자(Operators)들을 사용하여 비동기적인 이벤트 처리를 쉽게 할 수 있도록 합니다.\n\n리액티브 프로그래밍은 비동기적인 이벤트 처리를 간결하게 구현하고, 데이터의 흐름을 시각적으로 이해하기 쉽게 만들어주며, 코드의 가독성을 높여주고 유지보수성을 향상시킬 수 있도록 도와줍니다.\n\n이러한 특징을 가지고 있는 리액티브 프로그래밍은 다양한 분야에서 활용되고 있으며, RxSwift와 같은 라이브러리들이 이를 지원하여 개발자들이 리액티브 프로그래밍을 보다 쉽게 사용할 수 있도록 도와줍니다.")
        let expectation = XCTestExpectation(description: "postChat")
        // when
        Task {
            do {
                let result = try await sut.post(messages: [message])
                // then
                XCTAssertEqual(answer.role.rawValue, result.last?.role.rawValue)
                XCTAssertEqual(answer.content, result.last?.content)
                expectation.fulfill()
            } catch {
                print(error)
            }
        }
        wait(for: [expectation], timeout: 10)
    }
    
    func test_챗봇api를_호출할_수_있다() {
        // given
        let message = Message(role: Role.user,
                              content: "리액티브 프로그래밍이 뭐야?")
        let expectation = XCTestExpectation(description: "postChat")
        
        let service = ChatBotService(networkService: DefaultNetworkService())
        // when
        Task {
            do {
                let result = try await service.post(messages: [message])
                // then
                print(result)
                expectation.fulfill()
            } catch {
                print(error)
            }
        }
        wait(for: [expectation], timeout: 10)
    }
}


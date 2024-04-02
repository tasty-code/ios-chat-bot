import Foundation

struct Endpoint: EndpointProvidable {
    private let apiHost: String
    private let urlInfomation: URLInfomation
    private let scheme: String
    
    init(apiHost: APIHostType, urlInfomation: URLInfomation, scheme: SchemeType) {
        self.apiHost = apiHost.rawValue
        self.urlInfomation = urlInfomation
        self.scheme = scheme.rawValue
    }
    
    var url: URL? {
        var urlComponent = URLComponents()
        urlComponent.scheme = scheme
        urlComponent.host = apiHost
        urlComponent.path = urlInfomation.path
        if urlInfomation.queryItem != nil {
            urlComponent.queryItems = urlInfomation.queryItem
        }
        return urlComponent.url
    }
}

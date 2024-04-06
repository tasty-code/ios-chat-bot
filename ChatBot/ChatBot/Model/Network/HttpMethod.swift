//
//  HttpMethod.swift
//  ChatBot
//
//  Created by 강창현 on 4/3/24.
//

enum HttpMethod<T: Encodable> {
  case GET
  case POST(body: T)
  case PUT(body: T)
  case PATCH(body: T)
  case DELETE(body: T)
  
  var configuration: HttpMethodConfiguration<T> {
    switch self {
    case .GET:
      return HttpMethodConfiguration(method: .get, body: nil)
    case .POST(let body):
      return HttpMethodConfiguration(method: .get, body: body)
    case .PUT(let body):
      return HttpMethodConfiguration(method: .get, body: body)
    case .PATCH(let body):
      return HttpMethodConfiguration(method: .get, body: body)
    case .DELETE(let body):
      return HttpMethodConfiguration(method: .get, body: body)
    }
  }
}

enum HTTPMethodType: String {
  case get = "GET"
  case post = "POST"
  case put = "PUT"
  case patch = "PATCH"
  case delete = "DELETE"
}

struct HttpMethodConfiguration<T: Encodable> {
  let method: HTTPMethodType
  let body: T?
}

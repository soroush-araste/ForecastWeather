//
//  Publisher+Dump.swift
//  SwiftUICombineNetworking
//
//  Created by Peter Friese on 03.03.22.
//

import Foundation
import Combine

extension Publisher {
  func dump() -> AnyPublisher<Self.Output, Self.Failure> {
    handleEvents(receiveOutput:  { value in
      Swift.dump(value)
    })
    .eraseToAnyPublisher()
  }
}

extension Publisher {
  func asResult() -> AnyPublisher<Result<Output, Failure>, Never> {
    self
      .map(Result.success)
      .catch { error in
        Just(.failure(error))
      }
      .eraseToAnyPublisher()
  }
}

//
//  ObservableType+Reachability.swift
//  Pods
//
//  Created by Ivan Bruel on 22/03/2017.
//  Copyright (c) RxSwiftCommunity. All rights reserved.
//
//

import Foundation
import Reachability
import RxCocoa
import RxSwift

public extension ObservableType {

  func retryOnConnect(timeout: TimeInterval) -> Observable<Element> {
    return retryWhen { _ in
      return Reachability.rx.isConnected
        .timeout(RxTimeInterval.milliseconds(Int(timeout * 1000)), scheduler: MainScheduler.asyncInstance)
    }
  }
  
  func retryOnConnect(
    timeout: TimeInterval,
    predicate: @escaping (Swift.Error) -> Bool
  ) -> Observable<Element> {
    return retryWhen {
      return $0
        .filter(predicate)
        .flatMap { _ in
          Reachability
            .rx
            .isConnected
            .timeout(
              RxTimeInterval.milliseconds(Int(timeout * 1000)),
              scheduler: MainScheduler.asyncInstance
          )
        }
    }
  }
  
  func retryLatestOnConnect(
    timeout: TimeInterval,
    predicate: @escaping (Swift.Error) -> Bool
    ) -> Observable<Element> {
    return retryWhen {
      return $0
        .filter(predicate)
        .flatMapLatest { _ in
          Reachability
            .rx
            .isConnected
            .timeout(
              RxTimeInterval.milliseconds(Int(timeout * 1000)),
              scheduler: MainScheduler.asyncInstance
            )
        }
    }
  }
  
}

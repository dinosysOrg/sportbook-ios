//
//  AuthenticationViewModels.swift
//  SportBook
//
//  Created by DucBM on 5/24/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import Foundation
import RxSwift
import Moya

protocol AuthenticationDelegate {
    func handleResponse(_ response: Response) -> Observable<Void>
}

extension AuthenticationDelegate {
    func handleResponse(_ response : Response) -> Observable<Void> {
        return Observable<Void>.create { observer in
            
            if 200..<300 ~= response.statusCode {
                
                if let httpResponse = response.response as? HTTPURLResponse  {
                    if let headerFields = httpResponse.allHeaderFields as? [String: Any] {
                        UserManager.sharedInstance.update(with: headerFields)
                    }
                }
                
                UserManager.sharedInstance.userData = response.data
                
                observer.onCompleted()
            } else {
                //Notify error
            }
            
            return Disposables.create()
        }
    }
}


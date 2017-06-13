//
//  TournamentViewModel.swift
//  SportBook
//
//  Created by DucBM on 6/7/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import UIKit
import RxSwift
import SwiftyJSON
import Moya

class TournamentViewModel {
    
    fileprivate let disposeBag = DisposeBag()
    
    let tournaments = Variable<[TournamentModel]>([])
    
    func getTournaments() -> Observable<Void> {
        return Observable<Void>.create { observer in
             TournamentProvider.request(.tournaments)
                .subscribe(onNext: { response in
                    if 401 == response.statusCode {
                        observer.onError(SportBookError.Unauthenticated)
                    } else if 200..<300 ~= response.statusCode {
                        let jsonObject = JSON(response.data)
                        
                        let tournamentArray = jsonObject["_embedded"]["tournaments"].arrayValue
                            .map { jsonObject in
                                return TournamentModel(jsonObject)
                        }
                        
                        self.tournaments.value += tournamentArray
                        observer.onCompleted()
                    } else {
                        let errorMessage = JSON(response)["errors"]["full_messages"]
                            .arrayValue.map { $0.stringValue }.joined(separator: ". ")
                        
                        observer.onError(SportBookError.Custom(errorMessage))
                    }
                }, onError: { _ in
                    observer.onError(SportBookError.ConnectionFailure)
                }).addDisposableTo(self.disposeBag)
            
            return Disposables.create()
        }
    }
}

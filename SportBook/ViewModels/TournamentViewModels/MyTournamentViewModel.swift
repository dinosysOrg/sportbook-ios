//
//  MyTournamentViewModel.swift
//  SportBook
//
//  Created by DucBM on 6/7/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftyJSON
import Moya

class MyTournamentViewModel {
    
    private let disposeBag = DisposeBag()
    
    let isLoading = Variable<Bool>(false)
    
    let hasFailed = Variable<SportBookError>(SportBookError.none)
    
    let upcommingTournaments = Variable<[TournamentModel]>([])
    
    let myTournaments = Variable<[TournamentModel]>([])
    
    func loadMyTournaments() {
        self.isLoading.value = true
        
        let myTournamentRequest = TournamentProvider.request(.myTournaments)
        
        myTournamentRequest.subscribe(onNext: { response in
            if 401 == response.statusCode {
                self.hasFailed.value = SportBookError.unauthenticated
            } else if 200..<300 ~= response.statusCode {
                let jsonObject = JSON(response.data)
                
                print(jsonObject)
                
                let tournamentArray = jsonObject["_embedded"]["tournaments"].arrayValue
                    .map { jsonObject in
                        return TournamentModel(jsonObject)
                }
                
                self.myTournaments.value = tournamentArray
            } else {
                let errorMessage = JSON(response.data)["errors"].arrayValue
                    .map { $0.stringValue }.joined(separator: ". ")
                
                self.hasFailed.value = SportBookError.customMessage(errorMessage)
            }
        }, onError: { _ in
            self.isLoading.value = false
            self.hasFailed.value = SportBookError.connectionFailure
        }).addDisposableTo(disposeBag)
    }
    
    func loadMyTournamentDetail(tournamentId: Int) -> Observable<TournamentModel> {
        self.isLoading.value = true
        
        return Observable<TournamentModel>.create { observer in
            TournamentProvider.request(.tournament(tournamentId)).subscribe(onNext: {
                [unowned self] response in
                
                self.isLoading.value = false
                
                if 401 == response.statusCode {
                    self.hasFailed.value = SportBookError.unauthenticated
                } else if 200..<300 ~= response.statusCode {
                    let jsonObject = JSON(response.data)
                    print(jsonObject)
                    
                    let detailTournament = TournamentModel(jsonObject)
                    
                    observer.onNext(detailTournament)
                    observer.onCompleted()
                } else {
                    let errorMessage = JSON(response.data)["errors"].arrayValue
                        .map { $0.stringValue }.joined(separator: ". ")
                    
                    self.hasFailed.value = SportBookError.customMessage(errorMessage)
                }}, onError: { error in
                    print(error)
                    self.isLoading.value = false
                    self.hasFailed.value = SportBookError.connectionFailure
            }).addDisposableTo(self.disposeBag)
            
            return Disposables.create()
        }
    }
}

//
//  TournamentViewModel.swift
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

class TournamentViewModel {
    
    private let disposeBag = DisposeBag()
    
    let isLoading = Variable<Bool>(false)
    
    let hasFailed = Variable<SportBookError>(SportBookError.none)
    
    let tournaments = Variable<[TournamentModel]>([])
    
    let myTournaments = Variable<[TournamentModel]>([])
    
    func loadTournaments() {
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

        
        let allTournamentsRequest = TournamentProvider.request(.tournaments)
        
        allTournamentsRequest.subscribe(onNext: {
            [unowned self] response in
            
            self.isLoading.value = false
            
            if 401 == response.statusCode {
                self.hasFailed.value = SportBookError.unauthenticated
            } else if 200..<300 ~= response.statusCode {
                let jsonObject = JSON(response.data)
                
                print(jsonObject)
                
                let tournamentArray = jsonObject["_embedded"]["tournaments"].arrayValue
                    .map { jsonObject in
                        return TournamentModel(jsonObject)
                }
                
                self.tournaments.value = tournamentArray
            } else {
                let errorMessage = JSON(response.data)["errors"].arrayValue
                    .map { $0.stringValue }.joined(separator: ". ")
                
                self.hasFailed.value = SportBookError.customMessage(errorMessage)
            }}, onError: { _ in
                self.isLoading.value = false
                self.hasFailed.value = SportBookError.connectionFailure
        }).addDisposableTo(self.disposeBag)
    }
}

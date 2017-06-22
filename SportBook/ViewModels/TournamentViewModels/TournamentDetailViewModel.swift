//
//  TournamentDetailViewModel.swift
//  SportBook
//
//  Created by DucBM on 6/7/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import SwiftyJSON

class TournamentDetailViewModel {
    
    private let disposeBag = DisposeBag()
    
    let isLoading = Variable<Bool>(false)
    
    let hasFailed = Variable<SportBookError>(SportBookError.None)
    
    let tournament = Variable<TournamentModel?>(nil)
    
    init(tournament : TournamentModel) {
        self.tournament.value = tournament
    }
    
    func loadTournamentDetail() {
        self.isLoading.value = true
        
        TournamentProvider.request(.tournament((tournament.value?.id)!)).subscribe(onNext: {
            [unowned self] response in
            
            self.isLoading.value = false
            
            if 401 == response.statusCode {
                self.hasFailed.value = SportBookError.Unauthenticated
            } else if 200..<300 ~= response.statusCode {
                let jsonObject = JSON(response.data)
                print(jsonObject)
                
                let detailTournament = TournamentModel(jsonObject)
                
                self.tournament.value = detailTournament
            } else {
                let errorMessage = JSON(response.data)["errors"].arrayValue
                    .map { $0.stringValue }.joined(separator: ". ")
                
                self.hasFailed.value = SportBookError.Custom(errorMessage)
            }}, onError: { error in
                print(error)
                self.isLoading.value = false
                self.hasFailed.value = SportBookError.ConnectionFailure
        }).addDisposableTo(self.disposeBag)
    }
}

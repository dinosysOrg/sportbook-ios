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
    
    let hasFailed = Variable<SportBookError>(SportBookError.none)
    
    let tournament = Variable<TournamentModel?>(nil)
    
    func loadTournamentDetail() {
        self.isLoading.value = true
        
        TournamentProvider.request(.tournament((tournament.value?.id)!)).subscribe(onNext: {
            [unowned self] response in
            
            self.isLoading.value = false
            
            if 401 == response.statusCode {
                self.hasFailed.value = SportBookError.unauthenticated
            } else if 200..<300 ~= response.statusCode {
                let jsonObject = JSON(response.data)
                print(jsonObject)
                
                let detailTournament = TournamentModel(jsonObject)
                
                self.tournament.value = detailTournament
            } else {
                let errorMessage = JSON(response.data)["errors"].arrayValue
                    .map { $0.stringValue }.joined(separator: ". ")
                
                self.hasFailed.value = SportBookError.customMessage(errorMessage)
            }}, onError: { error in
                self.isLoading.value = false
                self.hasFailed.value = SportBookError.connectionFailure
        }).addDisposableTo(self.disposeBag)
    }
    
    func fastSignUpTournament() -> Observable<Bool> {
        
        return Observable<Bool>.create { observer in
            
            let user = UserManager.sharedInstance.user!
            
            TournamentProvider.request(.signupTournament(self.tournament.value!.id, user.name!, Int(user.phoneNumber!)!,
                                                         user.address!, user.skillId!, user.club, user.birthday, nil))
                .subscribe(onNext: { [unowned self] response in
                    
                    if response.statusCode == 0 {
                        self.hasFailed.value = SportBookError.connectionFailure
                        observer.onNext(false)
                    } else if 200..<300 ~= response.statusCode {
                        let jsonObject = JSON(response.data)
                        
                        UserManager.sharedInstance.updateUserInfo(userInfo: jsonObject["user"])
                        
                        observer.onNext(true)
                    } else {
                        let errorMessage = JSON(response.data)["errors"].arrayValue
                            .map { $0.stringValue }.joined(separator: ". ")
                        
                        self.hasFailed.value = SportBookError.customMessage(errorMessage)
                        
                        observer.onNext(false)
                    }}, onError: { error in
                        self.isLoading.value = false
                        self.hasFailed.value = SportBookError.connectionFailure
                }).addDisposableTo(self.disposeBag)
            
            return Disposables.create()
        }
    }
    
}

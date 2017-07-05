//
//  OpponentViewModel.swift
//  SportBook
//
//  Created by Bui Minh Duc on 6/29/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import SwiftyJSON
import RxSwift

class OpponentViewModel : BaseViewModel {
    
    let tournament = Variable<TournamentModel?>(nil)
    
    let myGroups = Variable<[GroupModel]>([])
    
    let otherGroups = Variable<[GroupModel]>([])
    
    func loadOpponentList() -> Observable<Void> {
        return Observable<Void>.create { observer in
            
            TournamentProvider.request(TournamentAPI.opponents(self.tournament.value!.id)).subscribe(onNext: {
                response in
                
                self.isLoading.value = false
                
                if 401 == response.statusCode {
                    self.hasFailed.value = SportBookError.unauthenticated
                } else if 200..<300 ~= response.statusCode {
                    let jsonObject = JSON(response.data)
                    
                    print(jsonObject)
                    
                    let myGroupsArray = jsonObject["my_groups"].arrayValue
                    
                    let otherGroupsArray = jsonObject["other_groups"].arrayValue
                    
                    self.myGroups.value = myGroupsArray.map { GroupModel($0) }
                    
                    self.otherGroups.value = otherGroupsArray.map { GroupModel($0) }
                    
                    observer.onCompleted()
                } else {
                    self.hasFailed.value = SportBookError.apiError(JSON(response.data)["errors"])
                }
                
                observer.onCompleted()
                
                self.isLoading.value = false
                
            }, onError: { error in
                self.isLoading.value = false
                self.hasFailed.value = SportBookError.connectionFailure
            }).addDisposableTo(self.disposeBag)
            
            return Disposables.create()
        }
    }
}

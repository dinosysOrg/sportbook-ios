//
//  InputRankVenueViewModel.swift
//  SportBook
//
//  Created by Bui Minh Duc on 6/27/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftyJSON
import Moya

class InputRankVenueViewModel {
    
    private let disposeBag = DisposeBag()
    
    var tournament : TournamentModel?
    
    let rows = ["", TimeBlock.morning.description, TimeBlock.afternoon.description , TimeBlock.evening.description]
    
    let columns = ["", DayOfWeek.sunday.shortDescription, DayOfWeek.monday.shortDescription, DayOfWeek.tuesday.shortDescription, DayOfWeek.wednesday.shortDescription,
                   DayOfWeek.thursday.shortDescription, DayOfWeek.friday.shortDescription, DayOfWeek.saturday.shortDescription]
    
    func updateTimeSlotAndRankVenue() -> Observable<Bool> {
        return Observable<Bool>.create { observer in
            
            guard let myTeam = self.tournament?.myTeam else {
                observer.onNext(false)
                
                return Disposables.create()
            }
            
            TeamProvider.request(.teams(myTeam.id, [1,2,3,4], [DayOfWeek.sunday.rawValue: [TimeBlock.morning.times]]))
                .subscribe(onNext: { response in
                    let jsonObject = JSON(response.data)
                    print(jsonObject)
                }).addDisposableTo(self.disposeBag)
            
            return Disposables.create()
        }
    }
}


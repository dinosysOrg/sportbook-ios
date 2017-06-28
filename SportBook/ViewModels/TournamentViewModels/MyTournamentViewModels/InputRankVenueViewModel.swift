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
    
    let isLoading = Variable<Bool>(false)
    
    let hasFailed = Variable<SportBookError>(SportBookError.none)
    
    let tournament = Variable<TournamentModel?>(nil)
    
    let timeSlots = [TimeSlot(day: .sunday), TimeSlot(day: .monday), TimeSlot(day: .tuesday),
                     TimeSlot(day: .wednesday), TimeSlot(day: .thursday),
                     TimeSlot(day: .friday), TimeSlot(day: .saturday)]
    
    let timeBlocks = [TimeBlock.morning, TimeBlock.afternoon, TimeBlock.evening]
    
    func updateTimeSlotAndRankVenue() -> Observable<Bool> {
        return Observable<Bool>.create { observer in
            
            guard let myTeam = self.tournament.value?.myTeam else {
                observer.onNext(false)
                
                return Disposables.create()
            }
            
            let selectedTimeSlots = self.timeSlots.filter { $0.blocks.count > 0 }
            
            if selectedTimeSlots.count > 0 {
                var timeSlotsJson = [String: Any]()
                
                for timeSlot in selectedTimeSlots {
                    timeSlotsJson[timeSlot.day.rawValue] = timeSlot.blocks.map { $0.times }
                }
                
                TeamProvider.request(.teams(myTeam.id, [1,2,3,4], timeSlotsJson))
                    .subscribe(onNext: { response in
                        self.isLoading.value = false
                        
                        if 401 == response.statusCode {
                            self.hasFailed.value = SportBookError.unauthenticated
                            observer.onNext(true)
                        } else if 200..<300 ~= response.statusCode {
                            let jsonObject = JSON(response.data)
                            print(jsonObject)
                            
                            observer.onNext(true)
                        } else {
                            let errorMessage = JSON(response.data)["errors"].arrayValue
                                .map { $0.stringValue }.joined(separator: ". ")
                            
                            self.hasFailed.value = SportBookError.customMessage(errorMessage)
                            observer.onNext(true)
                        }}, onError: { error in
                            observer.onNext(false)
                            self.isLoading.value = false
                            self.hasFailed.value = SportBookError.connectionFailure
                    }).addDisposableTo(self.disposeBag)
            } else {
                self.hasFailed.value = SportBookError.customMessage("no_time_slot_selected".localized)
                observer.onNext(false)
            }
            
            return Disposables.create()
        }
    }
}


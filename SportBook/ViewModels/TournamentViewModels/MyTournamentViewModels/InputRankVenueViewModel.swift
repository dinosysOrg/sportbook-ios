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

class InputRankVenueViewModel : BaseViewModel {
    
    let tournament = Variable<TournamentModel?>(nil)
    
    let timeSlots = [TimeSlot(day: .sunday), TimeSlot(day: .monday), TimeSlot(day: .tuesday),
                     TimeSlot(day: .wednesday), TimeSlot(day: .thursday),
                     TimeSlot(day: .friday), TimeSlot(day: .saturday)]
    
    let timeBlocks = [TimeBlock.morning, TimeBlock.afternoon, TimeBlock.evening]
    
    func loadTimeSlot() -> Observable<Void> {
        return Observable<Void>.create { observer in
            
            guard let myTeam = self.tournament.value?.myTeam else {
                observer.onCompleted()
                return Disposables.create()
            }
            
            self.isLoading.value = true
            
            TeamProvider.request(TeamAPI.timeSlot("type", myTeam.id))
                .subscribe(onNext: { response in
                    self.isLoading.value = false
                    
                    if 401 == response.statusCode {
                        self.hasFailed.value = SportBookError.unauthenticated
                    } else if 200..<300 ~= response.statusCode {
                        let jsonObject = JSON(response.data)
                        print(jsonObject)
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
    
    func updateTimeSlotAndRankVenue() -> Observable<Void> {
        return Observable<Void>.create { observer in
            
            guard let myTeam = self.tournament.value?.myTeam else {
                observer.onCompleted()
                return Disposables.create()
            }
            
            let selectedTimeSlots = self.timeSlots.filter { $0.blocks.count > 0 }
            
            let timeSlotCount = selectedTimeSlots.map { $0.blocks.count }.reduce(0, +)
            
            if selectedTimeSlots.count > 0 && timeSlotCount >= 5 {
                
                self.isLoading.value = true
                
                var timeSlotsJson = [String: Any]()
                
                for timeSlot in selectedTimeSlots {
                    timeSlotsJson[timeSlot.day.rawValue] = timeSlot.blocks.map { $0.times }
                }
                
                TeamProvider.request(.teams(myTeam.id, [1,2,3,4], timeSlotsJson))
                    .subscribe(onNext: { response in
                        self.isLoading.value = false
                        
                        if 401 == response.statusCode {
                            self.hasFailed.value = SportBookError.unauthenticated
                        } else if 200..<300 ~= response.statusCode {
                            let jsonObject = JSON(response.data)
                            print(jsonObject)
                        } else {
                            let errorMessage = JSON(response.data)["errors"].arrayValue
                                .map { $0.stringValue }.joined(separator: ". ")
                            
                            self.hasFailed.value = SportBookError.customMessage(errorMessage)
                        }
                        
                        observer.onCompleted()
                        
                    }, onError: { error in
                        self.isLoading.value = false
                        self.hasFailed.value = SportBookError.connectionFailure
                    }).addDisposableTo(self.disposeBag)
            } else {
                self.hasFailed.value = SportBookError.customMessage("time_slot_minimum_required".localized)
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
}


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
    
    let hasUpdatedTimeBlocks = Variable<Bool>(true)
    
    func loadTimeBlocks() -> Observable<Void> {
        return Observable<Void>.create { observer in
            
            guard let myTeam = self.tournament.value?.myTeam else {
                observer.onCompleted()
                return Disposables.create()
            }
            
            self.isLoading.value = true
            
            TeamProvider.request(TeamAPI.timeBlock(myTeam.id))
                .subscribe(onNext: { response in
                    self.isLoading.value = false
                    
                    if 401 == response.statusCode {
                        self.hasFailed.value = SportBookError.unauthenticated
                    } else if 200..<300 ~= response.statusCode {
                        let jsonObject = JSON(response.data)
                        print(jsonObject)
                        
                        let preferredTimeBlocks = jsonObject["preferred_time_blocks"]
                        
                        if let sundayBlocks = preferredTimeBlocks[DayOfWeek.sunday.rawValue].arrayObject as? [[Int]] {
                            self.timeSlots[0].blocks = sundayBlocks.map { TimeBlock.parse($0) }
                        }
                        
                        if let mondayBlocks = preferredTimeBlocks[DayOfWeek.monday.rawValue].arrayObject as? [[Int]] {
                            self.timeSlots[1].blocks = mondayBlocks.map { TimeBlock.parse($0) }
                        }
                        
                        if let tuesdayBlocks = preferredTimeBlocks[DayOfWeek.tuesday.rawValue].arrayObject as? [[Int]] {
                            self.timeSlots[2].blocks = tuesdayBlocks.map { TimeBlock.parse($0) }
                        }
                        
                        if let wednesdayBlocks = preferredTimeBlocks[DayOfWeek.wednesday.rawValue].arrayObject as? [[Int]] {
                            self.timeSlots[3].blocks = wednesdayBlocks.map { TimeBlock.parse($0) }
                        }
                        
                        if let thursdayBlocks = preferredTimeBlocks[DayOfWeek.thursday.rawValue].arrayObject as? [[Int]] {
                            self.timeSlots[4].blocks = thursdayBlocks.map { TimeBlock.parse($0) }
                        }
                        
                        if let fridayBlocks = preferredTimeBlocks[DayOfWeek.friday.rawValue].arrayObject as? [[Int]] {
                            self.timeSlots[5].blocks = fridayBlocks.map { TimeBlock.parse($0) }
                        }
                        
                        if let saturdayBlocks = preferredTimeBlocks[DayOfWeek.saturday.rawValue].arrayObject as? [[Int]] {
                            self.timeSlots[6].blocks = saturdayBlocks.map { TimeBlock.parse($0) }
                        }
                        
                        self.hasUpdatedTimeBlocks.value = self.timeSlots.filter { $0.blocks.count > 0 }.map { $0.blocks.count }.reduce(0, +) > 0
                        
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
    
    func updateTimeBlockAndRankVenue() -> Observable<Void> {
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
                
                selectedTimeSlots.forEach({ timeSlot in
                     timeSlotsJson[timeSlot.day.rawValue] = timeSlot.blocks.map { $0.times }
                })
                
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


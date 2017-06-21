//
//  TournamentSignUpViewModel.swift
//  SportBook
//
//  Created by DucBM on 6/7/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import Foundation
import SwiftyJSON
import RxCocoa
import RxSwift
import Moya

class TournamentSignUpViewModel {
    
    fileprivate let disposeBag = DisposeBag()
    
    let tournament : TournamentModel
    
    let isLoading = Variable<Bool>(false)
    
    let hasFailed = Variable<SportBookError>(SportBookError.None)
    
    let skills = Variable<[SkillModel]>([])
    
    let cities = Variable<[City]>([])
    
    let skill = Variable<SkillModel?>(nil)
    
    let selectedCity = Variable<City?>(nil)
    
    //Variables for validation
    let firstNameValid: Driver<Bool>
    
    let lastNameValid: Driver<Bool>
    
    let phoneNumberValid: Driver<Bool>
    
    let stepOneCredentialsValid: Driver<Bool>
    
    init(tournament : TournamentModel, firstNameText: Driver<String>, lastNameText: Driver<String>,
         phoneNumberText: Driver<String>) {
        self.tournament = tournament
        
        firstNameValid = firstNameText
            .distinctUntilChanged()
            .throttle(0.3)
            .map { $0.utf8.count >= 2 }.skip(1)
        
        lastNameValid = lastNameText
            .distinctUntilChanged()
            .throttle(0.3)
            .map { $0.utf8.count >= 2 }.skip(1)
        
        phoneNumberValid = phoneNumberText
                .distinctUntilChanged()
                .throttle(0.3)
                .map(Validation.phoneValid).skip(1)
        
        stepOneCredentialsValid = Driver.combineLatest(firstNameValid, lastNameValid, phoneNumberValid) { $0 && $1 && $2 }.startWith(false)
    }
    
    func loadCities() {
        do {
            if let file = Bundle.main.url(forResource: "cities", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let citiesJsonArray = JSON(data)
                
                var citiesArray = [City]()
                
                for cityJson in citiesJsonArray.arrayValue {
                    let city = City(jsonData: cityJson)
                    citiesArray.append(city)
                }
                
                self.cities.value = citiesArray
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func loadSkills() {
        self.isLoading.value = true
        
        SkillProvider.request(.skills).subscribe(onNext: { response in
            
            self.isLoading.value = false
            
            if 401 == response.statusCode {
                self.hasFailed.value = SportBookError.Unauthenticated
            } else if 200..<300 ~= response.statusCode {
                let jsonObject = JSON(response.data)
                let skillArray = jsonObject["_embedded"]["skills"].arrayValue
                    .map { jsonObject in
                        return SkillModel(jsonObject)
                }
                
                self.skills.value = skillArray
                self.skill.value = self.skills.value.first
            } else {
                let errorMessage = JSON(response.data)["errors"].arrayValue
                    .map { $0.stringValue }.joined(separator: ". ")
                
                self.hasFailed.value = SportBookError.Custom(errorMessage)
            }
        }, onError: { error in
            self.isLoading.value = false
            self.hasFailed.value = SportBookError.ConnectionFailure
        }).addDisposableTo(disposeBag)
    }
    
    func signUpTournament(with name: String, phoneNumber: Int, address: String, club: String? = nil, birthday: String? = nil, members: [Int]? = nil) -> Observable<Bool> {
        
        return Observable<Bool>.create { observer in
            
            TournamentProvider.request(.signupTournament(self.tournament.id, name, phoneNumber,
                                                         address, self.skill.value!.id, club, birthday, members))
                .subscribe(onNext: { [unowned self] response in
                
                if response.statusCode == 0 {
                    self.hasFailed.value = SportBookError.ConnectionFailure
                    observer.onNext(false)
                } else if 200..<300 ~= response.statusCode {
                    observer.onNext(true)
                } else {
                    let errorMessage = JSON(response.data)["errors"].arrayValue
                        .map { $0.stringValue }.joined(separator: ". ")
                    
                    self.hasFailed.value = SportBookError.Custom(errorMessage)
                    
                    observer.onNext(false)
                }
            }).addDisposableTo(self.disposeBag)
            
            return Disposables.create()
        }
    }
}

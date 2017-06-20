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
  
    let isLoading = Variable<Bool>(false)
    
    let hasFailed = Variable<SportBookError>(SportBookError.None)
    
    let tournament = Variable<TournamentModel?>(nil)
    
    let skills = Variable<[SkillModel]>([])
    
    let cities = Variable<[City]>([])
    
    //Variables for sign up tournament
    let firstName = Variable<String>("")
    
    let lastName = Variable<String>("")
    
    let fullName = Variable<String>("")
    
    let city = Variable<City?>(nil)
    
    let district = Variable<String>("")
    
    let address = Variable<String>("")
    
    let club = Variable<String>("")
    
    let birthDate = Variable<String>("")
    
    init(tournament : TournamentModel) {
        self.tournament.value = tournament
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
            } else {
                let errorMessage = JSON(response)["errors"]["full_messages"]
                    .arrayValue.map { $0.stringValue }.joined(separator: ". ")
                
                self.hasFailed.value = SportBookError.Custom(errorMessage)
            }
        }, onError: { error in
            self.isLoading.value = false
            self.hasFailed.value = SportBookError.ConnectionFailure
        }).addDisposableTo(disposeBag)
    }
    
    func signUpTournament() {


        
    }
}

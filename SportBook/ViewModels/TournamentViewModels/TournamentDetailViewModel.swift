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
    
    let disposeBag = DisposeBag()
    
    var tournament : TournamentModel!
    
    init(tournament : TournamentModel) {
        self.tournament = tournament
    }
}

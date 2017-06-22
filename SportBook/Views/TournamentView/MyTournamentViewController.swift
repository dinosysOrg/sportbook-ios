//
//  MyTournamentViewController.swift
//  SportBook
//
//  Created by DucBM on 6/6/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MyTournamentViewController : BaseViewController {
    
    var myTournaments = [TournamentModel]()
    
    fileprivate let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        self.configureViewModel()
        self.configureBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    func configureViewModel() {
    }
    
    private func configureBindings() {
    }
}


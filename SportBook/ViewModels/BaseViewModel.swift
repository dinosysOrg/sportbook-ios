//
//  BaseViewModel.swift
//  SportBook
//
//  Created by Bui Minh Duc on 6/29/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import SwiftyJSON
import RxSwift
import RxCocoa

class BaseViewModel {
    let disposeBag = DisposeBag()
    
    let isLoading = Variable<Bool>(false)
    
    let loadingText = Variable<String>("loading".localized)
    
    let hasFailed = Variable<SportBookError>(SportBookError.none)
}

//
//  UIViewController+Extension.swift
//  SportBook
//
//  Created by Bui Minh Duc on 6/23/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import UIKit
import RxSwift

extension UIViewController {
    func alert(text: String?) -> Observable<Void> {
        return alert(title: "application_name".localized, text: text)
    }
    
    func alertConfirm(text: String?) -> Observable<Bool> {
        return alertConfirm(title: "application_name".localized, text: text)
    }
    
    func alertError(text: String?) -> Observable<Void> {
        return alert(title: "error_title".localized, text: text)
    }
    
    func alert(title: String, text: String?) -> Observable<Void> {
        return Observable.create { [weak self] observer in
            let alertViewController = UIAlertController(title: title, message: text, preferredStyle: .alert)
            alertViewController.addAction(UIAlertAction(title: "close".localized, style: .default, handler: {_ in
                observer.onCompleted()
            }))
            self?.present(alertViewController, animated: true, completion: nil)
            return Disposables.create()
        }
    }
    
    func alertConfirm(title: String? = "application_name".localized, text: String?) -> Observable<Bool> {
        return Observable.create { [weak self] observer in
            let alertViewController = UIAlertController(title: title, message: text, preferredStyle: .alert)
            alertViewController.addAction(UIAlertAction(title: "ok".localized, style: .default, handler: {_ in
                observer.onNext(true)
                observer.onCompleted()
            }))
            
            alertViewController.addAction(UIAlertAction(title: "cancel".localized, style: .default, handler: {_ in
                observer.onNext(false)
                observer.onCompleted()
            }))
            
            self?.present(alertViewController, animated: true, completion: nil)
            return Disposables.create()
        }
    }
}

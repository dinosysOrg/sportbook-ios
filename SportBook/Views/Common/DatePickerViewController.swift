//
//  DatePickerViewController.swift
//  SportBook
//
//  Created by DucBM on 6/15/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class DatePickerViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var btnDone: UIButton!
    
    @IBOutlet weak var btnCancel: UIButton!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let doneTap = btnDone.rx.tap
        
        let cancelTap = btnCancel.rx.tap
        
        Observable.of(doneTap, cancelTap).merge()
            .subscribe(onNext: { [unowned self] _ in
            self.dismiss(animated: true, completion: {
            })}).addDisposableTo(disposeBag)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

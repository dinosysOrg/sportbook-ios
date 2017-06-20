//
//  PickerViewControler.swift
//  SportBook
//
//  Created by DucBM on 6/19/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class PickerViewControler: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: public properties
    var selectedIndex: Observable<Int> {
        return selectedIndexSubject.asObservable()
    }
    
    // MARK: private properties
    fileprivate let disposeBag = DisposeBag()
    
    fileprivate let selectedIndexSubject = PublishSubject<Int>()
    
    fileprivate let pickerData = Variable<[String]>([])
    
    @IBOutlet weak var btnCancel: UIButton!
    
    @IBOutlet weak var btnDone: UIButton!
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        
        // Do any additional setup after loading the view.
        let cancelTap = btnCancel.rx.tap
        let doneTap = btnDone.rx.tap
        
        Observable.of(cancelTap, doneTap).merge().subscribe(onNext: {
            [unowned self] _ in
            self.dismiss(animated: true, completion: { })
        }).addDisposableTo(disposeBag)
        
        pickerData.asObservable().subscribe(onNext: {
            [unowned self] _ in
            self.pickerView.reloadAllComponents()
        }).addDisposableTo(disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.pickerView.reloadAllComponents()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setPickerData(data: [String]) {
        self.pickerData.value = data
        self.selectedIndexSubject.onNext(0)
    }
    
    //MARK: PickerView
    
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.value.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData.value[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedIndexSubject.onNext(row)
    }
}

//
//  InputRankVenueViewController.swift
//  SportBook
//
//  Created by Bui Minh Duc on 6/26/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class InputRankVenueViewController: BaseViewController {
    
    var currentTournament : TournamentModel?
    
    let viewModel = InputRankVenueViewModel()
    
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var timeSlotHeaderView: UIView!
    
    @IBOutlet weak var lblTimeSlotHeader: UILabel!
    
    @IBOutlet weak var btnSubmit: UIButton!
    
    // MARK: CollectionView
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = self.currentTournament?.name
        
        self.configureUI()
        self.configureViewModel()
        self.configureBindings()
        self.loadTimeSlot()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    private func configureViewModel() {
        self.viewModel.tournament.value = self.currentTournament
    }
    
    private func configureBindings() {
        self.btnSubmit.setTitle("submit".localized.uppercased(), for: .normal)
        
        let submitTap = self.btnSubmit.rx.tap
        
        submitTap.asObservable()
            .flatMap { _ in return self.alertConfirm(text: "update_time_slot_confirm".localized) }
            .filter { $0 }
            .flatMap { _ in return self.viewModel.updateTimeSlotAndRankVenue() }
            .subscribe(onCompleted: { _ in}).addDisposableTo(self.disposeBag)
        
        self.viewModel.hasFailed.asObservable().skip(1).subscribe(onNext: { [unowned self] error in
            if case SportBookError.unauthenticated = error {
                AuthManager.sharedInstance.clearSession()
                
                //Present login view controller
                let loginViewController = UIStoryboard.loadLoginViewController()
                self.tabBarController?.present(loginViewController, animated: true, completion: { })
            } else {
                self.alertError(text: error.description).subscribe(onCompleted: {})
                    .addDisposableTo(self.disposeBag)
            }
        }).disposed(by: disposeBag)
    }
    
    private func configureUI(){
        self.lblTimeSlotHeader.text = "input_time_range".localized
    }
    
    func loadTimeSlot(){
        self.viewModel.loadTimeSlot().subscribe(onCompleted: { _ in}).addDisposableTo(self.disposeBag)
    }
}

extension InputRankVenueViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.viewModel.timeBlocks.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.timeSlots.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let row = indexPath.section
        let column = indexPath.row
        
        if row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeekDayCell", for: indexPath) as! WeekDayCell
            
            cell.lblWeekDay.text = column > 0 ? self.viewModel.timeSlots[column - 1].day.shortDescription : ""
            
            return cell
        } else {
            if column == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeBlockCell", for: indexPath) as! TimeBlockCell
                
                cell.lblTimeBlock.text = self.viewModel.timeBlocks[row - 1].description
                
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeSlotCell", for: indexPath) as! TimeSlotCell
                
                let timeSlot = self.viewModel.timeSlots[column - 1]
                let timeBlock = self.viewModel.timeBlocks[row - 1]
                
                cell.select(selected: timeSlot.blocks.contains(timeBlock))
                
                return cell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let row = indexPath.section
        let column = indexPath.row
        
        switch row {
        case 0:
            if column > 0 {
                cell.layer.addBorder(edge: .left, color: .lightGray, thickness: 1)
            }
        default:
            if column == 0 {
                cell.layer.addBorder(edge: .top, color: .lightGray, thickness: 1)
            } else {
                cell.layer.addBorder(edge: .top, color: .lightGray, thickness: 1)
                cell.layer.addBorder(edge: .left, color: .lightGray, thickness: 1)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row = indexPath.section
        let column = indexPath.row
        
        if row > 0 && column > 0 {
            
            if let cell = collectionView.cellForItem(at: indexPath) as? TimeSlotCell {
                let timeSlot = self.viewModel.timeSlots[column - 1]
                let timeBlock = self.viewModel.timeBlocks[row - 1]
                
                if let timeblockIndex = timeSlot.blocks.index(of: timeBlock) {
                    timeSlot.blocks.remove(at: timeblockIndex)
                    cell.select(selected: false)
                } else {
                    timeSlot.blocks.append(timeBlock)
                    cell.select(selected: true)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let column = indexPath.row
        
        let viewWidth = collectionView.frame.width
        
        var cellWidth =  floorf(Float(viewWidth * 0.1))
        let cellheight = CGFloat(cellWidth)
        
        if column == 0 {
            cellWidth = floorf(Float(viewWidth * 0.3))
        }
        
        let collectionViewHeight =  cellheight * 4
        
        //Update collection view height ony one times
        if self.collectionViewHeightConstraint.constant != collectionViewHeight {
            self.collectionViewHeightConstraint.constant = collectionViewHeight
        }
        
        return CGSize(width: CGFloat(cellWidth), height: cellheight)
    }
}

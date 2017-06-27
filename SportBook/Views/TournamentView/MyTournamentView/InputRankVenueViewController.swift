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

class InputRankVenueViewController: UIViewController {
    
    var currentTournament : TournamentModel?
    
    let viewModel = InputRankVenueViewModel()
    
    private let disposebag = DisposeBag()
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var timeSlotHeaderView: UIView!
    
    @IBOutlet weak var lblTimeSlotHeader: UILabel!
    
    @IBOutlet weak var btnSubmit: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.configureUI()
        self.configureViewModel()
        self.configureBindings()
        
        self.viewModel.updateTimeSlotAndRankVenue().subscribe(onNext: { success in
            if success {
                print("Update time slot and rank venue success!")
            }
        }).addDisposableTo(disposebag)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func configureViewModel() {
        self.viewModel.tournament = self.currentTournament
    }
    
    private func configureBindings() {
        self.btnSubmit.setTitle("submit".localized.uppercased(), for: .normal)
    }
    
    private func configureUI(){
        
    }
}

extension InputRankVenueViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.viewModel.rows.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.columns.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let row = indexPath.section
        let column = indexPath.row
        
        switch row {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeekDayCell", for: indexPath) as! WeekDayCell
            
            cell.lblWeekDay.text = column > 0 ? self.viewModel.columns[column] : ""
            
            return cell
        default:
            if column == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeBlockCell", for: indexPath) as! TimeBlockCell
                
                cell.lblTimeBlock.text = self.viewModel.rows[row]
                
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeSlotCell", for: indexPath) as! TimeSlotCell
                
                cell.select(selected: false)
                
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
                cell.select(selected: true)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let column = indexPath.row
        
        let viewWidth = collectionView.frame.width
        
        let timeSlotWidth = viewWidth / 10
        var cellWidth : CGFloat = 0
        
        if column == 0 {
            cellWidth = timeSlotWidth * 3
        } else {
            cellWidth = timeSlotWidth
        }
        
        return CGSize(width: cellWidth, height: timeSlotWidth)
    }
}

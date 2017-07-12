//
//  ResultViewController.swift
//  SportBook
//
//  Created by Bui Minh Duc on 6/26/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ResultViewController: BaseViewController {
    
    var currentTournament : TournamentModel?
    
    let disposeBag = DisposeBag()
    
    let resultCellHeight : CGFloat = 72
    
    let collapsedCellHeight : CGFloat = 0

    let sectionHeaderHeight : CGFloat = 50
    
    @IBOutlet weak var stageContainerView: UIView!
    
    @IBOutlet weak var btnPrevious: UIButton!
    
    @IBOutlet weak var btnNext: UIButton!
    
    @IBOutlet weak var lblStage: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    //Fake data
    var yourGroup : Section!
    var otherGroups = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "tournament_result".localized
        
        //Init fake data
        yourGroup = Section(name: "Group A", items: ["Thích Lập Trình", "Thích Test App", "Thích Fix Bug", "Thích Ăn Ngủ"])
        
        otherGroups = [
            Section(name: "Group B", items: ["Bùi Minh Đức", "Bùi Minh Nhật", "Bùi Minh Thái", "Bùi Minh Thành"]),
            Section(name: "Group C", items: ["Bùi Văn Ba", "Bùi Văn Bốn", "Bùi Văn Năm", "Bùi Văn Sáu"]),
            Section(name: "Group D", items: ["Bùi Yêu Nước", "Bùi Thương Nòi", "Bùi Biển Đông", "Bùi Hải Đảo"])
        ]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

extension ResultViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:  return "Your Group - Group A"
        case 1:  return "Other Groups"
        default: return ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.yourGroup.items.count
        }
        
        // For the second section , the total count is items count plus the number of headers
        let groupCount = otherGroups.count
        
        let teamCount = otherGroups.map { $0.items.count } .reduce(0, +)
        
        return groupCount + teamCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell") as! ResultCell!
            cell?.lblTeamName.text = yourGroup.items[indexPath.row]
            return cell!
        }
        
        // Calculate the real section index and row index of items
        let section = getSectionIndex(indexPath.row)
        let row = getRowIndex(indexPath.row)
        
        if row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CollapsibleHeaderCell") as! CollapsibleHeaderCell
            
            cell.titleLabel.text = otherGroups[section].name
            cell.toggleButton.tag = section
            cell.toggleButton.setTitle(otherGroups[section].collapsed! ? "+" : "-", for: UIControlState())
            cell.toggleButton.addTarget(self, action: #selector(self.toggleCollapse), for: .touchUpInside)
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell") as! ResultCell!
            cell?.lblTeamName.text = otherGroups[section].items[row - 1]
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // Section = 0 means your groups
        if indexPath.section == 0 {
            return self.resultCellHeight
        }
        
        // Calculate the real section index and row index
        let section = getSectionIndex(indexPath.row)
        let row = getRowIndex(indexPath.row)
        
        // Row == 0 is header
        if row == 0 {
            return self.sectionHeaderHeight
        }
        
        return otherGroups[section].collapsed! ? self.collapsedCellHeight : self.resultCellHeight
    }
    
    // Toggle collapse teams in group
    func toggleCollapse(_ sender: UIButton) {
        let section = sender.tag
        let collapsed = otherGroups[section].collapsed
        
        // Toggle collapse
        otherGroups[section].collapsed = !collapsed!
        
        let indices = getHeaderIndices()
        
        let start = indices[section]
        let end = start + otherGroups[section].items.count
        
        tableView.beginUpdates()
        for i in start ..< end + 1 {
            tableView.reloadRows(at: [IndexPath(row: i, section: 1)], with: .automatic)
        }
        tableView.endUpdates()
    }
    
    // MARK: Helper func
    
    // Calculate the real section index
    func getSectionIndex(_ row: NSInteger) -> Int {
        let indices = getHeaderIndices()
        
        for i in 0..<indices.count {
            if i == indices.count - 1 || row < indices[i + 1] {
                return i
            }
        }
        
        return -1
    }
    
    // Calculate the real row index
    func getRowIndex(_ row: NSInteger) -> Int {
        var index = row
        let indices = getHeaderIndices()
        
        for i in 0..<indices.count {
            if i == indices.count - 1 || row < indices[i + 1] {
                index -= indices[i]
                break
            }
        }
        
        return index
    }
    
    // Get array of groups (header) counter
    func getHeaderIndices() -> [Int] {
        var index = 0
        var indices: [Int] = []
        
        for section in otherGroups {
            indices.append(index)
            index += section.items.count + 1
        }
        
        return indices
    }
}

//
//  SignUpTournamentViewController.swift
//  SportBook
//
//  Created by DucBM on 6/8/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import DLRadioButton
import RxSwift
import RxCocoa

public enum SignUpTournamentStep {
    case inputForm
    case selectSkill
}

class SignUpTournamentViewController : BaseViewController {
    
    var signUpViewModel : TournamentSignUpViewModel!
    
    var signUpStep = SignUpTournamentStep.inputForm
    
    fileprivate let disposeBag = DisposeBag()
    
    //MARK: Progress View
    
    let stepOneProgressImage = UIImage(named: "progress_stage_1")
    let stepTwoProgressImage = UIImage(named: "progress_stage_2")
    
    @IBOutlet weak var imgProgress: UIImageView!
    
    //MARK: Sign Up Form
    @IBOutlet weak var formContainerView: UIView!
    
    @IBOutlet weak var lblEmail: UILabel!
    
    @IBOutlet weak var tfName: SkyFloatingLabelTextField!
    
    @IBOutlet weak var tfPhoneNumber: SkyFloatingLabelTextField!
    
    @IBOutlet weak var tfAddress: SkyFloatingLabelTextField!
    
    @IBOutlet weak var tfDateOfBirth: SkyFloatingLabelTextField!
    
    @IBOutlet weak var tfClub: SkyFloatingLabelTextField!
    
    @IBOutlet weak var btnNext: UIButton!
    
    //MARK: Skill Selection
    @IBOutlet weak var skillContainerView: UIView!
    
    @IBOutlet weak var skillTableView: UITableView!
    
    @IBOutlet weak var btnSubmit: UIButton!
    
    let skills = ["Master", "Pro" ,"Semi-pro" ,"Amateur" ,"Beginner"]
    
    let skillCell = "SkillCell"
    
    let skillCellHeight : CGFloat = 40
    
    var selectedSkillIndex = -1
    
    override func viewDidLoad() {
        //Set basic info and load tournament detail
        let userInfo = UserManager.sharedInstance.User
        
        lblEmail.text = userInfo?.email
        
        tfName.title = "name".localized
        tfName.placeholder = "name".localized
        tfPhoneNumber.title = "phone".localized
        tfPhoneNumber.placeholder = "phone".localized
        tfAddress.title = "address".localized
        tfAddress.placeholder = "address".localized
        tfDateOfBirth.title = "birthdate".localized
        tfDateOfBirth.placeholder = "birthdate".localized
        tfClub.title = "club".localized
        tfClub.placeholder = "club".localized
    
        showInputFormView()
        
        let nextTap = btnNext.rx.tap
        
        let submitTap = btnSubmit.rx.tap
        
        Observable.from([nextTap, submitTap]).asObservable().subscribe(onNext: { [unowned self] _ in
            self.dismissKeyboard()
        }).addDisposableTo(disposeBag)
        
        nextTap.subscribe(onNext: { [unowned self] _ in
            self.showSkillSelectionView()
        }).addDisposableTo(disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        let backButton = UIBarButtonItem(title: "back".localized, style: .plain, target: self, action: #selector(self.navigateBack(sender:)))
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismissKeyboard()
    }
    
    func navigateBack(sender: AnyObject) {
        if signUpStep == .inputForm {
            //Display confirm dialog to cancle sign up tournament
            //Yes: Navigate back to tournament detail
            //No: Dismiss dialog
            self.navigationController?.popViewController(animated: true)
        } else {
            self.showInputFormView()
        }
    }
    
    func showInputFormView(){
        self.signUpStep = .inputForm
        
        self.skillContainerView.isHidden = true
        self.formContainerView.isHidden = false
        
        self.imgProgress.image = stepOneProgressImage
    }
    
    func showSkillSelectionView() {
        self.signUpStep = .selectSkill
        
        self.skillContainerView.isHidden = false
        self.formContainerView.isHidden = true
        
        self.imgProgress.image = stepTwoProgressImage
    }
}

//MARK: Sign Up Form
extension SignUpTournamentViewController {
    
}

//MARK: Skill Selection

extension SignUpTournamentViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return skills.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        let skill = SkillModel(skills[row])
        
        let cell = tableView.dequeueReusableCell(withIdentifier: skillCell)
            as! SkillCell
        
        cell.configure(skill: skill)
        
        if row == selectedSkillIndex {
            cell.select()
        } else {
            cell.deselect()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SkillCell
        
        cell.deselect()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedSkillIndex = indexPath.row
        
        let cell = tableView.cellForRow(at: indexPath) as! SkillCell
        
        cell.select()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return skillCellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}

//
//  SignUpTournamentViewController.swift
//  SportBook
//
//  Created by DucBM on 6/8/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SkyFloatingLabelTextField

public enum SignUpTournamentStep {
    case inputForm
    case selectSkill
}

class SignUpTournamentViewController : BaseViewController {
    
    var currentTournament : TournamentModel?
    
    fileprivate var viewModel : TournamentSignUpViewModel!
    
    fileprivate var signUpStep = SignUpTournamentStep.inputForm
    
    fileprivate let disposeBag = DisposeBag()
    
    //MARK: Progress View
    
    fileprivate let stepOneProgressImage = UIImage(named: "progress_stage_1")
    fileprivate let stepTwoProgressImage = UIImage(named: "progress_stage_2")
    
    @IBOutlet weak var imgProgress: UIImageView!
    
    //MARK: Sign Up Form
    @IBOutlet weak var formContainerView: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var tfEmail: SkyFloatingLabelTextField!
    
    @IBOutlet weak var tfFirstName: SkyFloatingLabelTextField!
    
    @IBOutlet weak var tfLastName: SkyFloatingLabelTextField!
    
    @IBOutlet weak var tfPhoneNumber: SkyFloatingLabelTextField!
    
    @IBOutlet weak var tfAddress: SkyFloatingLabelTextField!
    
    @IBOutlet weak var tfDateOfBirth: SkyFloatingLabelTextField!
    
    @IBOutlet weak var tfClub: SkyFloatingLabelTextField!
    
    @IBOutlet weak var btnNext: UIButton!
    
    //MARK: Skill Selection
    @IBOutlet weak var skillContainerView: UIView!
    
    @IBOutlet weak var skillTableView: UITableView!
    
    @IBOutlet weak var lblPickSkill: UILabel!
    
    @IBOutlet weak var lblNotice: UILabel!
    
    @IBOutlet weak var btnSubmit: UIButton!
    
    fileprivate let skillCell = "SkillCell"
    
    fileprivate let skillCellHeight : CGFloat = 40
    
    fileprivate var selectedSkillIndex = -1
    
    override func viewDidLoad() {
        configureUI()
        configureViewModel()
        configureBindings()
        viewModel.loadSkills()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        let backButton = UIBarButtonItem(title: "back".localized, style: .plain, target: self, action: #selector(self.navigateBack(sender:)))
        self.navigationItem.leftBarButtonItem = backButton
        self.viewModel.loadSkills()
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
    
    func showBirthDatePicker() {
        let datePickerVc = DatePickerViewController(nibName: "DatePickerViewController", bundle: nil)
        
        datePickerVc.view.backgroundColor = UIColor.clear
        datePickerVc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        
        datePickerVc.datePicker.rx.date.asObservable().bind(to: viewModel.birthDate).addDisposableTo(disposeBag)
        
        self.present(datePickerVc, animated: true, completion: { })
    }
    
    func configureViewModel() {
        self.viewModel = TournamentSignUpViewModel(tournament: self.currentTournament!)
    }
    
    private func configureBindings() {
        let nextTap = btnNext.rx.tap
        
        let submitTap = btnSubmit.rx.tap
        
        Observable.from([nextTap, submitTap]).asObservable().subscribe(onNext: { [unowned self] _ in
            self.dismissKeyboard()
        }).addDisposableTo(disposeBag)
        
        nextTap.subscribe(onNext: { [unowned self] _ in
            self.showSkillSelectionView()
        }).addDisposableTo(disposeBag)
        
        self.viewModel.skills.asDriver().drive(onNext: { [unowned self] tournament in
            self.skillTableView.reloadData()
        }).disposed(by: disposeBag)
        
        self.viewModel.hasFailed.asObservable().skip(1).subscribe(onNext: { [unowned self] error in
            if case SportBookError.Unauthenticated = error {
                AuthManager.sharedInstance.clearSession()
                
                //Present login view controller
                let loginViewController = UIStoryboard.loadLoginViewController()
                self.tabBarController?.present(loginViewController, animated: true, completion: { })
            } else {
                ErrorManager.sharedInstance.showError(viewController: self, error: error)
            }
        }).disposed(by: disposeBag)
    }
    
    
    func configureUI(){
        let user = UserManager.sharedInstance.user
        self.tfEmail.text = user?.email
        
        tfEmail.title = "email".localized
        tfEmail.placeholder = "email".localized
        tfFirstName.title = "first_name".localized
        tfFirstName.placeholder = "first_name".localized
        tfLastName.title = "last_name".localized
        tfLastName.placeholder = "last_name".localized
        tfPhoneNumber.title = "phone".localized
        tfPhoneNumber.placeholder = "phone".localized
        tfAddress.title = "address".localized
        tfAddress.placeholder = "address".localized
        tfDateOfBirth.title = "birthdate".localized
        tfDateOfBirth.placeholder = "birthdate".localized
        tfClub.title = "club".localized
        tfClub.placeholder = "club".localized
        
        lblPickSkill.text = "pick_skill_level".localized
        lblNotice.text = "pick_skill_notice".localized
        btnSubmit.setTitle("submit".localized.uppercased(), for: .normal)
        
        showInputFormView()
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
        return viewModel.skills.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        let skill = viewModel.skills.value[row]
        
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

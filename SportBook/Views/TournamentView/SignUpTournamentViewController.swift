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
    
    @IBOutlet weak var tfMobile: SkyFloatingLabelTextField!
    
    @IBOutlet weak var tfCity: SkyFloatingLabelTextField!
    
    @IBOutlet weak var btnCity: UIButton!
    
    @IBOutlet weak var tfDistrict: SkyFloatingLabelTextField!
    
    @IBOutlet weak var btnDistrict: UIButton!
    
    @IBOutlet weak var tfDateOfBirth: SkyFloatingLabelTextField!
    
    @IBOutlet weak var btnDateOfBirth: UIButton!
    
    @IBOutlet weak var tfClub: SkyFloatingLabelTextField!
    
    @IBOutlet weak var btnNext: UIButton!
    
    let datePickerViewController = DatePickerViewController(nibName: "DatePickerViewController", bundle: nil)
    
    let cityPickerViewController = PickerViewControler(nibName: "PickerViewControler", bundle: nil)
    
    let districtPickerViewController = PickerViewControler(nibName: "PickerViewControler", bundle: nil)
    
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
        configureCityPicker()
        configureDistrictPicker()
        configureDatePicker()
        viewModel.loadSkills()
        viewModel.loadCities()
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
        self.present(self.datePickerViewController, animated: true, completion: { })
    }
    
    func showCityPicker() {
        self.present(self.cityPickerViewController, animated: true, completion: { })
    }
    
    func showDistrictPicker() {
        self.present(self.districtPickerViewController, animated: true, completion: { })
    }
    
    func configureViewModel() {
        self.viewModel = TournamentSignUpViewModel(tournament: self.currentTournament!)
    }
    
    private func configureBindings() {
        let nextTap = btnNext.rx.tap
        
        let submitTap = btnSubmit.rx.tap
        
        let cityTap = btnCity.rx.tap
        
        let districtTap = btnDistrict.rx.tap
        
        let birthdateTap = btnDateOfBirth.rx.tap
        
        Observable.from([nextTap, submitTap]).asObservable().subscribe(onNext: { [unowned self] _ in
            self.dismissKeyboard()
        }).addDisposableTo(disposeBag)
        
        nextTap.subscribe(onNext: { [unowned self] _ in
            self.showSkillSelectionView()
        }).addDisposableTo(disposeBag)
        
        birthdateTap.subscribe(onNext: { [unowned self] _ in
            self.showBirthDatePicker()
        }).addDisposableTo(disposeBag)
        
        cityTap.subscribe(onNext: { [unowned self] _ in
            self.showCityPicker()
        }).addDisposableTo(disposeBag)
        
        districtTap.subscribe(onNext: { [unowned self] _ in
            self.showDistrictPicker()
        }).addDisposableTo(disposeBag)
        
        self.viewModel.skills.asDriver().drive(onNext: { [unowned self] tournament in
            self.skillTableView.reloadData()
        }).disposed(by: disposeBag)
        
        self.viewModel.cities.asDriver().drive(onNext: { [unowned self] cities in
            self.cityPickerViewController.setPickerData(data: cities.map { $0.name })
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
        tfMobile.title = "mobile".localized
        tfMobile.placeholder = "mobile".localized
        tfCity.title = "city".localized
        tfCity.placeholder = "city".localized
        tfDistrict.title = "district".localized
        tfDistrict.placeholder = "district".localized
        tfDateOfBirth.title = "birthdate".localized
        tfDateOfBirth.placeholder = "birthdate".localized
        tfClub.title = "club".localized
        tfClub.placeholder = "club".localized
        
        lblPickSkill.text = "pick_skill_level".localized
        lblNotice.text = "pick_skill_notice".localized
        btnSubmit.setTitle("submit".localized.uppercased(), for: .normal)
        
        showInputFormView()
    }
    
    func configureDatePicker(){
        datePickerViewController.view.backgroundColor = UIColor.clear
        datePickerViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        
        let datePickerValueChanged = datePickerViewController.datePicker.rx.date
        
        let birthdateObservable = datePickerValueChanged.map { date -> String in
                
                let dateFormatter = DateFormatter()
                
                dateFormatter.dateStyle = DateFormatter.Style.medium
                dateFormatter.timeStyle = DateFormatter.Style.none
                
                return dateFormatter.string(from: date)
        }.asObservable()
        
        birthdateObservable.bind(to: viewModel.birthDate).addDisposableTo(disposeBag)
        birthdateObservable.bind(to: self.tfDateOfBirth.rx.text).addDisposableTo(disposeBag)
    }
    
    func configureCityPicker(){
        cityPickerViewController.view.backgroundColor = UIColor.clear
        cityPickerViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        
        let citySelectedChanged = cityPickerViewController.selectedIndex
        
        citySelectedChanged.subscribe(onNext: { index in
            self.districtPickerViewController.setPickerData(data: self.viewModel.cities.value[index].districts)
        }).addDisposableTo(disposeBag)
            
        let citySelectedChangeName = citySelectedChanged.map { index -> String in
            return self.viewModel.cities.value[index].name
        }.asObservable()
        
        citySelectedChangeName.bind(to: self.tfCity.rx.text).addDisposableTo(disposeBag)
//        citySelectedChangeName.bind(to: self.viewModel.city).addDisposableTo(disposeBag)
    }
    
    func configureDistrictPicker(){
        districtPickerViewController.view.backgroundColor = UIColor.clear
        districtPickerViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        
        let districtSelectedChanged = cityPickerViewController.selectedIndex
        
//        districtSelectedChanged.subscribe(onNext: { index in
//            self.districtPickerViewController.setPickerData(data: self.viewModel.cities.value[index].districts)
//        }).addDisposableTo(disposeBag)
//        
//        let districtSelectedChangeName = citySelectedChanged.map { index -> String in
//            return self.viewModel.cities.value[index].name
//            }.asObservable()
        
//        districtSelectedChangeName.bind(to: self.tfCity.rx.text).addDisposableTo(disposeBag)
//        districtSelectedChangeName.bind(to: self.viewModel.city).addDisposableTo(disposeBag)
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

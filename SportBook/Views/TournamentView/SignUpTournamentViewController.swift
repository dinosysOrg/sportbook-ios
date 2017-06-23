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
    
    let signUpSuccess = Variable<Bool>(false)
    
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
    
    @IBOutlet weak var skillCollectionView: UICollectionView!
    
    @IBOutlet weak var skillPageControl: UIPageControl!
    
    @IBOutlet weak var lblPickSkill: UILabel!
    
    @IBOutlet weak var lblNotice: UILabel!
    
    @IBOutlet weak var btnSubmit: UIButton!
    
    fileprivate let skillCell = "SkillCell"
    
    fileprivate var selectedSkillIndex = 0
    
    fileprivate let skillCellSpacing : CGFloat = 10
    
    override func viewDidLoad() {
        configureUI()
        configureViewModel()
        configureBindings()
        configureDatePicker()
        configureCityPicker()
        configureDistrictPicker()
        configurePageControl()
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
        self.viewModel = TournamentSignUpViewModel(tournament: self.currentTournament!, firstNameText: self.tfFirstName.rx.text.orEmpty.asDriver(), lastNameText: self.tfLastName.rx.text.orEmpty.asDriver(), phoneNumberText: self.tfMobile.rx.text.orEmpty.asDriver())
    }
    
    private func configureBindings() {
        let nextTap = btnNext.rx.tap
        
        let submitTap = btnSubmit.rx.tap
        
        let cityTap = btnCity.rx.tap
        
        let districtTap = btnDistrict.rx.tap
        
        let birthdateTap = btnDateOfBirth.rx.tap
        
        Observable.of(nextTap, submitTap).merge().asObservable().subscribe(onNext: { [unowned self] _ in
            self.dismissKeyboard()
        }).addDisposableTo(disposeBag)
        
        nextTap.subscribe(onNext: { [unowned self] _ in
            self.showSkillSelectionView()
        }).addDisposableTo(disposeBag)
        
        submitTap.subscribe(onNext: { [unowned self] _ in
            self.submitSignUp()
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
        
        self.viewModel.skills.asDriver().drive(onNext: { [unowned self] skills in
            self.skillCollectionView.reloadData()
            self.skillPageControl.numberOfPages = skills.count
        }).disposed(by: disposeBag)
        
        self.viewModel.cities.asObservable().subscribe(onNext: { [unowned self] cities in
            self.cityPickerViewController.setPickerData(data: cities.map { $0.name })
        }).disposed(by: disposeBag)
        
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
        
        self.viewModel.stepOneCredentialsValid.drive(onNext: { [unowned self] valid in
            self.btnNext.isEnabled = valid
        }).addDisposableTo(disposeBag)
        
        viewModel.firstNameValid
            .drive(onNext: { [unowned self] valid in
                self.tfFirstName.errorMessage = valid ? "" : "first_name_minimum_length".localized
            })
            .addDisposableTo(disposeBag)
        
        viewModel.lastNameValid
            .drive(onNext: { [unowned self] valid in
                self.tfLastName.errorMessage = valid ? "" : "last_name_minimum_length".localized
            })
            .addDisposableTo(disposeBag)
        
        viewModel.phoneNumberValid
            .drive(onNext: { [unowned self] valid in
                self.tfMobile.errorMessage = valid ? "" : "phone_invalid".localized
            })
            .addDisposableTo(disposeBag)
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
            date.toString()
            }.asObservable()
        
        birthdateObservable.bind(to: self.tfDateOfBirth.rx.text).addDisposableTo(disposeBag)
    }
    
    func configureCityPicker(){
        cityPickerViewController.view.backgroundColor = UIColor.clear
        cityPickerViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        
        let citySelectedIndex = cityPickerViewController.selectedIndex
        
        let citySelected = citySelectedIndex.map { index -> City in
            return self.viewModel.cities.value[index]
            }.asObservable()
        
        citySelected.map { $0.name }.bind(to: self.tfCity.rx.text).addDisposableTo(disposeBag)
        citySelected.bind(to: self.viewModel.selectedCity).addDisposableTo(disposeBag)
    }
    
    func configureDistrictPicker(){
        districtPickerViewController.view.backgroundColor = UIColor.clear
        districtPickerViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        
        let selectedCity = self.viewModel.selectedCity.asObservable()
        
        selectedCity.subscribe(onNext: { city in
            if city != nil {
                self.districtPickerViewController.setPickerData(data: city!.districts)
            }
        }).addDisposableTo(disposeBag)
        
        let districtSelectedIndex = districtPickerViewController.selectedIndex
        
        let districtSelected = districtSelectedIndex.map { index -> String in
            return self.viewModel.selectedCity.value?.districts[index] ?? ""
        }
        
        districtSelected.bind(to: self.tfDistrict.rx.text).addDisposableTo(disposeBag)
    }
    
    func configurePageControl() {
        self.skillPageControl.currentPage = 0
        self.skillPageControl.pageIndicatorTintColor = UIColor.black
        self.skillPageControl.currentPageIndicatorTintColor = UIColor.lightGray
    }
}

//MARK: Sign Up Form
extension SignUpTournamentViewController {
    func submitSignUp(){
        guard let firstName = self.tfFirstName.text, let lastName = self.tfLastName.text, let phoneNumber = Int(self.tfMobile.text!), let city = self.tfCity.text, let district = self.tfDistrict.text else {
            return
        }
        
        self.viewModel.signUpTournament(with: "\(lastName) \(firstName)", phoneNumber: phoneNumber, address: "\(district) \(city)").subscribe(onNext: { isSuccess in
            if isSuccess {
                self.signUpSuccess.value = isSuccess
                self.navigationController?.popViewController(animated: true)
            }
        }).addDisposableTo(disposeBag)
    }
}

//MARK: Skill Selection

extension SignUpTournamentViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.skills.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = indexPath.row
        let skill = viewModel.skills.value[row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: skillCell, for: indexPath)
            as! SkillCell
        
        cell.configure(skill: skill)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let skillCell = cell as? SkillCell else {
            return
        }
        
        skillCell.configureUI()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewSize = collectionView.frame.size
        
        let cellHeight = collectionViewSize.height
        let cellWidth = collectionViewSize.width * 0.9
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    //Set scrollview's content offset to center horizontal as much as possible
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        //Convert to Float to use ceilf and floorf method
        
        //Calculate page/cell width
        let pageWidth = Float(self.skillCollectionView.frame.size.width * 0.9)
        print("Page/Cell Width: \(pageWidth)")
        
        //Get current offset and target offset
        let currentOffset: Float = Float(scrollView.contentOffset.x)
        let targetOffset: Float = Float(targetContentOffset.pointee.x)
        
        print("CurrentOffset: \(currentOffset) \n TargetOffset: \(targetOffset)")
        
        //Create variable to store new offset
        var newTargetOffset: Float = 0
        
        //Calculate new offset by deviding current offset by page/cell width then multiply
        if targetOffset > currentOffset {
            //New target will be ceilf of result from deviding current offset by page/cell width then multiply by page/cell width
            newTargetOffset = ceilf(currentOffset / pageWidth) * pageWidth
        } else {
            //New target will be ceilf of result from deviding current offset by page/cell width then multiply by page/cell width
            newTargetOffset = floorf(currentOffset / pageWidth) * pageWidth
        }
        
        print("NewTargetOffset: \(newTargetOffset)")
        
        let padding: Float = 0
        
        if newTargetOffset < 0 {
            //If new target off set smaller than 0, it means that user scroll to the top
            newTargetOffset = 0
        } else if (newTargetOffset >= Float(scrollView.contentSize.width)) {
            //Else if new target offset larger or equal scrollview content width, it means that user scroll to the bottom
            newTargetOffset = Float(scrollView.contentSize.width) + padding
        }
        
        print("New NewTargetOffset: \(newTargetOffset)")
        
        targetContentOffset.pointee.x = CGFloat(currentOffset)
        
        let index = newTargetOffset / pageWidth
        
        self.viewModel.skill.value = self.viewModel.skills.value[Int(index)]
        self.skillPageControl.currentPage = Int(index)
        
        //Set scrollview content offset by new CGPoint create from new targetOffset x and current content offset y
        
        scrollView.setContentOffset(CGPoint(x: CGFloat(newTargetOffset), y: scrollView.contentOffset.y), animated: true)
    }
}

//
//  SubjectViewController.swift
//  note_RMG_iOS
//
//  Created by Suresh on 2021-09-21.
//

import UIKit

class SubjectViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addSubjectView: UIView!
    @IBOutlet weak var addSubjectTextfield: UITextField!
   
    var subjectsArray: [SubjectModel]? {
        didSet {
            collectionView.reloadData()
        }
        
    }

    var filterArray = [SubjectModel]()
    
    var isSorted = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib.init(nibName: "SubjectCollectionCell", bundle: nil), forCellWithReuseIdentifier: "SubjectCollectionCell")
        
        loadData()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - UIAction
    @IBAction func saveSubject(_ sender: Any) {
        if addSubjectTextfield.text?.replacingOccurrences(of: " ", with: "") == "" {
            self.showAlert(title: "", message: kAddSubjectName, buttonTitle: kGlobalOK)
            return
        }
        saveCategory()
        removeAddNewPopup()
    }
    
    @IBAction func closeAddSubjectPopup(_ sender: Any) {
        removeAddNewPopup()
    }
    
    @IBAction func openAddNewSubject(_ sender: Any) {
        addSubjectView.isHidden = false
        self.view.bringSubviewToFront(addSubjectView)
    }
    
    @IBAction func sortAction(_ sender: Any) {
        if isSorted {
            isSorted = false
            self.filterArray = self.subjectsArray!
        }
        else {
            isSorted = true
            self.filterArray = self.subjectsArray!.sorted(by: { $0.title.lowercased() < $1.title.lowercased() })
        }
        collectionView.reloadData()
    }
    // MARK: - Functions    
    func loadData() {
        self.subjectsArray = CoreData().loadSubjectData()
        self.filterArray = self.subjectsArray!
    }
    
    func removeAddNewPopup() {
        addSubjectView.isHidden = true
        self.view.sendSubviewToBack(addSubjectView)
    }
    
    func saveCategory() {
        let subject = SubjectModel.init(title: addSubjectTextfield.text!, date: Date().toMillis())
        CoreData().saveSubject(entity: subject)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.loadData()
        }
    }

 

    
}

extension SubjectViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SubjectCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubjectCollectionCell", for: indexPath) as! SubjectCollectionCell
        let subject = filterArray[indexPath.item]
        cell.headingLabel.text = subject.title
        cell.descriptionLabel.text = Helper().showDayDifference(date: subject.createdDate)
        cell.backView.backgroundColor = Helper().getNoteBackColor().randomElement()
        return cell
    }
}

// MARK: - UITableview DelegateFlowLayout
extension SubjectViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: iPhoneWidth/2, height: iPhoneWidth/2 + 10)
    }
    
}

extension SubjectViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let alert = UIAlertController.init(title: "", message: filterArray[indexPath.item].title, preferredStyle: .actionSheet)
        let viewAction = UIAlertAction.init(title: kView, style: .default) { (_) in
            CurrentObject.sharedInstance.selectedSubject = self.filterArray[indexPath.item]
            self.performSegue(withIdentifier: "DetailSegue", sender: self)
        }
        let deleteAction = UIAlertAction.init(title: kDelete, style: .destructive) { (_) in
            CoreData().deleteSubject(entity: self.filterArray[indexPath.item])
            DispatchQueue.main.async {
                self.loadData()
            }
        }
        let kCancelAction = UIAlertAction.init(title: kCancel, style: .cancel, handler: nil)
        alert.addAction(viewAction)
        alert.addAction(deleteAction)
        alert.addAction(kCancelAction)
        self.present(alert, animated: true, completion: nil)
    }
}

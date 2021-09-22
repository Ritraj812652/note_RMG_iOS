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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib.init(nibName: "SubjectCollectionCell", bundle: nil), forCellWithReuseIdentifier: "SubjectCollectionCell")
        

    }
    
    @IBAction func closeAddSubjectPopup(_ sender: Any) {
        removeAddNewPopup()
    }
    
    @IBAction func openAddNewSubject(_ sender: Any) {
        addSubjectView.isHidden = false
        self.view.bringSubviewToFront(addSubjectView)
    }
    
    // MARK: - Functions
    func loadData() {
        self.subjectsArray = CoreData().loadSubjectData()
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

// MARK: - DataSource Methods
extension SubjectViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subjectsArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SubjectCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubjectCollectionCell", for: indexPath) as! SubjectCollectionCell
        let subject = subjectsArray![indexPath.item]
        cell.headingLabel.text = subject.title
        cell.descriptionLabel.text = Helper().showDayDifference(date: subject.createdDate)
        //cell.backView.backgroundColor = Helper().getNoteBackColor().randomElement()
        return cell
    }
}

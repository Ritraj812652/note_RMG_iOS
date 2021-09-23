//
//  SelectSubjectToMoveNotesViewController.swift
//  note_RMG_iOS
//
//  Created by Suresh on 2021-09-23.
//

import UIKit
class SelectSubjectToMoveNotesViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
 
    var subjectsArray: [SubjectModel]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var filterArray = [SubjectModel]()
    
    public var completion: ((Double?) -> ())?
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib.init(nibName: "SubjectCollectionCell", bundle: nil), forCellWithReuseIdentifier: "SubjectCollectionCell")
        
        loadData()
        // Do any additional setup after loading the view.
    }
    
  
    // MARK: - Functions
    func loadData() {
        self.subjectsArray = CoreData().loadSubjectData()
        self.filterArray = self.subjectsArray!
    }
}

extension SelectSubjectToMoveNotesViewController: UICollectionViewDataSource {
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
extension SelectSubjectToMoveNotesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: iPhoneWidth/2, height: iPhoneWidth/2 + 10)
    }
}

extension SelectSubjectToMoveNotesViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.showAlertWithCompletionTwoButtons(title: "", message: kMoveNotesConfirmation) { (_) in
            self.completion?(self.subjectsArray![indexPath.item].createdDate)
            self.navigationController?.popViewController(animated: true)
        }
    }
}


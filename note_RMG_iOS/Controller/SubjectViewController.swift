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
        

        // Do any additional setup after loading the view.
    }
    

    
}
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

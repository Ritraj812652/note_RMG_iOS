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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  SelectSubjectToMoveNotesViewController.swift
//  note_RMG_iOS
//
//  Created by Suresh on 2021-09-23.
//

import UIKit
class SelectSubjectToMoveNotesViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    public var completion: ((Double?) -> ())?
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib.init(nibName: "SubjectCollectionCell", bundle: nil), forCellWithReuseIdentifier: "SubjectCollectionCell")
        
        // Do any additional setup after loading the view.
    }
}

//
//  NotesViewViewController.swift
//  note_RMG_iOS
//
//  Created by Gurpreet Kaur on 22/09/21.
//

import UIKit

class NotesViewViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedIndex: Int?
    
    var notesArray: [NotesModel]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = CurrentObject.sharedInstance.selectedSubject?.title
        
        collectionView.register(UINib.init(nibName: "SubjectCollectionCell", bundle: nil), forCellWithReuseIdentifier: "SubjectCollectionCell")
        // Do any additional setup after loading the view.
    }

}

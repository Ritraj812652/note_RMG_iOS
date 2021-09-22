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
    
    var filterArray = [NotesModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = CurrentObject.sharedInstance.selectedSubject?.title
        
        collectionView.register(UINib.init(nibName: "SubjectCollectionCell", bundle: nil), forCellWithReuseIdentifier: "SubjectCollectionCell")
        // Do any additional setup after loading the view.
    }
    
    
    // MARK: - Functions
    func loadData() {
        self.notesArray = CoreData().loadNotesData(id: CurrentObject.sharedInstance.selectedSubject!.createdDate)
        self.filterArray = notesArray!
    }
}
//MARK: - DataSource Methods
extension NotesViewViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SubjectCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubjectCollectionCell", for: indexPath) as! SubjectCollectionCell
        let subject = filterArray[indexPath.item]
        cell.headingLabel.text = subject.title
        cell.descriptionLabel.text = Helper().showDayDifference(date: subject.createdDate)
       
        return cell
    }
}
extension NotesViewViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text == "" {
            filterArray = notesArray!
        }
        else {
            filterArray = (notesArray?.filter { $0.title.lowercased().contains(searchBar.text!.lowercased())})!
        }
        self.searchBar.resignFirstResponder()
        collectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.text = ""
        filterArray = notesArray!
        collectionView.reloadData()
    }
}

// MARK: - UITableview DelegateFlowLayout
extension NotesViewViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: iPhoneWidth/2, height: iPhoneWidth/2 + 10)
    }
}

extension NotesViewViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.item
        
        self.performSegue(withIdentifier: "AddEditNotes", sender: self)
    }
}


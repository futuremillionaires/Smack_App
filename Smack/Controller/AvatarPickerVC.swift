//
//  AvatarPickerVC.swift
//  Smack
//
//  Created by Raju Dhumne on 02/01/18.
//  Copyright © 2018 Raju Dhumne. All rights reserved.
//

import UIKit

class AvatarPickerVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
// Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
//Variables
    var avatarType = AvatarType.dark
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AvatarCell", for: indexPath) as? AvatarCell {
        cell.configureCells(index: indexPath.item, type: avatarType)
        return cell
        }
        return AvatarCell()
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 28
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var numOfColumn: CGFloat = 3
        if UIScreen.main.bounds.width > 350 {
            numOfColumn = 4
        }
        let spaceBetweenCell:CGFloat = 10
        let padding:CGFloat = 40
        let cellDimension = ((collectionView.bounds.width - padding) - (numOfColumn - 1) * spaceBetweenCell) / numOfColumn
    return CGSize(width: cellDimension, height: cellDimension)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if avatarType == .dark {
            UserDataService.instance.setAvatarName(avatarName: "dark\(indexPath.item)")
        }else {
            UserDataService.instance.setAvatarName(avatarName: "light\(indexPath.item)")
        }
    self.dismiss(animated: true, completion: nil)
    }
    @IBAction func segmentControlChanged(_ sender: Any) {
        if segmentControl.selectedSegmentIndex == 0 {
            avatarType = .dark
        }else {
            avatarType = .light
        }
        collectionView.reloadData()
    }
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}

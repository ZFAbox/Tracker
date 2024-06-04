//
//  StatisticViewController.swift
//  Tracker
//
//  Created by Федор Завьялов on 01.06.2024.
//

import Foundation
import UIKit


final class StatisticViewController: UIViewController {
    
    
    
//    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .gray
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.dataSource = self
        return collectionView
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        



        addSubviews()
        addConstrains()
    }
    
    private func addSubviews(){
        view.addSubview(collectionView)
    }
    
    private func addConstrains(){
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: 		view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension StatisticViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        
        cell.backgroundColor = .red
        print("\(indexPath)")
        return cell
    }
}

//
//  ViewController.swift
//  CollectionViewCompositional_Itea
//
//  Created by Anastasia Bilous on 2022-06-24.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    private let imagesUrl: [String] = [
        "https://wallpapercave.com/wp/wp5163356.jpg",
        "https://zenartdesign.com/wp-content/uploads/2018/08/Aurora-Borealis-1000px.jpg",
        "https://cutewallpaper.org/23/abnormal-nature-vertical-wallpaper/1059624695.jpg",
        "https://i0.wp.com/digital-photography-school.com/wp-content/uploads/2013/08/1.-Moraine_final.jpg?w=600&h=1260&ssl=1",
        "https://i.pinimg.com/originals/8a/d1/90/8ad1907008c01385d53aeb3108eb1630.jpg",
        "https://wallpapershome.com/images/pages/pic_v/15452.jpg"
    ]
    
    private var colectionImags = [UIImage]()
    private let group = DispatchGroup()
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: ViewController.createLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "Gallery",
            style: .plain,
            target: nil,
            action: nil
        )
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barStyle = .black
        
        view.addSubview(collectionView)
        collectionView.register(MyCollectionViewCell.self,
                                forCellWithReuseIdentifier: MyCollectionViewCell.identifier)
        collectionView.register(HeaderCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: HeaderCollectionReusableView.identifier)
        collectionView.frame = view.bounds
        collectionView.backgroundColor = #colorLiteral(red: 0.597756234, green: 0.8192453866, blue: 0.5169243421, alpha: 1)
        collectionView.dataSource = self
        collectionView.delegate = self
        downloadImages()
    }
    
    private func downloadImages() {
        for index in 0..<imagesUrl.count {
            guard let imgUrl = URL(string: imagesUrl[index]) else { return }
            group.enter()
            URLSession.shared.dataTask(with: imgUrl) { data, response, error in
                DispatchQueue.main.async {
                    guard let data = data, let img = UIImage(data: data) else { return }
                    self.colectionImags.append(img)
                }
                self.group.leave()
            }.resume()
            group.wait()
        }
        group.notify(queue: DispatchQueue.main, execute: {
            self.collectionView.reloadData()
        })
    }
    
    static func createLayout() -> UICollectionViewCompositionalLayout {
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(30.0))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        
        //Items
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .fractionalHeight(1)
            )
        )
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 4, leading: 4, bottom: 0, trailing: 2)
        
        let verticalStackItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(0.5)
            )
        )
        verticalStackItem.contentInsets = NSDirectionalEdgeInsets(
            top: 4, leading: 2, bottom: 0, trailing: 4)
        
        //Groups
        let verticalStackGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .fractionalHeight(1)
            ),
            subitem: verticalStackItem,
            count: 2)
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalWidth(0.9)
            ),
            subitems: [
                item,
                verticalStackGroup
            ]
        )
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [header]
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HeaderCollectionReusableView.identifier,
            for: indexPath) as! HeaderCollectionReusableView
        header.configure()
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colectionImags.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MyCollectionViewCell.identifier,
            for: indexPath) as! MyCollectionViewCell
        
        cell.imageView.image = colectionImags[indexPath.row]
        cell.imageView.layer.cornerRadius = 15
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let chosenPictureVC = ChosenPictureViewController()
        chosenPictureVC.img = colectionImags[indexPath.row]
        navigationController?.pushViewController(chosenPictureVC, animated: true)
    }
}




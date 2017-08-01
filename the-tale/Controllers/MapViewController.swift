//
//  MapViewController.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 03/06/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {
  
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var mapActivityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var compassButton: UIButton!
  
  var statusBarView: UIView?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupNotification()
    setupButton()
    setupBackgroundStatusBar()
  }
 
  func setupBackgroundStatusBar() {
    statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
    statusBarView?.backgroundColor = UIColor(red: 255, green: 255, blue: 255, transparency: 0.8)
    view.addSubview(statusBarView!)
  }
  
  func setupNotification() {
    NotificationCenter.default.addObserver(self, selector: #selector(reloadMap), name: NSNotification.Name("updateMap"), object: nil)
  }
  
  func setupButton() {
    compassButton.layer.cornerRadius  = 8
    compassButton.layer.masksToBounds = true
    compassButton.layer.opacity       = 0.7
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    let currentMapVersion = TaleAPI.shared.gameInformation?.mapVersion
    let recivedMapVersion = TaleAPI.shared.map?.mapVersion

    if recivedMapVersion != currentMapVersion {
      mapActivityIndicator.startAnimating()
      TaleAPI.shared.fetchMap()
    }
  }
  
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    switch UIDevice.current.orientation {
    case UIDeviceOrientation.portrait, UIDeviceOrientation.portraitUpsideDown:
      statusBarView?.isHidden = false
    case UIDeviceOrientation.landscapeLeft, UIDeviceOrientation.landscapeRight:
      statusBarView?.isHidden = true
    default:
      break
    }
  }
  
  func reloadMap() {
    DispatchQueue.main.async {
      self.collectionView.reloadData()
      self.mapActivityIndicator.stopAnimating()
      self.scrollingToHero()
    }
  }
  
  func scrollingToHero() {
    guard let xCoordinate = TaleAPI.shared.heroPosition?.xCoordinate,
          let yCoordinate = TaleAPI.shared.heroPosition?.yCoordinate,
          let widthMap     = TaleAPI.shared.map?.width,
          let heighMap     = TaleAPI.shared.map?.height else {
        return
    }
    
    if xCoordinate <= widthMap && yCoordinate <= heighMap {
      collectionView.scrollToItem(at: IndexPath(item: xCoordinate, section: yCoordinate), at: .centeredVertically, animated: false)
      collectionView.scrollToItem(at: IndexPath(item: xCoordinate, section: yCoordinate), at: .centeredHorizontally, animated: false)
    }
  }
  
  @IBAction func compassButtonTapped(_ sender: UIButton) {
    scrollingToHero()
  }
  
}

extension MapViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return TaleAPI.shared.map?.width ?? 1
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return TaleAPI.shared.map?.height ?? 1
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    // swiftlint:disable:next force_cast
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MapCollectionViewCell
    
    if let image = TaleAPI.shared.map?.image[indexPath.section][indexPath.item] {
      cell.configuredCell()
      cell.setBackground(with: image)
    }
    
    if let place = TaleAPI.shared.map?.places.filter({ $0.posY == indexPath.section - 1 && $0.posX == indexPath.item }).first {
      cell.setAnnotation(with: place.nameRepresentation())
    }
    
    if let hero = TaleAPI.shared.hero,
       TaleAPI.shared.heroPosition?.yCoordinate == indexPath.section,
       TaleAPI.shared.heroPosition?.xCoordinate == indexPath.item {
      cell.setHero(with: hero.image)
    }
    
    return cell
  }

}

extension MapViewController: UICollectionViewDelegate {
  
}

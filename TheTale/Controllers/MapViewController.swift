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
  
  var map = Map()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupCompassButton()
    setupBackgroundStatusBar()
  }
 
  func setupBackgroundStatusBar() {
    statusBarView                  = UIView(frame: UIApplication.shared.statusBarFrame)
    statusBarView?.backgroundColor = UIColor(red: 255, green: 255, blue: 255, transparency: 0.8)
    view.addSubview(statusBarView!)
  }
  
  func setupCompassButton() {
    compassButton.layer.cornerRadius  = 8
    compassButton.layer.masksToBounds = true
    compassButton.layer.opacity       = 0.7
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    guard let currentMapVersion = TaleAPI.shared.playerInformationManager.playerInformation?.mapVersion else {
        return
    }

    if map?.mapVersion != currentMapVersion {
      mapActivityIndicator.startAnimating()
      fetchMap()
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
  
  func fetchMap() {
    // Blanket. Used to get old maps.
    let turn = ""
    
    TaleAPI.shared.getMap(turn: turn) { [weak self] (result) in
      switch result {
      case .success(let data):
        let queue = DispatchQueue(label: "mapGenerate", qos: .userInitiated)
        queue.async {
          self?.map = Map(jsonObject: data)
          self?.reloadMap()
        }
      case .failure(let error as NSError):
        debugPrint("fetchMap \(error)")
      default: break
      }
    }
    
  }
  
  func scrollingToHero() {
    guard let xCoordinate = TaleAPI.shared.playerInformationManager.heroPosition?.xCoordinate,
          let yCoordinate = TaleAPI.shared.playerInformationManager.heroPosition?.yCoordinate,
          let widthMap    = map?.width,
          let heighMap    = map?.height else {
        return
    }
    
    if xCoordinate <= widthMap && yCoordinate <= heighMap {
      collectionView.scrollToItem(at: IndexPath(item: xCoordinate, section: yCoordinate),
                                  at: .centeredVertically, animated: false)
      collectionView.scrollToItem(at: IndexPath(item: xCoordinate, section: yCoordinate),
                                  at: .centeredHorizontally, animated: false)
    }
  }
  
  @IBAction func compassButtonTapped(_ sender: UIButton) {
    scrollingToHero()
  }
  
}

extension MapViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return map?.width ?? 1
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return map?.height ?? 1
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    // swiftlint:disable:next force_cast
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MapCollectionViewCell
    
    if let image = map?.image[indexPath.section][indexPath.item] {
      cell.configuredCell()
      cell.setBackground(with: image)
    }
    
    if let place = map?.places.filter({ $0.posY == indexPath.section - 1 && $0.posX == indexPath.item }).first {
      cell.setAnnotation(with: place.nameRepresentation())
    }
    
    if let hero = TaleAPI.shared.playerInformationManager.hero,
       TaleAPI.shared.playerInformationManager.heroPosition?.yCoordinate == indexPath.section,
       TaleAPI.shared.playerInformationManager.heroPosition?.xCoordinate == indexPath.item {
      cell.setHero(with: hero.image)
    }
    
    return cell
  }

}

extension MapViewController: UICollectionViewDelegate {
  
}
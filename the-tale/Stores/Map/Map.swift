//
//  Map.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 04/07/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import Foundation
import UIKit

struct Map {
  var turn: String
  var formatVersion: String
  var height: Int
  var width: Int
  var mapVersion: String
  var image: [[UIImage]]
  var places: [PlaceInfo]
}

extension Map: JSONDecodable {
  init?(jsonObject: JSON) {
    
    let sizeBlock = CGSize(width: 32, height: 32)
    
    guard let turn           = jsonObject["turn"] as? Int,
          let region         = jsonObject["region"] as? JSON,
          let formatVersion  = region["format_version"] as? String,
          let height         = region["height"] as? Int,
          let width          = region["width"] as? Int,
          let mapVersion     = region["map_version"] as? String,
          let mapArrayObject = region["draw_info"] as? NSArray,
          let placesJSON     = region["places"] as? JSON else {
        return nil
    }
    
    var drawInfo: [[UIImage]] = []
    for mapArrayLine in mapArrayObject {
      guard let mapArrayLine = mapArrayLine as? NSArray else { break }
      var mapLine: [UIImage] = []
      
      for mapBlock in mapArrayLine {
        guard let mapBlock = mapBlock as? NSArray else { break }
        var mapItem: [DrawBlock] = []
        
        for mapItems in mapBlock {
          guard let mapItems = mapItems as? NSArray,
                let block   = DrawBlock(arrayObject: mapItems) else {
              break
          }
          mapItem.append(block)
        }
        
        let imagesArray = mapItem.map { (String($0.blockID), Double($0.blockAngle) ) }
        guard let mapImage = UIImage(prefix: "map_default", imagesNamed: imagesArray, size: sizeBlock) else {
          break
        }
        
        mapLine.append(mapImage)
      }
      drawInfo.append(mapLine)
    }
    
    var places: [PlaceInfo] = []
    for (_, value) in placesJSON {
      guard let placeJSON = value as? JSON,
            let place     = PlaceInfo(jsonObject: placeJSON) else {
          break
      }
      places.append(place)
    }
    
    self.turn          = String(turn)
    self.formatVersion = formatVersion
    self.height        = height
    self.width         = width
    self.mapVersion    = mapVersion
    self.image         = drawInfo
    self.places        = places
    
  }
  
  init?() {
    self.init(jsonObject: [:])
  }
}

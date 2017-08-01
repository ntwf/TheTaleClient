//
//  debugPrint.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 31/07/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

func debugPrint(_ items: Any...) {
  #if DEBUG
    Swift.debugPrint(items)
  #endif
}

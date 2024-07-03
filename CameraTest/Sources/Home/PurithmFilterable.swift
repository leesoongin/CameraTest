//
//  PurithmFilterable.swift
//  CameraTest
//
//  Created by 이숭인 on 7/3/24.
//

import UIKit
import CoreImage

protocol PurithmFilterable {
    var type: CIFilterType { get }
    
    var filterKey: String { get }
    var filterValue: String { get }
    
    var defaultValue: CGFloat { get }
    var minumValue: CGFloat { get }
    var maximumValue: CGFloat { get }
    
    //TODO: 어떤 동작을 해야하지?
    func adjustFilter(of type: CIFilterType) -> CIImage?
}

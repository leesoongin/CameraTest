//
//  FilterManager.swift
//  CameraTest
//
//  Created by 이숭인 on 7/3/24.
//

import UIKit
import CoreImage

final class FilterManager {
    static let shared = FilterManager()
    
    private init() { }
    
    
    
    ///  추후 각 필터 별로 조절할 수 있도록 세분화하여 조립해서 쓰자.
    func adjustLuminance(of image: UIImage?, luminance: CGFloat) -> UIImage?  {
        guard let ciImage = CIImage(image: image ?? UIImage()) else { return nil }
        let normalizedLuminance = luminance
        
        // 어두운 부분을 밝히기 위해 노출 조정
        let exposureAdjust = CIFilter(name: "CIExposureAdjust")!
        exposureAdjust.setValue(ciImage, forKey: kCIInputImageKey)
        exposureAdjust.setValue(normalizedLuminance * 0.5, forKey: kCIInputEVKey)
        guard let exposureAdjusted = exposureAdjust.outputImage else { return nil } //CIImage
        
        // 하이라이트 추가 및 섀도우 조정
        let highlightShadowAdjust = CIFilter(name: "CIHighlightShadowAdjust")!
        highlightShadowAdjust.setValue(exposureAdjusted, forKey: kCIInputImageKey)
        highlightShadowAdjust.setValue(1 + (normalizedLuminance * 0.5), forKey: "inputHighlightAmount")
        highlightShadowAdjust.setValue(normalizedLuminance * 0.5, forKey: "inputShadowAmount")
        guard let highlightShadowAdjusted = highlightShadowAdjust.outputImage else { return nil }
        
        // 대비 조정
        let colorControls = CIFilter(name: "CIColorControls")!
        colorControls.setValue(highlightShadowAdjusted, forKey: kCIInputImageKey)
        colorControls.setValue(1 + (normalizedLuminance * 0.1), forKey: kCIInputContrastKey)
        guard let contrastAdjusted = colorControls.outputImage else { return nil }
        
        
        let context = CIContext(options: nil)
        guard let cgImage = context.createCGImage(contrastAdjusted, from: contrastAdjusted.extent) else {
            return nil
        }
        
        
        return UIImage(cgImage: cgImage)
    }
}

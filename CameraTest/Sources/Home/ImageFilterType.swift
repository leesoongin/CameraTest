//
//  ImageFilterType.swift
//  CameraTest
//
//  Created by 이숭인 on 7/1/24.
//

import UIKit

enum ImageFilterType: String, CaseIterable {
    case brightness = "휘도" // 휘도
    case exposure = "노출" // 노출
    case highlights = "하이라이트" // 하이라이트
    case shadows = "그림자" // 그림자
    case contrast = "대비" // 대비
//    case blackPoint // 블랙포인트 - 블랙포인트를 포함한 전체톤을 조절하기 위해 사용
    case saturation = "채도" // 채도
    case colorCast = "색 선명도" // 색 선명도
    case warmth = "따뜻함" // 따뜻함
    case hue = "색조"// 색조
    case sharpness = "선명도" // 선명도
    
    /// Filter name
    var name: String {
        switch self {
        case .brightness, .saturation, .contrast:
            "CIColorControls"
        case .exposure:
            "CIExposureAdjust"
        case .highlights, .shadows:
            "CIHighlightShadowAdjust"
//        case .blackPoint:
//            "CIToneCurve"
        case .colorCast:
            "CIWhitePointAdjust"
        case .warmth:
            "CITemperatureAndTint"
        case .hue:
            "CIHueAdjust"
        case .sharpness:
            "CIVibrance"
        }
    }
    
    var key: String {
        switch self {
        case .brightness:
            kCIInputBrightnessKey
        case .exposure:
            kCIInputEVKey
        case .highlights:
            "inputHighlightAmount"
        case .shadows:
            "inputShadowAmount"
        case .contrast:
            kCIInputContrastKey
//        case .blackPoint:
//            ""
        case .saturation:
            kCIInputSaturationKey
        case .colorCast:
            "inputColor"
        case .warmth:
            "inputNeutral"
        case .hue:
            kCIInputAngleKey
        case .sharpness:
            "inputAmount"
        }
    }
}

//노출 (Exposure)
//필터: CIExposureAdjust
//키 값: inputEV

//2. 하이라이트 (Highlights)
//필터: CIHighlightShadowAdjust
//키 값: inputHighlightAmount

//3. 그림자 (Shadows)
//필터: CIHighlightShadowAdjust
//키 값: inputShadowAmount

//4. 대비 (Contrast)
//필터: CIColorControls
//키 값: inputContrast

//5. 블랙포인트 (Black Point)
//필터: CIToneCurve
//키 값: inputPoint0, inputPoint1, inputPoint2, inputPoint3, inputPoint4 (블랙포인트를 포함한 전체 톤을 조절하기 위해 사용)

//6. 채도 (Saturation)
//필터: CIColorControls
//키 값: inputSaturation

//7. 색선명도 (Color Cast)
//필터: CIWhitePointAdjust
//키 값: inputColor

//8. 따뜻함 (Warmth)
//필터: CITemperatureAndTint
//키 값: inputNeutral, inputTargetNeutral

//9. 색조 (Hue)
//필터: CIHueAdjust
//키 값: inputAngle

//10. 선명도 (Sharpness)
//필터: CISharpenLuminance
//키 값: inputSharpness

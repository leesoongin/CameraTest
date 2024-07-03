//
//  CIFilterType.swift
//  CameraTest
//
//  Created by 이숭인 on 7/1/24.
//

import UIKit
import CoreImage

//1. 사용할 필터 모델을 위한 인터페이스
//2. 각 모델 생성
//3. 매니저에서 각 모델을 인스턴스로 생성하여 다루도록 설계하자.
//4. 각 모델에서 CIFIlterType을 가지고 있으면 될듯?


enum CIFilterType: String, CaseIterable {
    case exposure = "노출"
    case luminance = "휘도"
    case brightness = "밝기"
    case saturation = "채도"
    case vibrance = "색 선명도"
    case contrast = "대비"
    case shadow = "그림자"
    case warmth = "따뜻함"
    case hue = "색조" // 틴트 맞네
    case sharpness = "선명도"
    case highlights = "하이라이트" // 하이라이트 - default = 1
    
    var name: String {
        switch self {
        case .exposure:
            "CIExposureAdjust"
        case .luminance:
            ""
        case .brightness, .saturation, .contrast:
            "CIColorControls"
        case .vibrance:
            "CIVibrance"
        case .shadow, .highlights:
            "CIHighlightShadowAdjust"
        case .warmth:
            "CITemperatureAndTint"
        case .hue:
            "CIHueAdjust"
        case .sharpness:
            "CISharpenLuminance" // or CIUnsharpMask
        }
    }
    
    var value: String {
        switch self {
        case .exposure:
            kCIInputEVKey
        case .luminance:
            ""
        case .brightness:
            "inputBrightness"
        case .saturation:
            "inputSaturation"
        case .vibrance:
            "inputAmount"
        case .contrast:
            "inputContrast"
        case .shadow:
            "inputShadowAmount"
        case .warmth:
            "inputNeutral"
        case .hue:
            "inputAngle"
        case .sharpness:
            "inputSharpness"
        case .highlights:
            "inputHighlightAmount"
        }
    }
    
    var minumValue: Float {
        switch self {
        case .exposure:
            -10
        case .luminance:
            -100
        case .brightness:
            -1
        case .saturation:
            0
        case .vibrance:
            0
        case .contrast:
            0
        case .shadow:
            -1
        case .warmth:
            0 // (6500, 0)
        case .hue:
            -3.14
        case .sharpness:
            0
        case .highlights:
            0
        }
    }
    
    //각각을 객체로 만들어버릴까?
    /*
     필터 키값
     CIExposureAdjust: 노출
     - kCIInputEVKey 기본 0 최소 -10, 최대 10
     
     CIHighlightShadowAdjust: 하이라이트, 그림자
     - inputHighlightAmount 기본값 1.0, 최소 0 최대 1
     - inputShadowAmount 기본값 0 최소 -1 최대 1
     
     CIColorControls: 밝기, 대비, 채도
     - inputSaturation 기본 1.0 최소 0 최대 2
     - inputBrightness 기본 0 최소 -1 최대 1
     - inputContrast 기본 1 최소 0 최대 4
     
     CIVibrance: 색 선명도
     - inputAmount 기본 0.5 최소 0 최대 1
     
     CISharpenLuminance or CIUnsharpMask:선명도 / 이건 둘중하나
     - inputSharpness 기본 0.4 최소 0 최대 1
     - inputIntensity 기본 0.5 최소 0 최대 1
     
     CITemperatureAndTint: 따뜻함 / 비율 (6500, 0) 1증가당 (+45 , +1)
     - inputNeutral 기본 (6500, 0) 최소 (1000, -200) 최대 (10000, 200)
     
     CIHueAdjust: 색조 / 비율 (-3.14 ~ 3.14) 1증가당 0.0314 
     - inputAngle 기본 0 최소 -3.14 최대 3.14
     */
    
    
    /// Filter name
//    var name: String {
//        switch self {
//        case .brightness, .saturation, .contrast:
//            "CIColorControls"
//        case .exposure:
//            "CIExposureAdjust"
//        case .highlights, .shadow:
//            "CIHighlightShadowAdjust"
////        case .blackPoint:
////            "CIToneCurve"
//        case .colorCast:
//            "CIWhitePointAdjust"
//        case .warmth:
//            "CITemperatureAndTint"
//        case .hue:
//            "CIHueAdjust"
//        case .sharpness:
//            "CIVibrance" // 이게 찐 색 선명도 -1 ~ 1
//        }
//    }
//    
//    var key: String {
//        switch self {
//        case .brightness:
//            kCIInputBrightnessKey
//        case .exposure:
//            kCIInputEVKey
//        case .highlights:
//            "inputHighlightAmount"
//        case .shadow:
//            "inputShadowAmount"
//        case .contrast:
//            kCIInputContrastKey
////        case .blackPoint:
////            ""
//        case .saturation:
//            kCIInputSaturationKey
//        case .colorCast:
//            "inputColor"
//        case .warmth:
//            "inputNeutral"
//        case .hue:
//            kCIInputAngleKey
//        case .sharpness:
//            "inputAmount"
//        }
//    }
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

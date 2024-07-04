import ProjectDescription

let project = Project(
    name: "CameraTest",
    targets: [
        .target(
            name: "CameraTest",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.CameraTest",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchStoryboardName": "LaunchScreen.storyboard",
                    "NSCameraUsageDescription": "이 앱은 카메라를 사용합니다.",
                    "NSPhotoLibraryUsageDescription": "이 앱은 사진 앨범에 접근합니다.",
                    "LSApplicationQueriesSchemes": [ "kakaokompassauth" ],
                    "CFBundleURLTypes": [
                        [
                            "CFBundleURLSchemes": [ "kakao0d6fbb90fdd3615fa419c28d59c290b7" ]
                        ]
                    ]
                ]
            ),
            sources: ["CameraTest/Sources/**"],
            resources: ["CameraTest/Resources/**"],
            dependencies: [
                .external(name: "Alamofire"),
                .external(name: "Then"),
                .external(name: "SnapKit"),
                .external(name: "CombineExt"),
                .external(name: "CombineCocoa"),
                .external(name: "RxSwiftExt"),
                .external(name: "RxSwift"),
                .external(name: "RxKakaoSDK"),
            ],
            settings: .settings(base: [
                "DEVELOPMENT_TEAM": "7W64WHVKVN",  // 팀 ID를 설정합니다.
                "CODE_SIGN_STYLE": "Automatic"
            ])
        ),
        .target(
            name: "CameraTestLoginExample",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.CameraTest.login.example",
            infoPlist: .extendingDefault(
                with: [
                    "LSApplicationQueriesSchemes": [ "kakaokompassauth" ],
                    "CFBundleURLTypes": [
                        [
                            "CFBundleURLSchemes": [ "kakao0d6fbb90fdd3615fa419c28d59c290b7" ]
                        ]
                    ]
                ]
            ),
            sources: ["CameraTestLoginExample/Sources/**"],
            resources: ["CameraTestLoginExample/Resources/**"],
            dependencies: [
                .external(name: "Alamofire"),
                .external(name: "Then"),
                .external(name: "SnapKit"),
                .external(name: "CombineExt"),
                .external(name: "CombineCocoa"),
                .external(name: "RxSwiftExt"),
                .external(name: "RxSwift"),
                .external(name: "RxKakaoSDK"),
            ],
            settings: .settings(base: [
                "OTHER_SWIFT_FLAGS": [
                    "-D LoginExample"  // B 타겟에 대해 B 플래그를 추가합니다.
                ],
                "DEVELOPMENT_TEAM": "7W64WHVKVN",  // 팀 ID를 설정합니다.
                "CODE_SIGN_STYLE": "Automatic"
            ])
        ),
        .target(
            name: "CameraTestTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.CameraTestTests",
            infoPlist: .default,
            sources: ["CameraTest/Tests/**"],
            resources: [],
            dependencies: [.target(name: "CameraTest")]
        ),
    ]
)

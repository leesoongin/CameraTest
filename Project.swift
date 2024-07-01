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
                    "NSPhotoLibraryUsageDescription": "이 앱은 사진 앨범에 접근합니다."
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
                .external(name: "RxSwift")
            ]
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

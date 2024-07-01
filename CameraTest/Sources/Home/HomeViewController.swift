//import UIKit
//import SnapKit
//import Then
//import Combine
//import CombineCocoa
//
//extension HomeViewController {
//    enum Constant {
//        static var sliderInitialValue: Float = 0.0
//        static var sliderMinimumValue: Float = -0.1
//        static var sliderMaximumValue: Float = 0.1
//        
//        static func filterValue(type: ImageFilterType, with sliderValue: Float = 0.0) -> String { type.rawValue + ": " + String(format: "%.2f", sliderValue) }
//    }
//}
//
//
//final class HomeViewController: UIViewController {
//    var cancellables = Set<AnyCancellable>()
//    
//    let scrollView = UIScrollView()
//    let contentView = UIView()
//    
//    let sampleImageView: UIImageView = UIImageView().then {
//        $0.backgroundColor = .black
//    }
//    
//    let albumButton = UIButton().then {
//        $0.setTitle("앨범 불러오기", for: .normal)
//        $0.setTitleColor(.white, for: .normal)
//        $0.backgroundColor = .systemBlue
//    }
//    
//    var sliderStackView = UIStackView().then {
//        $0.axis = .vertical
//        $0.distribution = .fillEqually
//    }
//    
//    var sliders: [UISlider] = []
//    
//    var originalImage: UIImage?  // 원본 이미지를 저장할 속성
//    var brightness: Float = 0.0
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        
//        
//        
//        setupSubviews()
//        setupConstraints()
//        bindAction()
//    }
//    
//    private func setupSubviews() {
//        view.addSubview(scrollView)
//        scrollView.addSubview(contentView)
//        
//        createFilterSlider()
//        
//        contentView.addSubview(sampleImageView)
//        contentView.addSubview(albumButton)
//        contentView.addSubview(sliderStackView)
//    }
//    
//    private func setupConstraints() {
//        scrollView.snp.makeConstraints { make in
//            make.edges.equalTo(view.safeAreaLayoutGuide)
//        }
//        
//        contentView.snp.makeConstraints { make in
//            make.edges.equalTo(scrollView)
//            make.width.equalTo(scrollView)
//            make.bottom.equalTo(scrollView)
//        }
//        
//        sampleImageView.snp.makeConstraints { make in
//            make.top.equalTo(view.safeAreaLayoutGuide).inset(32)
//            make.horizontalEdges.equalToSuperview().inset(32)
//            make.height.equalTo(300)
//        }
//        
//        albumButton.snp.makeConstraints { make in
//            make.top.equalTo(sampleImageView.snp.bottom).offset(32)
//            make.horizontalEdges.equalToSuperview().inset(32)
//            make.height.equalTo(42)
//        }
//        
//        sliderStackView.snp.makeConstraints { make in
//            make.top.equalTo(albumButton.snp.bottom).offset(16)
//            make.horizontalEdges.equalToSuperview()
//            make.height.equalTo(1000)
//            make.bottom.equalTo(scrollView)
//        }
//    }
//    
//    private func bindAction() {
//        albumButton.tapPublisher
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] _ in
//                let imagePicker = UIImagePickerController()
//                imagePicker.delegate = self
//                imagePicker.sourceType = .photoLibrary
//                self?.present(imagePicker, animated: true, completion: nil)
//            }
//            .store(in: &cancellables)
//    }
//}
//
//extension HomeViewController {
//    private func createFilterSlider() {
//        ImageFilterType.allCases.forEach { filter in
//            let container = UIView()
//            
//            let slider = UISlider().then {
//                $0.value = Constant.sliderInitialValue
//                $0.minimumValue = Constant.sliderMinimumValue
//                $0.maximumValue = Constant.sliderMaximumValue
//            }
//            
//            let sliderValue = UILabel().then {
//                $0.text = Constant.filterValue(type: filter)
//                $0.textColor = .black
//                $0.font = UIFont.systemFont(ofSize: 14)
//            }
//            
//            container.addSubview(slider)
//            container.addSubview(sliderValue)
//            
//            slider.snp.makeConstraints { make in
//                make.top.equalToSuperview().inset(16)
//                make.horizontalEdges.equalToSuperview().inset(16)
//            }
//            
//            sliderValue.snp.makeConstraints { make in
//                make.top.equalTo(slider.snp.bottom).offset(16)
//                make.centerX.equalToSuperview()
//            }
//            
//            sliders.append(slider)
//            
//            slider.valuePublisher
//                .receive(on: DispatchQueue.main)
//                .sink { [weak self] value in
//                    guard let self = self else { return }
//                    self.brightness = value
//                    sliderValue.text = Constant.filterValue(type: filter, with: value)
//                    
//                    self.adjustBrightness(of: self.originalImage, brightness: self.brightness)
//                }
//                .store(in: &cancellables)
//            
//            sliderStackView.addArrangedSubview(container)
//        }
//    }
//}
//
//
////MARK: - Image Picker
//extension HomeViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        if let image = info[.originalImage] as? UIImage {
//            originalImage = image  // 원본 이미지 저장
//            sliders.forEach { $0.value = Constant.sliderInitialValue }
//            
//            adjustBrightness(of: image, brightness: brightness)  // 초기 밝기 조정
//        }
//        dismiss(animated: true, completion: nil)
//    }
//    
//    func adjustBrightness(of image: UIImage?, brightness: Float) {
//        guard let ciImage = CIImage(image: image ?? UIImage()) else { return }
//        
//        let filter = CIFilter(name: "CIColorControls")
//        filter?.setValue(ciImage, forKey: kCIInputImageKey)
//        filter?.setValue(brightness, forKey: kCIInputBrightnessKey)  // 휘도 조정
//        
//        if let outputImage = filter?.outputImage {
//            let context = CIContext(options: nil)
//            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
//                let processedImage = UIImage(cgImage: cgImage)
//                sampleImageView.image = processedImage
//            }
//        }
//    }
//}
import UIKit
import SnapKit
import Then
import Combine
import CombineCocoa

extension HomeViewController {
    enum Constant {
        static var sliderInitialValue: Float = 0.0
        static var sliderMinimumValue: Float = -0.1
        static var sliderMaximumValue: Float = 0.1
        
        static func filterValue(type: ImageFilterType, with sliderValue: Float = 0.0) -> String { type.rawValue + ": " + String(format: "%.2f", sliderValue) }
    }
}


final class HomeViewController: UIViewController {
    var cancellables = Set<AnyCancellable>()
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let sampleImageView: UIImageView = UIImageView().then {
        $0.backgroundColor = .black
    }
    
    let albumButton = UIButton().then {
        $0.setTitle("앨범 불러오기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .systemBlue
    }
    
    var sliderStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
    }
    
    var sliders: [UISlider] = []
    
    var originalImage: UIImage?  // 원본 이미지를 저장할 속성
    var brightness: Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupSubviews()
        setupConstraints()
        bindAction()
    }
    
    private func setupSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        createFilterSlider()
        
        contentView.addSubview(sampleImageView)
        contentView.addSubview(albumButton)
        contentView.addSubview(sliderStackView)
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
        
        sampleImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).inset(32)
            make.horizontalEdges.equalToSuperview().inset(32)
            make.height.equalTo(300)
        }
        
        albumButton.snp.makeConstraints { make in
            make.top.equalTo(sampleImageView.snp.bottom).offset(32)
            make.horizontalEdges.equalToSuperview().inset(32)
            make.height.equalTo(42)
        }
        
        sliderStackView.snp.makeConstraints { make in
            make.top.equalTo(albumButton.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(1000)
            make.bottom.equalTo(contentView.snp.bottom).offset(-16)
        }
    }
    
    private func bindAction() {
        albumButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary
                self?.present(imagePicker, animated: true, completion: nil)
            }
            .store(in: &cancellables)
    }
}

extension HomeViewController {
    private func createFilterSlider() {
        ImageFilterType.allCases.forEach { filter in
            let container = UIView()
            
            let slider = UISlider().then {
                $0.value = Constant.sliderInitialValue
                $0.minimumValue = Constant.sliderMinimumValue
                $0.maximumValue = Constant.sliderMaximumValue
            }
            
            let sliderValue = UILabel().then {
                $0.text = Constant.filterValue(type: filter)
                $0.textColor = .black
                $0.font = UIFont.systemFont(ofSize: 14)
            }
            
            container.addSubview(slider)
            container.addSubview(sliderValue)
            
            slider.snp.makeConstraints { make in
                make.top.equalToSuperview().inset(16)
                make.horizontalEdges.equalToSuperview().inset(16)
            }
            
            sliderValue.snp.makeConstraints { make in
                make.top.equalTo(slider.snp.bottom).offset(16)
                make.centerX.equalToSuperview()
            }
            
            sliders.append(slider)
            
            slider.valuePublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] value in
                    guard let self = self else { return }
                    self.brightness = value
                    sliderValue.text = Constant.filterValue(type: filter, with: value)
                    
                    self.adjustBrightness(of: self.originalImage, brightness: self.brightness)
                }
                .store(in: &cancellables)
            
            sliderStackView.addArrangedSubview(container)
        }
    }
}

//MARK: - Image Picker
extension HomeViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            originalImage = image  // 원본 이미지 저장
            sliders.forEach { $0.value = Constant.sliderInitialValue }
            
            adjustBrightness(of: image, brightness: brightness)  // 초기 밝기 조정
        }
        dismiss(animated: true, completion: nil)
    }
    
    func adjustBrightness(of image: UIImage?, brightness: Float) {
        guard let ciImage = CIImage(image: image ?? UIImage()) else { return }
        
        let filter = CIFilter(name: "CIColorControls")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        filter?.setValue(brightness, forKey: kCIInputBrightnessKey)  // 휘도 조정
        
        if let outputImage = filter?.outputImage {
            let context = CIContext(options: nil)
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                let processedImage = UIImage(cgImage: cgImage)
                sampleImageView.image = processedImage
            }
        }
    }
}

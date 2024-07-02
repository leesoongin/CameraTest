import UIKit
import SnapKit
import Then
import Combine
import CombineCocoa
import CoreImage

extension HomeViewController {
    enum Constant {
        static var sliderInitialValue: Float = 0.0
        static var sliderMinimumValue: Float = -1
        static var sliderMaximumValue: Float = 1
        
        static func filterValue(type: ImageFilterType, with sliderValue: Float = 0.0) -> String { type.rawValue + ": " + String(format: "%.2f", sliderValue) }
    }
}


final class HomeViewController: UIViewController {
    var cancellables = Set<AnyCancellable>()
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let sampleImageView: UIImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
//        $0.backgroundColor = .black
    }
    
    let albumButton = UIButton().then {
        $0.setTitle("앨범 불러오기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .systemBlue
    }
    
    var sliderStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillProportionally
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
                make.bottom.equalToSuperview()
            }
            
            sliders.append(slider)
            
            slider.valuePublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] value in
                    guard let self = self else { return }
                    self.brightness = value
                    sliderValue.text = Constant.filterValue(type: filter, with: value)
                    
                    adjustLuminance(of: self.originalImage, luminance: CGFloat(value))
                    print("::: > \(value)")
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
            
            adjustLuminance(of: image, luminance: 0)
        }
        dismiss(animated: true, completion: nil)
    }
    
    private func adjustBrightness(of image: UIImage?, brightness: Float) {
        guard let ciImage = CIImage(image: image ?? UIImage()) else { return }
        
        let filter = CIFilter(name: "CIColorControls")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        filter?.setValue(brightness, forKey: kCIInputBrightnessKey)  // 0.0 ~ 1.0 범위
        filter?.setValue(1.0, forKey: kCIInputContrastKey)  // 대비: 0.0 ~ 4.0
        filter?.setValue(1.0, forKey: kCIInputSaturationKey)  // 채도: 0.0 ~ 2.0
        
        if let outputImage = filter?.outputImage {
            let context = CIContext(options: nil)
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                let processedImage = UIImage(cgImage: cgImage)
                sampleImageView.image = processedImage
            }
        }
    }
    
    func adjustLuminance(of image: UIImage?, luminance: CGFloat) {
        guard let ciImage = CIImage(image: image ?? UIImage()) else { return }
        let normalizedLuminance = luminance
        
        // 어두운 부분을 밝히기 위해 노출 조정
        let exposureAdjust = CIFilter(name: "CIExposureAdjust")!
        exposureAdjust.setValue(ciImage, forKey: kCIInputImageKey)
        exposureAdjust.setValue(normalizedLuminance * 0.5, forKey: kCIInputEVKey)
        guard let exposureAdjusted = exposureAdjust.outputImage else { return }
        
        // 하이라이트 추가 및 섀도우 조정
        let highlightShadowAdjust = CIFilter(name: "CIHighlightShadowAdjust")!
        highlightShadowAdjust.setValue(exposureAdjusted, forKey: kCIInputImageKey)
        highlightShadowAdjust.setValue(1 + (normalizedLuminance * 0.75), forKey: "inputHighlightAmount")
        highlightShadowAdjust.setValue(normalizedLuminance * 0.5, forKey: "inputShadowAmount")
        guard let highlightShadowAdjusted = highlightShadowAdjust.outputImage else { return }
        
        // 대비 조정
        let colorControls = CIFilter(name: "CIColorControls")!
        colorControls.setValue(highlightShadowAdjusted, forKey: kCIInputImageKey)
        colorControls.setValue(1 + (normalizedLuminance * 0.1), forKey: kCIInputContrastKey)
        guard let contrastAdjusted = colorControls.outputImage else { return }
        
        let context = CIContext(options: nil)
        if let cgImage = context.createCGImage(contrastAdjusted, from: contrastAdjusted.extent) {
            let processedImage = UIImage(cgImage: cgImage)
            sampleImageView.image = processedImage
        }
    }
    
    private func adjustVibrance(of image: UIImage?, vibrance: CGFloat) {
        guard let ciImage = CIImage(image: image ?? UIImage()) else { return }
        
        let filter = CIFilter(name: "CIVibrance")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        filter?.setValue(vibrance, forKey: "inputAmount")
        
        guard let outputImage = filter?.outputImage else { return }
        
        let context = CIContext(options: nil)
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }
        
        sampleImageView.image = UIImage(cgImage: cgImage)
    }
    
    private func adjustHighlight(of image: UIImage?, amount: Float) {
        guard let ciImage = CIImage(image: image ?? UIImage()) else { return }
        
        let filter = CIFilter(name: "CIHighlightShadowAdjust")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        filter?.setValue(amount, forKey: "inputHighlightAmount")
        
        guard let outputImage = filter?.outputImage else { return }
        
        let context = CIContext(options: nil)
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }
        
        sampleImageView.image = UIImage(cgImage: cgImage)
    }
}

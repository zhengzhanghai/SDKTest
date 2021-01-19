//
//  ScanViewController.swift
//  WashingMachine
//
//  Created by 潘奇 on 16/10/28.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

import UIKit
import AVFoundation
import SafariServices

class ScanViewController: BaseViewController {
    
    var lineImageView:UIImageView?
    var timer:Timer?
    var torchBtn: UIButton!
    
    fileprivate lazy var indicatorView: UIView = {
        
        let view = UIView()
        
        let activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicatorView.startAnimating()
        view.addSubview(activityIndicatorView)
        activityIndicatorView.snp.makeConstraints({ (make) in
            make.top.centerX.equalToSuperview()
        })
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "加载中..."
        label.textColor = UIColor.white
        view.addSubview(label)
        label.snp.makeConstraints({ (make) in
            make.bottom.centerX.equalToSuperview()
        })

        return view
    }()
    
    lazy var topBar: UIView = {
        let topView = UIView()
        let backBtn = UIButton()
        backBtn.setImage(UIImage(named: "back_white_1"), for: .normal)
        backBtn.addTarget(self, action: #selector(clickBackBtn), for: .touchUpInside)
        topView.addSubview(backBtn)
        backBtn.snp.makeConstraints { (make) in
            make.top.equalTo(STATUSBAR_ABSOLUTE_HEIGHT+12)
            make.left.equalTo(16)
            make.width.height.equalTo(24)
        }
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor(rgb: 0xFFFFFF)
        titleLabel.font = font_PingFangSC_Regular(15)
        titleLabel.text = "扫码"
        topView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.centerY.equalTo(backBtn)
            make.centerX.equalToSuperview()
        }
        return topView
    }()
    
//    lazy var
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "扫码"
        self.view.backgroundColor = UIColor.black
        
        self.view.addSubview(topBar)
        topBar.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(STATUSBAR_ABSOLUTE_HEIGHT+44)
        }
        self.view.addSubview(indicatorView)
        indicatorView.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(80)
            make.height.equalTo(70)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopScan()
        timer?.fireDate = Date.distantFuture
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isFirstViewDidAppear {
            if !cameraPermissions() {
                let alertController = UIAlertController(title: "提示", message:"请在设置中打开相机使用权限", preferredStyle: UIAlertController.Style.alert)
                let cancelAction = UIAlertAction(title: "确定", style: UIAlertAction.Style.cancel, handler: { (_) in
                    print("取消")
                    self.navigationController?.popViewController(animated: true)
                })
                
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            }
            setupSession()
            self.addOtherBtn()
            
            // 定时器
            timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(animation), userInfo: nil, repeats: true)
            RunLoop.current.add(timer!, forMode: .common)
        }
        
        indicatorView.removeFromSuperview()
        
        startScan()
        timer?.fireDate = Date.distantPast
    }
    
    fileprivate func openTroch(open: Bool) {
        if isHasTorch() {
            let device = AVCaptureDevice.default(for: AVMediaType.video)
            // 请求独占访问硬件设备
            do {
               try device?.lockForConfiguration()
                if open {
                    device?.torchMode = AVCaptureDevice.TorchMode.on
                } else {
                    device?.torchMode = AVCaptureDevice.TorchMode.off
                }
                // 请求解除独占访问设备
                device?.unlockForConfiguration()
            } catch {
                
            }
        }
    }
    
    fileprivate func isHasTorch() -> Bool {
        let device = AVCaptureDevice.default(for: AVMediaType.video)
        if device?.hasTorch ?? false {
            return true
        }
        return false
    }
    
    /// 添加闪光灯，输入设备编号按钮
    fileprivate func addOtherBtn() {
        let scanX = BOUNDS_WIDTH * 0.5 - 140
        let scanY = BOUNDS_HEIGHT * 0.5 - 140 - 64
        
        let torchBtn = UIButton(type: .custom)
        torchBtn.backgroundColor = UIColor(rgb: 0xFFFFFF).withAlphaComponent(0.5)
        torchBtn.layer.cornerRadius = 28
        torchBtn.frame = CGRect(x: scanX, y: scanY+280+56, width: 56, height: 56)
        torchBtn.setImage(UIImage(named: "torch_off"), for: UIControl.State.normal)
        torchBtn.addTarget(self, action: #selector(clickTorch(btn:)), for: UIControl.Event.touchUpInside)
        self.view.addSubview(torchBtn)
        
        let inputCodeBtn = UIButton(type: .custom)
        inputCodeBtn.backgroundColor = UIColor(rgb: 0xFFFFFF).withAlphaComponent(0.5)
        inputCodeBtn.layer.cornerRadius = 28
        inputCodeBtn.frame = CGRect(x: scanX+280-56, y: scanY+280+56, width: 56, height: 56)
        inputCodeBtn.setImage(UIImage(named: "torch_off"), for: UIControl.State.normal)
        inputCodeBtn.addTarget(self, action: #selector(clickInput), for: UIControl.Event.touchUpInside)
        self.view.addSubview(inputCodeBtn)
    }
    
    /**
     判断相机权限
 
     - returns: 有权限返回true，没权限返回false
     */
    func cameraPermissions() -> Bool{
        let authStatus:AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        
        if(authStatus == AVAuthorizationStatus.denied || authStatus == AVAuthorizationStatus.restricted) {
            return false
        }else {
            return true
        }
    }
    
    func clickBackEvent(){
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func setupSession() {
        guard let input = inputDevice  else {
            return
        }
        // 1. 判断是否能够添加设备
        if !session.canAddInput(input) {
            print("无法添加输入设备")
            return
        }
        // 2. 判断能否添加输出数据
        if !session.canAddOutput(dataOutput) {
            print("无法添加输出数据")
            return
        }
        // 3. 添加设备
        session.addInput(input)
        session.addOutput(dataOutput)
        ZZPrint(dataOutput.availableMetadataObjectTypes)
        
        // 4. 设置扫描数据类型
        dataOutput.metadataObjectTypes = dataOutput.availableMetadataObjectTypes
        // 5. 设置输出代理
        dataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        setupLayers()
        startScan()
    }
    
    /// 设置图层
    func setupLayers() {
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer.frame = CGRect(x: 0,y: 0, width: BOUNDS_WIDTH, height: BOUNDS_HEIGHT)
        view.layer.insertSublayer(previewLayer, at: 0)
        
        //扫描边框视图
        let scanBorderView = SacnBorderView()
        scanBorderView.frame = CGRect(x: BOUNDS_WIDTH * 0.5 - 140, y: BOUNDS_HEIGHT * 0.5 - 140 - 64, width: 280, height: 280)
        //初始化二维码的扫描线的位置
        lineImageView = UIImageView.init(frame:CGRect(x: 30, y: 10, width: 220, height: 2))
        lineImageView!.image = UIImage.init(named: "shaomiaoxian_new")
        scanBorderView.addSubview(lineImageView!)
        
        //添加到视图上
        self.view.addSubview(scanBorderView)
        
        
        let path = UIBezierPath.init(rect: CGRect(x: 0, y: 0, width: BOUNDS_WIDTH, height: BOUNDS_HEIGHT ))
       
        let X = BOUNDS_WIDTH * 0.5 - 140
        let Y = BOUNDS_HEIGHT * 0.5 - 140 - 64
        path.move(to: CGPoint(x: X + 280.0, y: Y ))
        path.addLine(to: CGPoint(x: X, y: Y))
        path.addLine(to: CGPoint(x: X, y: Y + 280.0))
        path.addLine(to: CGPoint(x: X + 280.0,y: Y + 280.0))
        path.addLine(to: CGPoint(x: X + 280.0, y: Y ))
        // 设置镂空的圆圈
        path.move(to: CGPoint(x: X + 28, y: Y + 280 + 56 +  28))
        path.addArc(withCenter: CGPoint(x: X + 28, y: Y + 280 + 56 + 28),
                    radius: 28,
                    startAngle: 0,
                    endAngle: -CGFloat.pi*2,
                    clockwise: false)
        // 设置镂空的圆圈
        path.move(to: CGPoint(x: X + 280 - 28, y: Y + 280 + 56 +  28))
        path.addArc(withCenter: CGPoint(x: X + 280 - 28, y: Y + 280 + 56 +  28),
                    radius: 28,
                    startAngle: 0,
                    endAngle: -CGFloat.pi*2,
                    clockwise: false)
        
        
        path.usesEvenOddFillRule = true;
        let shapeLayer = CAShapeLayer.init()
        shapeLayer.path = path.cgPath;
        shapeLayer.fillColor = UIColor.black.cgColor;  //其他颜色都可以，只要不是透明的
        shapeLayer.fillRule=CAShapeLayerFillRule.evenOdd;
        
        let translucentView = UIView();
        translucentView.frame = CGRect(x: 0, y: 0, width: BOUNDS_WIDTH, height: BOUNDS_HEIGHT )
        translucentView.backgroundColor = UIColor.black
        translucentView.alpha = 0.7;
        translucentView.layer.mask = shapeLayer;
        self.view.addSubview(translucentView)
        self.view.bringSubviewToFront(topBar)
    }
    
    fileprivate func startScan() {
        session.startRunning()
    }
    fileprivate func stopScan() {
        session.stopRunning()
    }
    /// 拍摄会话，是扫描的桥梁
    lazy var session: AVCaptureSession = {
        let captureSession = AVCaptureSession()
        captureSession.canSetSessionPreset(AVCaptureSession.Preset.high)
        return captureSession
    }()
    // 2. 输入设备
    lazy var inputDevice: AVCaptureDeviceInput? = {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else {
            return nil;
        }
        do {
            return try AVCaptureDeviceInput(device: device)
        } catch {
            print(error)
            return nil
        }
    }()
    
    
    /// 数据输出
    lazy var dataOutput: AVCaptureMetadataOutput = {
        return AVCaptureMetadataOutput()
    }()
    
    /// 预览图层
    lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        let previewLayer = AVCaptureVideoPreviewLayer(session: self.session)
//        previewLayer.setAffineTransform(CGAffineTransform(scaleX: 1, y: 1))
        return previewLayer
    }()
    
   
    
    // 提示不能识别二维码
    fileprivate func promptUnknown(_ QRCode: String) {
        let alertVC = UIAlertController(title: "不能识别: \(QRCode)", message: "", preferredStyle: UIAlertController.Style.alert)
        let sureAction = UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: { (_) in
            self.startScan()
        })
        alertVC.addAction(sureAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    @objc func animation()
    {
        UIView.animate(withDuration: 2.8, delay: 0, options: .curveLinear, animations: { 
            self.lineImageView?.frame = CGRect(x: 30, y: 260, width: 220, height: 2);
            }) { (Bool) in
            self.lineImageView?.frame = CGRect(x: 30, y: 10, width: 220, height: 2);
        }
    }
    
    // 通过IMEI 获取洗衣机详情
    fileprivate func washingDetailWithImei(imei: String) {
        self.showWaitingView(keyWindow)
        DeviceViewModel.loadWasherDetails(imei, getUserId()) { (model, message) in
            
            self.hiddenWaitingView()
            
            guard let device = model else {
                showError(message, superView: self.view)
                return
            }
            
            if device.processPattern == .onewayCommunication {
                // 如果是吹风机
                let vc = UseBlowerViewController(device)
                vc.removeControllerCount = 1
                self.pushViewController(vc)
            } else if device.processPattern == .equipmentCoemmunication {
                
                guard device.isEmpty else {
                    let alertStr = "洗衣机当前" + device.washStatusStr + "，请选择其他空闲设备"
                    self.alertSurePrompt(message: alertStr, sureAction: { (_) in
                        self.startScan()
                    })
                    return
                }
                
                DeviceViewModel.pushWashingPayVC(device, self, removeVCCount: 1)
            }
        }
    }
}

//MARK: 事件相关
fileprivate extension ScanViewController {
    /// 点击返回按钮
    @objc func clickBackBtn() {
        self.navigationController?.popViewController(animated: true)
    }
    
    /// 点击闪光灯
    @objc func clickTorch(btn: UIButton) {
        btn.isSelected = !btn.isSelected
        openTroch(open: btn.isSelected)
    }
    
    /// 点击输入设备编号
    @objc func clickInput() {
        session.stopRunning()
        
        let vc = ScanInputViewController()
        vc.removeControllerCount = 1
        pushViewController(vc)
    }
    
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate
extension ScanViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        session.stopRunning()
        guard let firstMetada = metadataObjects.first as? AVMetadataMachineReadableCodeObject else {
            ZZPrint("扫描结果出错")
            return
        }
        guard let valueString = firstMetada.stringValue else {
            ZZPrint("扫描结果出错")
            return
        }
        
        let result = self.verifyScaningResult(valueString)
        if result.0 {
            self.washingDetailWithImei(imei: result.1)
        } else {
            self.promptUnknown(valueString)
        }
        ZZPrint(result.1)
    }
    
    /// 验证扫描出来的字符串
    fileprivate func verifyScaningResult(_ scanResultStr: String?) -> (Bool, String) {
        guard let valueString = scanResultStr else {
            return (false, "")
        }
        if valueString.isNumberOrAlphabet() {
            // 如果是扫描出的字符串全是数字和字母，直接调用接口匹配这台设备
            return (true, valueString)
        } else {
            guard valueString.isWebUrl() else {
                return (false, valueString)
            }
            if valueString.contains("machcode=") {
                let separr = valueString.components(separatedBy: "machcode=")
                guard let targetStr = separr.last else {
                    return (false, valueString)
                }
                if targetStr.contains("&") {
                    let arr = targetStr.components(separatedBy: "&")
                    guard let str = arr.first else {
                        return (false, valueString)
                    }
                    return (!str.isEmpty, str.isEmpty ? valueString : str)
                } else {
                    return (!targetStr.isEmpty, targetStr)
                }
            } else if valueString.contains("/d/") {
                // 如果是扫描出的网址形式，从地址中分离出设备code，在调用接口匹配这台设备
                let separateArray = valueString.components(separatedBy: "/d/")
                guard let imei = separateArray.last else {
                    return (false, valueString)
                }
                guard imei.isNumberOrAlphabet() else {
                    return (false, valueString)
                }
                return (true, imei)
            } else {
                return (false, valueString)
            }
        }
    }
}

//MARK: --------------- didMove(toParentViewController parent: UIViewController?)  ------------------
extension ScanViewController {
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        
        if parent == nil {
            timer?.invalidate()
            timer = nil
        }
    }
}

extension ScanViewController {
    class SacnBorderView: UIView {
        
        private let tagBase = 19090
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupUI()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func setupUI() {
            for i in 0 ..< 8 {
                let line = UIView()
                line.backgroundColor = UIColor(rgb: 0xFFFFFF)
                line.tag = tagBase + i
                addSubview(line)
            }
        }
        
        override func layoutSubviews() {
            let size = bounds.size
            let lineWidth: CGFloat = 26
            let lineHeight: CGFloat = 1
            for view in subviews {
                switch view.tag - tagBase {
                case 0:
                    view.frame = CGRect(x: 0, y: 0, width: lineWidth, height: lineHeight)
                case 1:
                    view.frame = CGRect(x: 0, y: 0, width: lineHeight, height: lineWidth)
                case 2:
                    view.frame = CGRect(x: size.width-lineWidth, y: 0, width: lineWidth, height: lineHeight)
                case 3:
                    view.frame = CGRect(x: size.width-lineHeight, y: 0, width: lineHeight, height: lineWidth)
                case 4:
                    view.frame = CGRect(x: 0, y: size.height-lineHeight, width: lineWidth, height: lineHeight)
                case 5:
                    view.frame = CGRect(x: 0, y: size.height-lineWidth, width: lineHeight, height: lineWidth)
                case 6:
                    view.frame = CGRect(x: size.width-lineWidth, y: size.height-lineHeight, width: lineWidth, height: lineHeight)
                case 7:
                    view.frame = CGRect(x: size.width-lineHeight, y: size.height-lineWidth, width: lineHeight, height: lineWidth)
                default:
                    ZZPrint("---")
                }
            }
        }
    }
}







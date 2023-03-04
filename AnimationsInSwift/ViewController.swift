//
//  ViewController.swift
//  AnimationsInSwift
//
//  Created by Erkan on 3.03.2023.
//

import UIKit

class ViewController: UIViewController, URLSessionDownloadDelegate {

    let shapeLayer = CAShapeLayer()
    let traceLayer = CAShapeLayer()
    let pulsinLayer = CAShapeLayer()
    
    let labelPercent : UILabel = UILabel()
    
    
    // uygulama arka plana gittiğinde animasyon durduğu için yazılması gereken fonksiyon
    
    private func checkProgram(){
        NotificationCenter.default.addObserver(self, selector: #selector(checkEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc private func checkEnterForeground(){
        animatePulsingLayer()
        print("Ön planda")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        checkProgram()
        
        
        view.backgroundColor = UIColor.backgroundColor
                                                                                // 0 360 derece yani tam daire
        let circularPath = UIBezierPath(arcCenter: CGPoint.zero, radius: 110, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        
        
        //pulsing layer
        pulsinLayer.path = circularPath.cgPath
        pulsinLayer.strokeColor = UIColor.clear.cgColor
        pulsinLayer.lineWidth = 10
        pulsinLayer.fillColor = UIColor.pulsingFillColor.cgColor
        pulsinLayer.lineCap = .round
        pulsinLayer.position = view.center
        view.layer.addSublayer(pulsinLayer)
        animatePulsingLayer()
        
        
        traceLayer.path = circularPath.cgPath
        traceLayer.strokeColor = UIColor.traceStrokeColor.cgColor
        traceLayer.lineWidth = 20
        traceLayer.fillColor = UIColor.backgroundColor.cgColor
        traceLayer.lineCap = CAShapeLayerLineCap.round
        traceLayer.position = view.center
        view.layer.addSublayer(traceLayer)
        

        
        
        
        
        shapeLayer.path = circularPath.cgPath
        
        shapeLayer.strokeColor = UIColor.outlineStrokeColor.cgColor // çevresinin rengi
        
        shapeLayer.lineWidth = 20  // dışındaki hattın kalınlaştırılması
        
        shapeLayer.strokeEnd = 0
        shapeLayer.lineCap = CAShapeLayerLineCap.round // dış hattınının kenarlarının yuvarlakştırılması
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.position = view.center
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi/2, 0, 0, 1)
        
        //Oluşturulan layer'ı ekrana ekledik
    
        view.layer.addSublayer(shapeLayer)
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapBar)))
        
        labelPercent.text = "Başlat"
        labelPercent.textAlignment = .center
        labelPercent.font = UIFont.boldSystemFont(ofSize: 29)
        view.addSubview(labelPercent)
        labelPercent.frame = CGRect(x: 0, y: 0, width: 110, height: 110)
        labelPercent.center = view.center
        
        
        
    }
    
    private func animatePulsingLayer(){
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 1.3
        animation.duration = 2
        
        //animasyonun sürekli tekrarlanması
        
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        
        //dışarı çıkarken yavaş  ya da hızlı
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        
        pulsinLayer.add(animation, forKey: "pulsingView")
    }
    
    fileprivate func CircleAnimation() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = 1
        animation.duration = 3
        
        //süre dolduğunda tekrar eski haline dönmemesi için
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        
        shapeLayer.add(animation, forKey: "animation")
    }
    
    let urlAdress = "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4"
    private func downloadVideo(){
        
        shapeLayer.strokeEnd = 0
        pulsinLayer.fillColor = UIColor.pulsingFillColor.cgColor
       // return
        
        let sessionUrl = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue())
        guard let url = URL(string: urlAdress) else{
            return
        }
        let task = sessionUrl.downloadTask(with: url)
        task.resume()
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("İndirme işlemi tamamlandı")
        DispatchQueue.main.async {
            self.labelPercent.text = "Bitti"
            self.pulsinLayer.fillColor = UIColor.pulsingFillColorFinish.cgColor

        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        print(bytesWritten,totalBytesWritten,totalBytesExpectedToWrite) // indirilecek dosyanın boyutu ve indirilen boyutu alarak
                                                                        // yüzdelik olarak hesaplama ve strokea yansıtma
        
        let percent = Int((Float(totalBytesWritten) / Float(totalBytesExpectedToWrite))*100)
        DispatchQueue.main.async {
            self.shapeLayer.strokeEnd = CGFloat(exactly: Float(totalBytesWritten) / Float(totalBytesExpectedToWrite))!
            
            self.labelPercent.text = "%\(percent)"

        }
        //print(percent)
        
    }
    
    @objc private func tapBar(){
        downloadVideo()
       // CircleAnimation()
        
        
        //print("Ekrana dokundun")
        
    }


}


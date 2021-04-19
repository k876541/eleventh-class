//
//  editingViewController.swift
//  eleventh-class
//
//  Created by Ryan Chang on 2021/4/16.
//

import UIKit

var imageStatus = ImageStatus()

class editingViewController: UIViewController, UIColorPickerViewControllerDelegate & UINavigationControllerDelegate & UIImagePickerControllerDelegate{

    
    @IBOutlet weak var rotateStackView: UIStackView!
    @IBOutlet weak var ratioStackView: UIStackView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var setColorView: UIView!
    
    let image : UIImage
    
    init?(coder:NSCoder ,image: UIImage) {
        self.image = image
        super.init(coder: coder)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //濾鏡顏色清除且遍半透明
        setColorView.backgroundColor = .clear
        setColorView.alpha = CGFloat(0.5)

        //背景圖片顏色清除
        backgroundView.backgroundColor = .clear
        
        //存取選擇的圖片到mainImageView
        mainImageView.image = image
        
        //把旋轉和比例的stackView藏起來
        rotateStackView.isHidden = true
        ratioStackView.isHidden = true
        
        setImageSize()
    }
    
    //設定背景圖片大小
    func setImageSize() {
        let width = backgroundView.bounds.width
        mainImageView.bounds.size = CGSize(width: width, height: width * 1.22)
        setColorView.bounds.size = mainImageView.bounds.size
    }
    
    //旋轉stackView開關
    @IBAction func rotateButton(_ sender: Any) {
        if rotateStackView.isHidden  {
            rotateStackView.isHidden = false
        }else {
            rotateStackView.isHidden = true
        }
        ratioStackView.isHidden = true
    }
    
    //影像對稱
    @IBAction func flipImage(_ sender: Any) {
        if imageStatus.isMirrored == true{
            mainImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
            imageStatus.isMirrored = false
        }else {
            mainImageView.transform = CGAffineTransform(scaleX: -1, y: 1)
            imageStatus.isMirrored = true
        }
    }
    
    //逆時針轉
    @IBAction func rotateLeft(_ sender: Any) {
        imageStatus.flipCounts -= 1
        mainImageView.transform = CGAffineTransform(rotationAngle: (CGFloat.pi/180)*90*CGFloat(imageStatus.flipCounts))
        setColorView.transform = CGAffineTransform(rotationAngle: (CGFloat.pi/180)*90*CGFloat(imageStatus.flipCounts))
    }
    
    //順時針轉
    @IBAction func rotateRight(_ sender: Any) {
        imageStatus.flipCounts += 1
        mainImageView.transform = CGAffineTransform(rotationAngle: (CGFloat.pi/180)*90*CGFloat(imageStatus.flipCounts))
        setColorView.transform = CGAffineTransform(rotationAngle: (CGFloat.pi/180)*90*CGFloat(imageStatus.flipCounts))
    }
    
    //比例stackView開關
    @IBAction func ratioButton(_ sender: Any) {
        if ratioStackView.isHidden{
            ratioStackView.isHidden = false
        }else {
            ratioStackView.isHidden = true
        }
        rotateStackView.isHidden = true
    }
    
    //改變比例用的
    @IBAction func ratiochange(_ sender: UIButton) {
        let lenth = backgroundView.frame.width
        let width = lenth
        var hight = Int()
        
        switch sender.currentTitle {
        case "原圖":
            hight = Int(lenth * 1.22)
            mainImageView.contentMode = .scaleAspectFit
        case "正方形":
            hight = Int(lenth)
            mainImageView.contentMode = .scaleAspectFill
        case "4:3":
            hight = Int(lenth / 4*3)
            mainImageView.contentMode = .scaleAspectFill
        case "16:9":
            hight = Int(lenth / 16*9)
            mainImageView.contentMode = .scaleAspectFill
        default: break
        }
        mainImageView.bounds.size = CGSize(width: CGFloat(width), height:CGFloat(hight))
        setColorView.bounds.size = mainImageView.bounds.size
    }
    
    //呼叫顏色選擇的UIColorPickerViewController()的delegate來選擇濾鏡顏色
    @IBAction func setViewColor(_ sender: Any) {
        let controller = UIColorPickerViewController()
        controller.delegate = self
        present(controller, animated: true, completion: nil)
    }
    
    
    //選擇濾鏡顏色
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        setColorView.backgroundColor = viewController.selectedColor
    }
    
    //利用UIGraphicsImageRenderer存照片
    @IBAction func saveImage(_ sender: Any) {
        
        let render = UIGraphicsImageRenderer(size: mainImageView.bounds.size)
        let image = render.image(actions: {(context) in backgroundView.drawHierarchy(in: mainImageView.bounds, afterScreenUpdates: true)})
        
        
        //分享或儲存
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
}

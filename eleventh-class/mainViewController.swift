//
//  mainViewController.swift
//  eleventh-class
//
//  Created by Ryan Chang on 2021/4/16.
//

import UIKit

class mainViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate  {
   
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addPhotoButton: UIButton!
    
    //跳到photoLabory之後，再點選照片之後的動作
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let image = info[.originalImage] as? UIImage
        
        if let editingViewController = storyboard?.instantiateViewController(identifier: "\(editingViewController.self)", creator: { coder in
            editingViewController.init(coder: coder, image: image!)
        }){
            show(editingViewController, sender: nil)
        }
        //離開視窗
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //設定NavigationBar 和 addPhotoButton的圓角
        setNavigationBar()
        addPhotoButton.layer.cornerRadius = addPhotoButton.frame.height/2
    }
    
    //把navigationBar 改為黑底 跟背景同色
    func setNavigationBar(){
        self.navigationController?.navigationBar.backgroundColor = .black
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
    }
    

    //前往photobibary
    @IBAction func addPhoto(_ sender: Any) {
        let controller = UIImagePickerController()
        controller.sourceType = .photoLibrary
        controller.delegate = self
        present(controller, animated: true, completion: nil)
    }
    

}

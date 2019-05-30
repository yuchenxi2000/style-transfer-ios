//
//  SelectViewController.swift
//  style
//
//  Created by yuchenxi on 2019/5/11.
//  Copyright © 2019 yuchenxi2000. All rights reserved.
//
//  Published under MIT License.
//

import UIKit

class SelectViewController: UIViewController {
    
    var selectedStyle : Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet var StyleButtons: [UIButton]!
    
    @IBAction func Select(_ sender: UIButton) {
        let num = StyleButtons.index(of: sender)
        back(with: num ?? self.selectedStyle)
    }
    
    private func back(with num : Int) {
        let controller = presentingViewController as? ViewController
        presentingViewController?.dismiss(animated: true, completion: {
            controller?.selectedStyle = num
            DispatchQueue.global(qos: .userInitiated).async {
                controller?.updateViewImage(for: nil, withStyle: num)
            }
        })
    }

}

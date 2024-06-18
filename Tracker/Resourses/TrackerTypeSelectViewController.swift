//
//  TrackerTypeSelectViewController.swift
//  Tracker
//
//  Created by Fedor on 18.06.2024.
//

import Foundation
import UIKit

final class TrackerTypeSelectViewController: UIViewController {
    
    private lazy var habbitButton: UIButton = {
        let habbitButton = UIButton(type: .system)
        habbitButton.translatesAutoresizingMaskIntoConstraints = false
        habbitButton.layer.cornerRadius = 16
        habbitButton.setTitle("Привычка", for: .normal)
        habbitButton.titleLabel?.font = UIFont(name: "SFProDisplay-Medium", size: 16)
        habbitButton.tintColor = .ypWhite
        habbitButton.backgroundColor = .trackerBlack
        return habbitButton
    }()
    
    
    private lazy var notRegularButton: UIButton = {
        let notRegularButton = UIButton(type: .system)
        notRegularButton.translatesAutoresizingMaskIntoConstraints = false
        notRegularButton.layer.cornerRadius = 16
        habbinotRegularButtontButton.backgroundColor = .trackerBlack
        return notRegularButton
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        setConstrains()
    }
    
    func addSubviews(){
        
    }
    
    func setConstrains(){
        
    }
    
}

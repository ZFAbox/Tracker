//
//  TrackerPageViewController.swift
//  Tracker
//
//  Created by Fedor on 12.08.2024.
//

import Foundation
import UIKit

final class TrackerPageViewController: UIPageViewController {
    
    private let pageOneText = NSLocalizedString("pageOneText", comment: "First page of onboard screen")
    private let pageTwoText = NSLocalizedString("pageTwoText", comment: "Second page of onboard screen")
    private let startButtonText = NSLocalizedString("startButtonText", comment: "Start button text")
    
    private lazy var onboardPages: [UIViewController] = {
        let page1 = OnboardViewController(image: #imageLiteral(resourceName: "Onboard Page 1"), onboardText: pageOneText)
        let page2 = OnboardViewController(image: #imageLiteral(resourceName: "Onboard Page 2"), onboardText: pageTwoText)
        return [page1, page2]
    }()
    
    private lazy var startButton: UIButton = {
        let startButton = UIButton(type: .system)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.layer.cornerRadius = 16
        startButton.setTitle(startButtonText, for: .normal)
        startButton.titleLabel?.font = UIFont(name: "SFProDisplay-Medium", size: 16)
        startButton.backgroundColor = .trackerBlack
        startButton.tintColor = .trackerWhite
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        return startButton
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.numberOfPages = onboardPages.count
        
        pageControl.currentPageIndicatorTintColor = .trackerBlack
        pageControl.pageIndicatorTintColor = .trackerBlackOpacity30
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        if let firstPage = onboardPages.first {
            setViewControllers([firstPage], direction: .forward, animated: true)
        }
        
        addSubviews()
        setConstraints()
        
    }
    
    @objc func startButtonTapped() {
        let vc = TabBarViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    
    private func addSubviews(){
        view.addSubview(startButton)
        view.addSubview(pageControl)
    }
    
    private func setConstraints(){
        setStartButtonConstraints()
        setPageControlConstraints()
    }
    
    private func setStartButtonConstraints(){
        NSLayoutConstraint.activate([
            startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            startButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setPageControlConstraints(){
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: startButton.topAnchor, constant: -24)
        ])
    }
}

extension TrackerPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentPageIndex = onboardPages.firstIndex(of: viewController) else { return nil}
        let previousIndex = currentPageIndex - 1
        guard previousIndex >= 0 else { return onboardPages.last}
        return onboardPages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currntPageIndex = onboardPages.firstIndex(of: viewController) else { return nil }
        let nextIndex = currntPageIndex + 1
        guard nextIndex < onboardPages.count else { return onboardPages.first}
        return onboardPages[nextIndex]
    }
}

extension TrackerPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currenViewController = pageViewController.viewControllers?.first,
           let currentIndex = onboardPages.firstIndex(of: currenViewController) {
            pageControl.currentPage = currentIndex
        }
    }
}

//
//  ActionSheetPresentationController.swift
//  ELG
//
//  Created by Johannes Jakob on 18/08/2017
//  © 2017 Caleb Davenport, Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit

final class ActionSheetPresentationController: UIPresentationController {
	// MARK: - Properties
	
	private var dimmingView: UIView!
	private var customPresentedView: UIView!
	
	override var presentedView: UIView? {
		return customPresentedView
	}
	
	override var frameOfPresentedViewInContainerView: CGRect {
		let size = customPresentedView.systemLayoutSizeFitting(containerView!.bounds.size, withHorizontalFittingPriority: UILayoutPriorityRequired, verticalFittingPriority: UILayoutPriorityFittingSizeLevel)
		
		let (slice, _) = containerView!.bounds.divided(atDistance: size.height, from: .maxYEdge)
		
		return slice
	}
	
	// MARK: - UIPresentationController
	
	override func presentationTransitionWillBegin() {
		super.presentationTransitionWillBegin()
		
		if dimmingView == nil {
			dimmingView = UIView()
			dimmingView.backgroundColor = UIColor(white: 0, alpha: 0.4)
			
			let cancelGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cancel))
			
			dimmingView.addGestureRecognizer(cancelGestureRecognizer)
			
			dimmingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
			dimmingView.frame = containerView!.bounds
			
			containerView!.addSubview(dimmingView)
		}
		
		if customPresentedView == nil {
			let dismissButton = ActionSheetPresentationControllerDismissButton()
			
			dismissButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
			dismissButton.setContentHuggingPriority(UILayoutPriorityDefaultHigh, for: .vertical)
			
			let dismissButtonSectionView = ActionSheetPresentationControllerSectionView()
			
			dismissButton.translatesAutoresizingMaskIntoConstraints = false
			dismissButtonSectionView.addSubview(dismissButton)
			
			let presentedViewControllerSectionView = ActionSheetPresentationControllerSectionView()
			
			presentedViewController.view.translatesAutoresizingMaskIntoConstraints = false
			presentedViewControllerSectionView.addSubview(presentedViewController.view)
			
			NSLayoutConstraint.activate([
				NSLayoutConstraint(item: dismissButton, attribute: .top, relatedBy: .equal, toItem: dismissButtonSectionView, attribute: .top, multiplier: 1, constant: 0),
				NSLayoutConstraint(item: dismissButton, attribute: .trailing, relatedBy: .equal, toItem: dismissButtonSectionView, attribute: .trailing, multiplier: 1, constant: 0),
				NSLayoutConstraint(item: dismissButton, attribute: .bottom, relatedBy: .equal, toItem: dismissButtonSectionView, attribute: .bottom, multiplier: 1, constant: 0),
				NSLayoutConstraint(item: dismissButton, attribute: .leading, relatedBy: .equal, toItem: dismissButtonSectionView, attribute: .leading, multiplier: 1, constant: 0),
				
				NSLayoutConstraint(item: presentedViewController.view, attribute: .top, relatedBy: .equal, toItem: presentedViewControllerSectionView, attribute: .top, multiplier: 1, constant: 0),
				NSLayoutConstraint(item: presentedViewController.view, attribute: .trailing, relatedBy: .equal, toItem: presentedViewControllerSectionView, attribute: .trailing, multiplier: 1, constant: 0),
				NSLayoutConstraint(item: presentedViewController.view, attribute: .bottom, relatedBy: .equal, toItem: presentedViewControllerSectionView, attribute: .bottom, multiplier: 1, constant: 0),
				NSLayoutConstraint(item: presentedViewController.view, attribute: .leading, relatedBy: .equal, toItem: presentedViewControllerSectionView, attribute: .leading, multiplier: 1, constant: 0)
			])
			
			if #available(iOS 9, *) {
				let stackView = UIStackView(arrangedSubviews: [presentedViewControllerSectionView, dismissButtonSectionView])
				
				stackView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
				stackView.axis = .vertical
				stackView.isLayoutMarginsRelativeArrangement = true
				stackView.spacing = 10
				stackView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
				
				customPresentedView = stackView
			} else {
				let stackView = OAStackView.init(arrangedSubviews: [presentedViewControllerSectionView, dismissButtonSectionView])
				
				stackView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
				stackView.axis = .vertical
				stackView.isLayoutMarginsRelativeArrangement = true
				stackView.spacing = 10
				stackView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
				
				customPresentedView = stackView
			}
		}
		
		dimmingView.alpha = 0
		
		presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
			self.dimmingView.alpha = 1
		}, completion: nil)
	}
	
	override func dismissalTransitionWillBegin() {
		presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
			self.dimmingView.alpha = 0
		}, completion: nil)
	}
	
	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransition(to: size, with: coordinator)
		
		coordinator.animate(alongsideTransition: { _ in
			self.customPresentedView.frame = self.frameOfPresentedViewInContainerView
		}, completion: nil)
	}
	
	// MARK: - Private
	
	@objc private func cancel() {
		presentedViewController.dismiss(animated: true, completion: nil)
	}
}

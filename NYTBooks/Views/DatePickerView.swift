//
//  DatePickerView.swift
//  NYTBooks
//
//  Created by Wasan, Sahil on 14/01/18.
//  Copyright © 2018 Wasan, Sahil. All rights reserved.
//

import UIKit

protocol DatePickerViewDelegate: class {
    func dateDidSelected(date: Date)
    func dateSelectionCancel()
}

class DatePickerView: UIView {
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.maximumDate =  Date()
        self.addSubview(picker)
        return picker
    }()
    
    private lazy var toolBar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelPressed))
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolbar.setItems([cancel, space, done], animated: false)
        self.addSubview(toolbar)
        return toolbar
    }()
    
    weak var delegate: DatePickerViewDelegate? = nil
    
    fileprivate var constraint: NSLayoutConstraint? = nil
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: CGRect.zero)
        self.addConstraints()
    }
}

extension DatePickerView {
    private func addConstraints() {
        self.translatesAutoresizingMaskIntoConstraints = false
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        toolBar.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        toolBar.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        toolBar.bottomAnchor.constraint(equalTo: self.datePicker.topAnchor).isActive = true
        datePicker.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        datePicker.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.topAnchor.constraint(equalTo: toolBar.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: datePicker.bottomAnchor).isActive = true
        self.bringSubview(toFront: toolBar)
        self.backgroundColor = UIColor.white
    }
    
    override func didMoveToSuperview() {
        if let superview = superview {
            self.leadingAnchor.constraint(equalTo: superview.leadingAnchor).isActive = true
            self.trailingAnchor.constraint(equalTo: superview.trailingAnchor).isActive = true
            self.constraint = self.topAnchor.constraint(equalTo: superview.bottomAnchor, constant: 0.0)
            self.constraint?.isActive = true
        }
    }
}

// MARK: IBActions
extension DatePickerView {
    @objc func donePressed() {
        delegate?.dateDidSelected(date: datePicker.date)
        hideAndRemove()
    }
    
    @objc func cancelPressed() {
        delegate?.dateSelectionCancel()
        hideAndRemove()
    }
}

// MARK: Custom
extension DatePickerView {
    func show() {
        superview?.layoutIfNeeded()
        UIView.animate(withDuration: 0.5) {
            self.constraint?.constant = -(self.frame.size.height)
            self.superview?.layoutIfNeeded()
        }
    }
    
    func hideAndRemove() {
        self.superview?.layoutIfNeeded()
        UIView.animate(withDuration: 0.5, animations: {
            self.constraint?.constant = 0.0
            self.superview?.layoutIfNeeded()
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }
}

extension DatePickerView {
    @discardableResult
    class func showOn(view: UIView, animated: Bool) -> DatePickerView {
        let datePicker = DatePickerView()
        view.addSubview(datePicker)
        datePicker.show()
        return datePicker
    }
}

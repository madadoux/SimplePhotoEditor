//
//  DUViews.swift
//  voiceRecorder
//
//  Created by Mohamed saeed on 3/20/20.
//  Copyright © 2020 Mohamed saeed. All rights reserved.
//

import Foundation
import UIKit

public func getYPositionCenterForHeightAtCell(cell:UITableViewCell!, height:CGFloat) -> CGFloat
{
    
    return cell.textLabel!.center.y - height/2.0
    
}

public func clipValue<T:Comparable>(value : T ,min : T ,max : T) -> T  {
      
      if (value < min){
          return min
      }
      
      if (value > max) {
          return max
      }
      
      return value
}

public func delay(seconds:TimeInterval , block: @escaping ()->Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds)  {
        block()
    }
}
public func mainQueue( block: @escaping ()->Void) {
    DispatchQueue.main.async {
        block()
    }
}

public func DUContainer(frame:CGRect, backgroundColor:UIColor!, child:UIView!) -> UIView {
    
    let parentView:UIView! = UIView(frame:frame)
    
    parentView.backgroundColor = backgroundColor
    
    if child != nil {
        parentView.addSubview(child)
    }
    
    return parentView
}

public func DUColumn(frame:CGRect, children:[UIView]!, distribution:UIStackView.Distribution, alignment:UIStackView.Alignment, spacing:CGFloat) -> UIStackView {
    //Stack View
    let stackView:UIStackView! = UIStackView()
    stackView.frame = frame
    stackView.axis = .vertical
    stackView.distribution = distribution
    stackView.alignment = alignment
    stackView.spacing = spacing
    //iterating over childs
    for child:UIView in children {
        stackView.addArrangedSubview(child)
     }
    //stackView.translatesAutoresizingMaskIntoConstraints = false;
    return stackView
}
public func DURow(frame:CGRect, children:[UIView]!, distribution:UIStackView.Distribution, alignment:UIStackView.Alignment, spacing:CGFloat) -> UIStackView {
    //Stack View
    let stackView:UIStackView! = UIStackView()
    stackView.frame = frame
    stackView.axis = .horizontal
    stackView.distribution = distribution
    stackView.alignment = alignment
    stackView.spacing = spacing
    //iterating over childs
    for child:UIView in children {
        stackView.addArrangedSubview(child)
     }
    //stackView.translatesAutoresizingMaskIntoConstraints = false;
    return stackView
}

public func DUTextButton(frame:CGRect, title:String!, textColor:UIColor!, textFont:UIFont!, onTap: @escaping ()->Void) -> UIButton
{
    let button:UIButton! = UIButton(frame:frame)
    button.setTitle(title, for: .normal)
    button.setTitleColor(textColor, for: .normal)
    button.titleLabel?.font = textFont
    button.addAction(for: .touchUpInside, onTap)
    return  button
}


public func DULabel(frame: CGRect, parent:UIView?, font:UIFont, textColor:UIColor)-> UILabel! {
    let label = UILabel()
    label.frame = frame
    label.font = font
    label.textColor = textColor
    if let parent = parent {
        parent.addSubview(label)
    }
    return label
}

public func DUSegmentControl(frame:CGRect, parent: UIView? , items: [String], onSelect : @escaping (Int,[String])->Void , currentSelectedIndex: Int = 0 , selectedSegmentColor: UIColor = .blue ) -> UISegmentedControl {
    let segmentItems = items
    
    // configuring segment control
    let segmentControl = UISegmentedControl(items: segmentItems)
    segmentControl.selectedSegmentIndex = currentSelectedIndex
    segmentControl.addAction(for: .valueChanged) {
        onSelect(segmentControl.selectedSegmentIndex,items)
    }
    segmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
    segmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)

    if #available(iOS 13.0, *) {
        segmentControl.selectedSegmentTintColor = selectedSegmentColor
    } else {
        // Fallback on earlier versions
        segmentControl.tintColor = selectedSegmentColor
    }
    
    if let parent = parent {
        parent.addSubview(segmentControl)
    }
    segmentControl.frame = frame
    return segmentControl
}


public func DUSwitcher(frame: CGRect , parent : UIView? , onChange:@escaping (Bool)->Void, initValue: Bool = false ) -> UISwitch {
    let switchButton = UISwitch(frame: frame)
    switchButton.isOn = initValue

    switchButton.addAction(for: .valueChanged, {
        let isOn =  switchButton.isOn
        onChange(isOn)
        
    })
    if let parent = parent {
        parent.addSubview(switchButton)
    }
    
    return switchButton
}


public func DUSingleChildScrollView(frame:CGRect,child:UIView,parent:UIView?) -> UIScrollView{
    let scrollView = UIScrollView(frame: frame)
    scrollView.addSubview(child)
    child.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      child.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
      child.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
      child.topAnchor.constraint(equalTo: scrollView.topAnchor),
      child.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
    ])
    
    child.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    if let parent = parent {
        parent.addSubview(scrollView)
    }
    
    return scrollView
}

@objc class ClosureSleeve: NSObject {
    let closure: ()->()

    init (_ closure: @escaping ()->()) {
        self.closure = closure
    }

    @objc func invoke () {
        closure()
    }
}

extension UIControl {
    func addAction(for controlEvents: UIControl.Event = .touchUpInside, _ closure: @escaping ()->()) {
        let sleeve = ClosureSleeve(closure)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
        objc_setAssociatedObject(self, "[\(arc4random())]", sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
}

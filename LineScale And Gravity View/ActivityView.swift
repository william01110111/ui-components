//
//  ActivityIndicator.swift
//  UI Component
//
//  Created by Chandan Brown on 2/10/17.
//  Copyright © 2017 Chandan B. All rights reserved.
//
import UIKit

// Activity indicator view
@IBDesignable
public final class ActivityView: UIView {
       
    // Default minimum display time : 0 milliseconds.
    public static var minimumDisplayTime = 0
    
    // Default display time threshold : 0 milliseconds.
    public static var defaultTimeThreshold = 0
    
    // Default padding : 0.
    public static var defaultPadding: CGFloat = 0
    
    // Default message : nil.
    public static var defaultMessage: String? = nil
    
    // Default color : UIColor.red
    public static var defaultColor: UIColor = .red
    
    // Animation type.
    public var type: ActivityType = ActivityView.defaultType
    
    // Default size : 60x60.
    public static var defaultSize = CGSize(width: 60, height: 60)
    
    // Default type : circleAnimation.
    public static var defaultType: ActivityType = .circleAnimation
    
    // Default font of message : Bold System Font, Size 20.
    public static var defaultMessageFont = UIFont.boldSystemFont(ofSize: 20)
    
    // Default background color : UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    public static var defaultBackgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    
    // Type name of String as argument.
    @available(*, unavailable, message: "This property is reserved for Interface Builder. Use 'type' instead.")
    @IBInspectable var typeName: String {
        get {
            return getTypeName()
        }
        set {
            _setTypeName(newValue)
        }
    }
    
    // Color of view.
    @IBInspectable public var color: UIColor = ActivityView.defaultColor
    
    // Padding of view.
    @IBInspectable public var padding: CGFloat = ActivityView.defaultPadding
    
    // Display Time of view.
    @IBInspectable public var displayTime: Int = ActivityView.minimumDisplayTime
    
    //Size of view.
    @IBInspectable public var size: CGSize = ActivityView.defaultSize
    
    // Current status of animation
    public var animating: Bool { return isAnimating }
    
    // Current status of animation
    public fileprivate(set) var isAnimating: Bool = false
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = .clear
        isHidden = true
    }
    
    // Start animating.
    public final func startAnimating() {
        isHidden = false
        isAnimating = true
        layer.speed = 1
        setUpAnimation()
    }
    
    // Stop animating.
    public final func stopAnimating() {
        isHidden = true
        isAnimating = false
        layer.sublayers?.removeAll()
    }
    
    // The activity indicator view.
    public init(frame: CGRect, type: ActivityType? = nil, color: UIColor? = nil, padding: CGFloat? = nil, displayTime: Int? = nil, size: CGSize? = nil) {
        self.type = type ?? ActivityView.defaultType
        self.color = color ?? ActivityView.defaultColor
        self.padding = padding ?? ActivityView.defaultPadding
        self.displayTime = displayTime ?? ActivityView.minimumDisplayTime
        self.size = size ?? ActivityView.defaultSize
        super.init(frame: frame)
        isHidden = true
    }
    
    // Natural size conforming to view size based on views intrisic properties
    public override var intrinsicContentSize : CGSize {
        return CGSize(width: bounds.width, height: bounds.height)
    }
    
    // MARK: Get Types
    func _setTypeName(_ typeName: String) {
        for item in ActivityType.allTypes {
            if String(describing: item).caseInsensitiveCompare(typeName) == ComparisonResult.orderedSame {
                type = item
                break
            }
        }
    }
    
    //Get name of activity type and convert to string
    func getTypeName() -> String {
        return String(describing: type)
    }
    
    // MARK: Private
    fileprivate final func setUpAnimation() {
        let animation: AnimationDelegate = type.animation()
        var animationRect = UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake(padding, padding, padding, padding))
        let minEdge = min(animationRect.width, animationRect.height)
        
        layer.sublayers = nil
        animationRect.size = CGSize(width: minEdge, height: minEdge)
        animation.setUpAnimation(in: layer, size: animationRect.size, color: color)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
}

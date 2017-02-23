//
//  ActivityData.swift
//  UI Component
//
//  Created by Chandan Brown on 2/10/17.
//  Copyright © 2017 Chandan B. All rights reserved.
//

import UIKit

/// Class packages information used to display UI blocker.

public final class ActivityData {
    // Size of view
    let size: CGSize
    
    // Color of activity view
    let color: UIColor
    
    // Padding of activity view
    let padding: CGFloat
    
    // Message displayed under view
    let message: String?
    
    // Animation type
    let type: ActivityType
    
    // Font of message
    let messageFont: UIFont
    
    // Minimum display time
    let minimumDisplayTime: Int
    
    // Background color
    let backgroundColor: UIColor
    
    // Display time threshold
    let displayTimeThreshold: Int
    
    
    // The "information package" used to display
    public init(size: CGSize? = nil,
                message: String? = nil,
                messageFont: UIFont? = nil,
                type: ActivityType? = nil,
                color: UIColor? = nil,
                padding: CGFloat? = nil,
                displayTimeThreshold: Int? = nil,
                minimumDisplayTime: Int? = nil,
                backgroundColor: UIColor? = nil) {
        
        self.type    = type ?? ActivityView.defaultType
        self.size    = size ?? ActivityView.defaultSize
        self.color   = color ?? ActivityView.defaultColor
        self.padding = padding ?? ActivityView.defaultPadding
        self.message = message ?? ActivityView.defaultMessage
        self.messageFont     = messageFont ?? ActivityView.defaultMessageFont
        self.backgroundColor = backgroundColor ?? ActivityView.defaultBackgroundColor
        self.minimumDisplayTime   = minimumDisplayTime ?? ActivityView.minimumDisplayTime
        self.displayTimeThreshold = displayTimeThreshold ?? ActivityView.defaultTimeThreshold
    }
}

/// Presenter that displays NVActivityIndicatorView as UI blocker.
public final class ActivityPresenter {
    fileprivate var showTimer: Timer?
    fileprivate var hideTimer: Timer?
    fileprivate var isStopAnimatingCalled = false
    fileprivate let restorationIdentifier = "ActivityViewContainer"
    
    fileprivate var activitySize = ActivityView.defaultSize
    
    fileprivate let activityLabel: UILabel = {
        let activityLabel = UILabel()
        activityLabel.textAlignment = .center
        activityLabel.numberOfLines = 0
        return activityLabel
    }()
    
    /// Shared instance of `ActivityPresenter`.
    public static let sharedInstance = ActivityPresenter()
    
    fileprivate init() { }
    
    // MARK: - Public interface
    
    // Information package used to display
    public final func startAnimating(_ data: ActivityData) {
        guard showTimer == nil else { return }
        isStopAnimatingCalled = false
        showTimer = scheduledTimer(data.displayTimeThreshold, selector: #selector(showTimerFired(_:)), data: data)
    }
    

    // Remove
    public final func stopAnimating() {
        isStopAnimatingCalled = true
        guard hideTimer == nil else { return }
        hide()
    }
    
    // Set message displayed under activity indicator view.
    public final func setMessage(_ message: String?) {
        activityLabel.text = message
        
        guard let message = message, !message.isEmpty else {
            activityLabel.frame.size = CGSize.zero;
            return
        }
        let screenSize = UIScreen.main.bounds
        
        activityLabel.frame.size = NSString(string: message).boundingRect(
            with: CGSize(width: screenSize.width - 16.0, height: CGFloat.greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [NSFontAttributeName: activityLabel.font],
            context: nil).size
        
        activityLabel.center = CGPoint(
            x: screenSize.width / 2.0,
            y: (screenSize.height / 2.0) + activitySize.height + (activityLabel.frame.height / 2) + 8.0)
    }
    
    // MARK: - Timer events
    @objc fileprivate func showTimerFired(_ timer: Timer) {
        guard let activityData = timer.userInfo as? ActivityData else { return }
        show(with: activityData)
    }
    
    @objc fileprivate func hideTimerFired(_ timer: Timer) {
        hideTimer?.invalidate()
        hideTimer = nil
        if isStopAnimatingCalled {
            hide()
        }
    }
    
    // MARK: - Helpers
    fileprivate func show(with activityData: ActivityData) {
        let activityContainer: UIView = UIView(frame: UIScreen.main.bounds)
        
        activityContainer.backgroundColor = activityData.backgroundColor
        activityContainer.restorationIdentifier = restorationIdentifier
        
        activitySize = activityData.size
        
        let activityIndicatorView = ActivityView(
            frame: CGRect(x: 0, y: 0, width: activitySize.width, height: activitySize.height),
            type: activityData.type,
            color: activityData.color,
            padding: activityData.padding)
        
        activityIndicatorView.center = activityContainer.center
        activityIndicatorView.startAnimating()
        activityContainer.addSubview(activityIndicatorView)
        
        activityLabel.font = activityData.messageFont
        activityLabel.textColor = activityIndicatorView.color
        setMessage(activityData.message)
        activityContainer.addSubview(activityLabel)
        
        hideTimer = scheduledTimer(activityData.minimumDisplayTime, selector: #selector(hideTimerFired(_:)), data: nil)
        guard let keyWindow = UIApplication.shared.keyWindow else { return }
        keyWindow.addSubview(activityContainer)
    }
    
    fileprivate func hide() {
        guard let keyWindow = UIApplication.shared.keyWindow else { return }
        
        for item in keyWindow.subviews
            where item.restorationIdentifier == restorationIdentifier {
                item.removeFromSuperview()
        }
        showTimer?.invalidate()
        showTimer = nil
    }
    
    fileprivate func scheduledTimer(_ timeInterval: Int, selector: Selector, data: ActivityData?) -> Timer {
        return Timer.scheduledTimer(timeInterval: Double(timeInterval) / 1000,
                                    target: self,
                                    selector: selector,
                                    userInfo: data,
                                    repeats: false)
    }
}

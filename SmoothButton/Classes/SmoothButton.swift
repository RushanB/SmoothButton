//
//  Based on LGButton by Lorenzo Greco (https://github.com/loregr/LGButton)
//
//  SmoothButton.swift
//  SmoothButton
//
//  Created by Mattew Weldon & Rushan Benazir on 2018-06-24.
//  Copyright © 2018 Smooth Commerce. All rights reserved.
//

import UIKit
import QuartzCore

fileprivate let defaultBackgroundColor = UIColor(red: 252.0, green: 182.0, blue: 90.0, alpha: 1.0)
fileprivate let defaultCornerRadius: CGFloat = 6.0
fileprivate let defaultHasFullyRoundedCorners: Bool = false
fileprivate let defaultBorderColor = UIColor.clear
fileprivate let defaultBorderWidth: CGFloat = 0.0

fileprivate let defaultTitleColor = UIColor.black
fileprivate let defaultTitleFont = UIFont(name: "Futura-Bold", size: 20.0)
fileprivate let defaultTitleString: String = "Button"
fileprivate let defaultLoadingString: String = "Loading"

fileprivate let defaultShadowOffset = CGSize(width: 0.0, height: 5.0)
fileprivate let defaultShadowRadius: CGFloat = 5.0
fileprivate let defaultShadowOpacity: Float = 0.5
fileprivate let defaultShadowColor = UIColor.black
fileprivate let defaultLoadingSpinnerColor = UIColor.black
fileprivate let defaultAnimationDuration: Double = 0.3
fileprivate let defaultIsEnabledWhileLoading: Bool = false


@IBDesignable
public class SmoothButton: UIControl {
    
    enum TouchAlphaValues : CGFloat {
        case touched = 0.7
        case untouched = 1.0
    }
    
    let touchDisableRadius : CGFloat = 100.0
    
    let availableFontIcons = ["fa", "io", "oc", "ic", "ma", "ti", "mi"]
    
    var gradient : CAGradientLayer?

    override public var isEnabled:Bool{
        didSet{
            if(oldValue != isEnabled){
                self.updateEnabledStyles()
            }
        }
    }
    
    static func slowAnimationsConstant() -> Float{
        #if TARGET_IPHONE_SIMULATOR
        return UIAnimationDragCoefficient();
        #else
        return 1.0;
        #endif
    }
    
    fileprivate var rootView : UIView!
    @IBOutlet fileprivate weak var titleLbl: UILabel!
    @IBOutlet fileprivate weak var mainStackView: UIStackView!
    
    @IBOutlet fileprivate weak var bgContentView: UIView!
    @IBOutlet fileprivate weak var leftIcon: UILabel!
    @IBOutlet fileprivate weak var leftImage: UIImageView!
    @IBOutlet fileprivate weak var rightIcon: UILabel!
    @IBOutlet fileprivate weak var rightImage: UIImageView!
    
    @IBOutlet fileprivate weak var trailingMainConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var leadingMainConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var bottomMainConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var topMainConstraint: NSLayoutConstraint!
    
    @IBOutlet fileprivate weak var leftImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var leftImageWidthConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var rightImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var rightImageWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet fileprivate weak var loadingStackView: UIStackView!
    @IBOutlet fileprivate weak var loadingSpinner: UIActivityIndicatorView!
    @IBOutlet fileprivate weak var loadingLabel: UILabel!
    @IBOutlet fileprivate var trailingLoadingConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate var leadingLoadingConstraint: NSLayoutConstraint!
    
    
    public var isLoading = false {
        didSet {
            showLoadingView()
        }
    }
    
    var isEnabledWhileLoading: Bool = defaultIsEnabledWhileLoading {
        didSet{
            setupView()
        }
    }
    
    public var attributedString: NSAttributedString? {
        set {
            titleLbl.attributedText = newValue
        }
        get {
            return titleLbl.attributedText
        }
    }
    
    // MARK: - Inspectable properties
    // MARK:
    
    @IBInspectable public var bgColor: UIColor = defaultBackgroundColor {
        didSet{
            setupView()
        }
    }
    
    @IBInspectable public var showTouchFeedback: Bool = true
    
    @IBInspectable public var gradientStartColor: UIColor? = nil {
        didSet{
            setupView()
        }
    }
    
    @IBInspectable public var gradientEndColor: UIColor? = nil {
        didSet{
            setupView()
        }
    }
    
    @IBInspectable public var gradientHorizontal: Bool = false {
        didSet{
            if gradient != nil {
                gradient?.removeFromSuperlayer()
                gradient = nil
                setupView()
            }
        }
    }
    
    @IBInspectable public var gradientRotation: CGFloat = 0 {
        didSet{
            if gradient != nil {
                gradient?.removeFromSuperlayer()
                gradient = nil
                setupView()
            }
        }
    }
    
    @IBInspectable public var cornerRadius: CGFloat = defaultCornerRadius {
        didSet{
            setupView()
        }
    }
    
    @IBInspectable public var fullyRoundedCorners: Bool = defaultHasFullyRoundedCorners {
        didSet{
            setupBorderAndCorners()
        }
    }
    
    @IBInspectable public var borderColor: UIColor = defaultBorderColor {
        didSet{
            setupView()
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat = defaultBorderWidth {
        didSet{
            setupView()
        }
    }
    
    @IBInspectable public var titleColor: UIColor = defaultTitleColor {
        didSet{
            setupView()
        }
    }
    
    @IBInspectable public var titleString: String = defaultTitleString {
        didSet{
            setupView()
            
        }
    }
    
    @IBInspectable public var titleFont: UIFont? = defaultTitleFont {
        didSet{
            setupView()
        }
    }
    
    
    @IBInspectable public var titleFontName: String? {
        didSet{
            setupView()
        }
    }
    
    @IBInspectable public var titleFontSize: CGFloat = 14.0 {
        didSet{
            setupView()
        }
    }
    
    @IBInspectable public var verticalOrientation: Bool = false {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable public var leftIconString: String = "" {
        didSet{
            setupView()
        }
    }
    
    @IBInspectable public var leftIconFontName: String = " " {
        didSet{
            setupView()
        }
    }
    
    @IBInspectable public var leftIconFontSize: CGFloat = 14.0 {
        didSet{
            setupView()
        }
    }
    
    @IBInspectable public var leftIconColor: UIColor = UIColor.white {
        didSet{
            setupView()
        }
    }
    
    @IBInspectable public var leftImageSrc: UIImage? = nil {
        didSet{
            setupView()
        }
    }
    
    @IBInspectable public var leftImageWidth: CGFloat = 20 {
        didSet{
            setupView()
        }
    }
    
    @IBInspectable public var leftImageHeight: CGFloat = 20 {
        didSet{
            setupView()
        }
    }
    
    @IBInspectable public var leftImageColor: UIColor? = nil {
        didSet{
            setupView()
        }
    }
    
    @IBInspectable public var rightIconString: String = "" {
        didSet{
            setupView()
        }
    }
    
    @IBInspectable public var rightIconFontName: String = " " {
        didSet{
            setupView()
        }
    }
    
    @IBInspectable public var rightIconFontSize: CGFloat = 14.0 {
        didSet{
            setupView()
        }
    }
    
    @IBInspectable public var rightIconColor: UIColor = UIColor.white {
        didSet{
            setupView()
        }
    }
    
    @IBInspectable public var rightImageSrc: UIImage? = nil {
        didSet{
            setupView()
        }
    }
    
    @IBInspectable public var rightImageWidth: CGFloat = 20 {
        didSet{
            setupView()
        }
    }
    
    @IBInspectable public var rightImageHeight: CGFloat = 20 {
        didSet{
            setupView()
        }
    }
    
    @IBInspectable public var rightImageColor: UIColor? = nil {
        didSet{
            setupView()
        }
    }
    
    @IBInspectable public var spacingTitleIcon: CGFloat = 16.0 {
        didSet{
            setupView()
        }
    }
    
    @IBInspectable public var spacingTop: CGFloat = 8.0 {
        didSet{
            setupView()
        }
    }
    
    @IBInspectable public var spacingBottom: CGFloat = 8.0 {
        didSet{
            setupView()
        }
    }
    
    @IBInspectable public var spacingLeading: CGFloat = 16.0 {
        didSet{
            setupView()
        }
    }
    
    @IBInspectable public var spacingTrailing: CGFloat = 16.0 {
        didSet{
            setupView()
        }
    }
    
    @IBInspectable public var shadowOffset: CGSize =  defaultShadowOffset {
        didSet{
            setupView()
        }
    }
    
    @IBInspectable public var shadowRadius: CGFloat = defaultShadowRadius {
        didSet{
            setupView()
        }
    }
    
    @IBInspectable public var shadowOpacity: Float = defaultShadowOpacity {
        didSet{
            setupView()
        }
    }
    
    @IBInspectable public var shadowColor: UIColor = defaultShadowColor {
        didSet{
            setupView()
        }
    }
    
    @IBInspectable public var loadingSpinnerColor: UIColor = defaultLoadingSpinnerColor {
        didSet{
            setupView()
        }
    }
    
    @IBInspectable public var loadingTitleColor: UIColor = defaultTitleColor.withAlphaComponent(0.8) {
        didSet{
            setupView()
        }
    }
    
    @IBInspectable public var loadingString: String = defaultLoadingString {
        didSet{
            setupView()
        }
    }
    
    
    @IBInspectable public var loadingFont: UIFont? = defaultTitleFont{
        didSet{
            setupView()
        }
    }
    
    @IBInspectable public var loadingFontName: String? = nil{
        didSet{
            setupView()
        }
    }
    
    @IBInspectable public var loadingFontSize: CGFloat = 14.0 {
        didSet{
            setupView()
        }
    }
    
    // MARK: - Overrides
    // MARK:
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        setupView()
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        xibSetup()
        setupView()
    }
    
    override public func layoutSubviews() {
        if gradient != nil {
            gradient?.removeFromSuperlayer()
            gradient = nil
            setupGradientBackground()
        }
        setupBorderAndCorners()
    }
    
    private func updateEnabledStyles() {
        self.layer.removeAllAnimations()
        
        let enabled = self.isEnabled
        
        let shadowOpacityToValue:Float = enabled ? self.shadowOpacity : 0.0
        let shadowOpacityFromValue:Float = enabled ? 0.0 : self.shadowOpacity
        
        let opacityToValue:Float = enabled ? 1.0 : 0.5
        let opacityFromValue:Float  = enabled ?  0.5 : 1
        
        let shadowRadiusFromValue: CGFloat = enabled ?   0.0 : self.shadowRadius
        let shadowRadiusToValue:CGFloat = enabled ? self.shadowRadius : 0.0
        
        let duration:Double = Double(0.3 * SmoothButton.slowAnimationsConstant())
        
        
        let shadowAnimation = CABasicAnimation(keyPath: "shadowOpacity")
        shadowAnimation.fillMode = kCAFillModeForwards
        shadowAnimation.isRemovedOnCompletion = false
        shadowAnimation.fromValue = shadowOpacityFromValue
        shadowAnimation.toValue = shadowOpacityToValue
        shadowAnimation.duration = duration
        
        let shadowRadiusAnimation = CABasicAnimation(keyPath: "shadowRadius")
        shadowRadiusAnimation.fillMode = kCAFillModeForwards
        shadowRadiusAnimation.isRemovedOnCompletion = false
        shadowRadiusAnimation.fromValue = shadowRadiusFromValue
        shadowRadiusAnimation.toValue = shadowRadiusToValue
        shadowRadiusAnimation.duration = duration
        
        let alphaAnimation = CABasicAnimation(keyPath: "opacity")
        alphaAnimation.fillMode = kCAFillModeForwards
        alphaAnimation.isRemovedOnCompletion = false
        alphaAnimation.fromValue = opacityFromValue
        alphaAnimation.toValue = opacityToValue
        alphaAnimation.duration = duration
        
        self.layer.shadowOpacity = shadowOpacityToValue
        self.layer.shadowRadius = shadowRadiusToValue
        self.layer.opacity = opacityToValue
        self.layer.add(shadowAnimation, forKey: "shadowOpacity")
        self.layer.add(shadowRadiusAnimation, forKey: "shadowRadius")
        self.layer.add(alphaAnimation, forKey: "opacity")
    }
    
    override public var intrinsicContentSize: CGSize {
        return CGSize(width: 10, height: 10)
    }
    
    public func setAction(target:Any, action: Selector) {
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: target, action: action)
        tapGesture.numberOfTapsRequired = 1
        addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Internal functions
    // MARK:
    
    // Setup the view appearance
    fileprivate func setupView(){
        bgContentView.clipsToBounds = true
        layer.masksToBounds = false
        setIconOrientation()
        setupBackgroundColor()
        setupGradientBackground()
        setupBorderAndCorners()
        setupTitle()
        setupLeftIcon()
        setupRightIcon()
        setupLeftImage()
        setupRightImage()
        setupSpacings()
        setupShadow()
        setupLoadingView()
    }
    
    fileprivate func setIconOrientation() {
        if verticalOrientation {
            mainStackView.axis = .vertical
        }else{
            mainStackView.axis = .horizontal
        }
    }
    
    fileprivate func setupBackgroundColor() {
        bgContentView.backgroundColor = bgColor
    }
    
    fileprivate func setupGradientBackground() {
        if gradientStartColor != nil && gradientEndColor != nil && gradient == nil{
            gradient = CAGradientLayer()
            gradient!.frame.size = frame.size
            gradient!.colors = [gradientStartColor!.cgColor, gradientEndColor!.cgColor]
            
            var rotation:CGFloat!
            if gradientRotation >= 0 {
                rotation = min(gradientRotation, CGFloat(360.0))
            } else {
                rotation = max(gradientRotation, CGFloat(-360.0))
            }
            var xAngle:Float = Float(rotation/360)
            if (gradientHorizontal) {
                xAngle = 0.25
            }
            let a = pow(sinf((2*Float(Double.pi)*((xAngle+0.75)/2))),2)
            let b = pow(sinf((2*Float(Double.pi)*((xAngle+0.0)/2))),2)
            let c = pow(sinf((2*Float(Double.pi)*((xAngle+0.25)/2))),2)
            let d = pow(sinf((2*Float(Double.pi)*((xAngle+0.5)/2))),2)
            gradient!.startPoint = CGPoint(x: CGFloat(a), y: CGFloat(b))
            gradient!.endPoint = CGPoint(x: CGFloat(c), y: CGFloat(d))
            
            bgContentView.layer.addSublayer(gradient!)
        }
    }
    
    fileprivate func setupBorderAndCorners() {
        if fullyRoundedCorners {
            bgContentView.layer.cornerRadius = frame.size.height/2
            layer.cornerRadius = frame.size.height/2
        }else{
            bgContentView.layer.cornerRadius = cornerRadius
            layer.cornerRadius = cornerRadius
        }
        bgContentView.layer.borderColor = borderColor.cgColor
        bgContentView.layer.borderWidth = borderWidth
    }
    
    fileprivate func setupTitle() {
        titleLbl.isHidden = titleString.isEmpty
        titleLbl.text = titleString
        titleLbl.textColor = titleColor
        if titleFontName != nil {
            titleLbl.font = UIFont.init(name:titleFontName! , size:titleFontSize)
        }else if let font = titleFont{
            titleLbl.font = font
        }
    }
    
    fileprivate func setupLeftIcon(){
        setupIcon(icon: leftIcon,
                  fontName: leftIconFontName,
                  iconName: leftIconString,
                  fontSize: leftIconFontSize,
                  color: leftIconColor)
    }
    
    fileprivate func setupRightIcon(){
        setupIcon(icon: rightIcon,
                  fontName: rightIconFontName,
                  iconName: rightIconString,
                  fontSize: rightIconFontSize,
                  color: rightIconColor)
    }
    
    fileprivate func setupLeftImage(){
        setupImage(imageView: leftImage,
                   image: leftImageSrc,
                   color: leftImageColor,
                   widthConstraint: leftImageWidthConstraint,
                   heightConstraint: leftImageHeightConstraint,
                   widthValue: leftImageWidth,
                   heightValue: leftImageHeight)
        leftIcon.isHidden =  (leftImageSrc != nil || !availableFontIcons.contains(leftIconFontName))
    }
    
    fileprivate func setupRightImage(){
        rightIcon.isHidden =  rightImageSrc != nil
        setupImage(imageView: rightImage,
                   image: rightImageSrc,
                   color: rightImageColor,
                   widthConstraint: rightImageWidthConstraint,
                   heightConstraint: rightImageHeightConstraint,
                   widthValue: rightImageWidth,
                   heightValue: rightImageHeight)
        rightIcon.isHidden =  (rightImageSrc != nil || !availableFontIcons.contains(rightIconFontName))
    }
    
    fileprivate func setupSpacings(){
        mainStackView.spacing = spacingTitleIcon
        topMainConstraint.constant = spacingTop
        bottomMainConstraint.constant = spacingBottom
        leadingMainConstraint.constant = spacingLeading
        trailingMainConstraint.constant = spacingTrailing
        setupBorderAndCorners()
    }
    
    fileprivate func setupShadow(){
        
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = isEnabled ? shadowOpacity : 0.0
        layer.shadowColor = shadowColor.cgColor
        
    }
    
    fileprivate func setupLoadingView(){
        loadingSpinner.activityIndicatorViewStyle = .whiteLarge
        loadingLabel.isHidden = loadingString.isEmpty
        loadingLabel.text = loadingString
        loadingLabel.textColor = loadingTitleColor
        if let fontString = loadingFontName, fontString != ""  {
            loadingLabel.font = UIFont.init(name:fontString , size:titleFontSize)
        }else if let font = loadingFont{
            loadingLabel.font = font
        }
        loadingSpinner.color = loadingSpinnerColor
        setupBorderAndCorners()
    }
    
    fileprivate func setupIcon(icon:UILabel, fontName:String, iconName:String, fontSize:CGFloat, color:UIColor){
        icon.isHidden = !availableFontIcons.contains(fontName)
        if  !icon.isHidden {
            icon.textColor = color
            switch fontName {
            case "fa":
                icon.font = UIFont.icon(from: .FontAwesome, ofSize: fontSize)
                icon.text = String.fontAwesomeIcon(iconName)
                break;
            case "io":
                icon.font = UIFont.icon(from: .Ionicon, ofSize: fontSize)
                icon.text = String.fontIonIcon(iconName)
                break;
            case "oc":
                icon.font = UIFont.icon(from: .Octicon, ofSize: fontSize)
                icon.text = String.fontOcticon(iconName)
                break;
            case "ic":
                icon.font = UIFont.icon(from: .Iconic, ofSize: fontSize)
                icon.text = String.fontIconicIcon(iconName)
                break;
            case "ma":
                icon.font = UIFont.icon(from: .MaterialIcon, ofSize: fontSize)
                icon.text = String.fontMaterialIcon(iconName.replacingOccurrences(of: "-", with: "."))
                break;
            case "ti":
                icon.font = UIFont.icon(from: .Themify, ofSize: fontSize)
                icon.text = String.fontThemifyIcon(iconName.replacingOccurrences(of: "-", with: "."))
                break;
            case "mi":
                icon.font = UIFont.icon(from: .MapIcon, ofSize: fontSize)
                icon.text = String.fontMapIcon(iconName.replacingOccurrences(of: "-", with: "."))
                break;
            default:
                break;
            }
        }
        setupBorderAndCorners()
    }
    
    fileprivate func setupImage(imageView:UIImageView, image:UIImage?, color:UIColor?, widthConstraint:NSLayoutConstraint, heightConstraint:NSLayoutConstraint, widthValue:CGFloat, heightValue:CGFloat){
        imageView.isHidden = image == nil
        if image != nil {
            if color != nil {
                imageView.image = image?.withRenderingMode(.alwaysTemplate)
                imageView.tintColor = color
            }else{
                image?.withRenderingMode(.alwaysOriginal)
                imageView.image = image
            }
            widthConstraint.constant = widthValue
            heightConstraint.constant = heightValue
        }
        setupBorderAndCorners()
    }
    
    fileprivate func showLoadingView() {
        
        leadingLoadingConstraint.isActive = isLoading
        trailingLoadingConstraint.isActive = isLoading
        mainStackView.isHidden = isLoading
        loadingStackView.isHidden = !isLoading
        isUserInteractionEnabled = isEnabledWhileLoading || !isLoading
        
        
        let animation =      CABasicAnimation(keyPath: "opacity")
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        animation.toValue = 0.5
        animation.fromValue = 1.0
        animation.autoreverses = true
        animation.repeatCount = .infinity
        animation.repeatDuration = .infinity
        animation.duration = Double(1.0 * SmoothButton.slowAnimationsConstant())
        self.loadingStackView.layer.add(animation, forKey: "opacity")
    }
    
    // MARK: - Xib file
    // MARK:
    fileprivate func xibSetup() {
        rootView = loadViewFromNib()
        rootView.frame = bounds
        rootView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(rootView)
        leadingLoadingConstraint.isActive = false
        trailingLoadingConstraint.isActive = false
    }
    
    fileprivate func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "SmoothButton", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    // MARK: - Touches
    // MARK:
    
    var touchAlpha : TouchAlphaValues = .untouched {
        didSet {
            updateTouchAlpha()
        }
    }
    
    var pressed : Bool = false {
        didSet {
            if !showTouchFeedback {
                return
            }
            
            touchAlpha = (pressed) ? .touched : .untouched
        }
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        pressed = true
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?){
        let shouldSendActions = pressed
        pressed = false
        if shouldSendActions{
            sendActions(for: .allEvents)
            sendActions(for: .touchUpInside)
        }
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?){
        if let touchLoc = touches.first?.location(in: self){
            if (touchLoc.x < -touchDisableRadius ||
                touchLoc.y < -touchDisableRadius ||
                touchLoc.x > self.bounds.size.width + touchDisableRadius ||
                touchLoc.y > self.bounds.size.height + touchDisableRadius){
                pressed = false
            }
            else if self.touchAlpha == .untouched {
                pressed = true
            }
        }
    }
    
    override public func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        pressed = false
    }
    
    func updateTouchAlpha() {
        if self.alpha != self.touchAlpha.rawValue {
            UIView.animate(withDuration: defaultAnimationDuration) {
                self.alpha = self.touchAlpha.rawValue
            }
        }
    }
}

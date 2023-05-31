//
//  OnBoardingView.swift
//  iPromise
//
//  Created by Apple on 24/03/23.
//

import UIKit

//MARK: - overlay view

enum arrowPosition : String {
    case top = "top"
    case bottom = "bottom"
    case left = "left"
}

class OverlayView: UIView {

    let title: String
    weak var anchorView: UIView?
    var onTap: (() -> Void)?
    var onSkipTap: (() -> Void)?
    var arrowImg : UIImage?
    var position : arrowPosition?
    var promiseImg : UIImage?
    var isFail : Bool?

    init(title: String, anchorView: UIView?, arrowImg : UIImage?, position : arrowPosition?, promiseImg : UIImage? = nil, isFail : Bool? = false) {
        self.title = title
        super.init(frame: .zero)
        self.anchorView = anchorView
        self.arrowImg = arrowImg
        self.position = position
        self.promiseImg = promiseImg
        self.isFail = isFail
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }


    func showOverlay() {
        UIView.animate(withDuration: 0.6) {
            self.alpha = 1
        }
    }

    func hideOverlay(_ completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.6, animations: {
            self.alpha = 0
        }, completion: completion)
    }
    
    lazy var titleLabel: UILabel = {
            let titleLabel = UILabel()
        titleLabel.font = UIFont.customFont(font: .regular, size: 14)
            titleLabel.text = title
        titleLabel.textColor = color.blackColor()
            titleLabel.isHidden = title.isEmpty
            titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .justified
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            return titleLabel
        }()

        lazy var containerView: UIView = {
            let view = UIView()
            view.backgroundColor = color.whiteColor()
            view.layer.cornerRadius = 10
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()

        lazy var backgroundView: UIView = {
            let view = UIView()
            view.backgroundColor = color.blackColor()
            view.alpha = 0.5
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()

        lazy var arrowImage: UIImageView = {
            let imageView = UIImageView(image: arrowImg)
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = color.whiteColor()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalToConstant: 30),
                imageView.heightAnchor.constraint(equalToConstant: 10),
            ])
            return imageView
        }()
    
    lazy var promiseImage: UIImageView = {
        let imageView = UIImageView(image: promiseImg)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 150),
            imageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width-20),
        ])
        return imageView
    }()
    
    var buttonOk : UIButton = {
        let button = UIButton()
        button.setTitle("    Ok!", for: .normal)
        button.setImage(image.line(), for: .normal)
        button.setTitleColor(color.primaryColor(), for: .normal)
        button.titleLabel?.font = UIFont.customFont(font: .medium, size: 16)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 60).isActive = true
        return button
    }()
    
    var buttonSkip : UIButton = {
        let button = UIButton()
        button.setTitle("Skip onbording", for: .normal)
        button.titleLabel?.font = UIFont.customFont(font: .medium, size: 16)
        button.setTitleColor(color.whiteColor(), for: .normal)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    var stackview : UIStackView = {
        let stackView   = UIStackView()
        stackView.axis  = NSLayoutConstraint.Axis.horizontal
        stackView.distribution  = UIStackView.Distribution.fillProportionally
        stackView.alignment = UIStackView.Alignment.fill
        stackView.spacing   = 10.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(top: 10, left: 10, bottom: 10, right: 10)

        return stackView
    }()
    
    
        private func setupViews() {
            alpha = 0
            
            guard let anchorView = self.anchorView,
                    let parentView = anchorView.superview,
                    let cloneView  = anchorView.snapshotView(afterScreenUpdates: false) else { return }

            cloneView.frame = anchorView.frame

            
            stackview.addArrangedSubview(titleLabel)
            stackview.addArrangedSubview(buttonOk)
            
            containerView.addSubview(stackview)
     
            let translatedOrigin = parentView.convert(anchorView.frame.origin, to: self)
            cloneView.frame = CGRect(origin: translatedOrigin, size: anchorView.bounds.size)

            addSubview(backgroundView)
            addSubview(cloneView)
            addSubview(arrowImage)
            addSubview(containerView)
            addSubview(buttonSkip)
            addSubview(promiseImage)

            var constraints = [
                backgroundView.topAnchor.constraint(equalTo: topAnchor),
                backgroundView.leftAnchor.constraint(equalTo: leftAnchor),
                backgroundView.rightAnchor.constraint(equalTo: rightAnchor),
                backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
                stackview.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 12),
                stackview.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
                stackview.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -12),
                stackview.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
                buttonSkip.rightAnchor.constraint(equalTo: containerView.rightAnchor),
              ]
            
            if promiseImg  != nil {
                cloneView.isHidden = true
                constraints.append(contentsOf: [
                    containerView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
                    containerView.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
                    arrowImage.centerXAnchor.constraint(equalTo: promiseImage.centerXAnchor),
                ])
        
                    constraints.append(contentsOf: [
                        containerView.bottomAnchor.constraint(equalTo: cloneView.bottomAnchor, constant: -20),
                        arrowImage.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -1),
                        buttonSkip.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: -10)
                    ])
                
                constraints.append(contentsOf: [
                    promiseImage.leftAnchor.constraint(equalTo: backgroundView.leftAnchor, constant: !(isFail ?? false) ? 20 : -20),
                    promiseImage.rightAnchor.constraint(equalTo: backgroundView.rightAnchor, constant: !(isFail ?? false) ? 20 : -20),
                    promiseImage.topAnchor.constraint(equalTo: cloneView.bottomAnchor, constant: 0)
                ])
                
                
            }
            else{
                promiseImage.isHidden = true
                if position != .left{
                    constraints.append(contentsOf: [
                        containerView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
                        containerView.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
                        arrowImage.centerXAnchor.constraint(equalTo: cloneView.centerXAnchor),
                    ])
                    if position == .top
                    {
                        constraints.append(contentsOf: [
                            containerView.topAnchor.constraint(equalTo: cloneView.bottomAnchor, constant: 20),
                            arrowImage.topAnchor.constraint(equalTo: containerView.topAnchor, constant: -8),
                            buttonSkip.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 10)
                        ])
                    }
                    else{
                        constraints.append(contentsOf: [
                            containerView.bottomAnchor.constraint(equalTo: cloneView.topAnchor, constant: -20),
                            arrowImage.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -1),
                            buttonSkip.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: -10)
                        ])
                    }
                }
                else{
                    constraints.append(contentsOf: [
                        containerView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
                        containerView.rightAnchor.constraint(equalTo: cloneView.leftAnchor, constant: -20),
                        arrowImage.centerYAnchor.constraint(equalTo: cloneView.centerYAnchor),
                        containerView.centerYAnchor.constraint(equalTo: cloneView.centerYAnchor),
                        arrowImage.leftAnchor.constraint(equalTo: containerView.rightAnchor, constant: -12),
                        buttonSkip.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: -10)
                    ])
                }
            }
            
   
          
        
            
            NSLayoutConstraint.activate(constraints)
            buttonOk.addTarget(self, action: #selector(onTapGesture(_:)), for: .touchUpInside)
            buttonSkip.addTarget(self, action: #selector(onSkipTap(_:)), for: .touchUpInside)
        }
    @objc func onTapGesture(_ sender: Any) {
        onTap?()
    }
    @objc func onSkipTap(_ sender: Any) {
        onSkipTap?()
    }
}

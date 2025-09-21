// -------------------------------------------------------------
// Core/Utils/Animations/ProgressRingView.swift – UIKitRepresentable
// Dairesel progress (animasyonlu) + glow at 100%
// -------------------------------------------------------------
import SwiftUI
import UIKit

final class ProgressRingUIView: UIView {
    private let track = CAShapeLayer()
    private let ring = CAShapeLayer()
    private let glow = CALayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = false
        layer.addSublayer(track)
        layer.addSublayer(ring)
        layer.addSublayer(glow)
    }
    required init?(coder: NSCoder) { fatalError() }

    override func layoutSubviews() {
        super.layoutSubviews()
        let lineWidth: CGFloat = 12
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height)/2 - lineWidth
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: -.pi/2, endAngle: 1.5 * .pi, clockwise: true)

        for l in [track, ring] { l.frame = bounds; l.path = path.cgPath; l.lineWidth = lineWidth; l.fillColor = UIColor.clear.cgColor; l.lineCap = .round }
        track.strokeColor = UIColor.systemGray5.cgColor
        ring.strokeColor = tintColor.cgColor

        glow.frame = bounds
        glow.shadowColor = tintColor.cgColor
        glow.shadowOpacity = 0
        glow.shadowRadius = 20
        glow.shadowOffset = .zero
    }

    func setProgress(_ value: CGFloat, animated: Bool) {
        let clamped = max(0, min(1, value))
        let from = (ring.presentation() ?? ring).strokeEnd
        ring.strokeEnd = clamped
        if animated {
            let anim = CABasicAnimation(keyPath: "strokeEnd")
            anim.fromValue = from
            anim.toValue = clamped
            anim.duration = 0.8
            anim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            ring.add(anim, forKey: "stroke")
        }
        // Glow at 100%
        let targetOpacity: Float = clamped >= 1 ? 1 : 0
        let glowAnim = CABasicAnimation(keyPath: "shadowOpacity")
        glowAnim.fromValue = glow.shadowOpacity
        glowAnim.toValue = targetOpacity
        glowAnim.duration = 0.6
        glow.add(glowAnim, forKey: "glow")
        glow.shadowOpacity = targetOpacity
    }
}

struct ProgressRingView: UIViewRepresentable {
    var progress: CGFloat
    func makeUIView(context: Context) -> ProgressRingUIView { ProgressRingUIView() }
    func updateUIView(_ uiView: ProgressRingUIView, context: Context) {
        uiView.tintColor = UIColor(Theme.brandOrange)
        uiView.setProgress(progress, animated: true)
    }
}

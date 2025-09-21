// -------------------------------------------------------------
// Core/Utils/Animations/BarChartUIKitView.swift – weekly CA bars
// -------------------------------------------------------------
import SwiftUI
import UIKit

final class BarChartView: UIView {
    var values: [CGFloat] = [] { didSet { setNeedsLayout() } }
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        guard !values.isEmpty else { return }
        let maxV = max(1, values.max() ?? 1)
        let barWidth = bounds.width / CGFloat(values.count) * 0.6
        let gap = (bounds.width / CGFloat(values.count)) * 0.4
        for (i, v) in values.enumerated() {
            let h = (v / maxV) * bounds.height
            let bar = CALayer()
            bar.backgroundColor = tintColor.cgColor
            bar.frame = CGRect(x: CGFloat(i) * (barWidth + gap) + gap/2, y: bounds.height - h, width: barWidth, height: h)
            bar.cornerRadius = 6
            layer.addSublayer(bar)
            let anim = CABasicAnimation(keyPath: "bounds.size.height")
            anim.fromValue = 0
            anim.toValue = h
            anim.duration = 0.6
            anim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            bar.add(anim, forKey: "grow")
        }
    }
}

struct BarChartUIKitRepresentable: UIViewRepresentable {
    var values: [CGFloat]
    func makeUIView(context: Context) -> BarChartView { BarChartView() }
    func updateUIView(_ uiView: BarChartView, context: Context) {
        uiView.tintColor = UIColor(Theme.brandOrange)
        uiView.values = values
    }
}

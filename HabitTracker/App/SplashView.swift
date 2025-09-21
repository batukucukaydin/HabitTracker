//
//  AnimatedBrand.swift
//  HabitTracker
//
import SwiftUI

struct AnimatedBrand: View {
@State private var wave = false
var body: some View {
HStack(spacing: 8) {
Text("Habit").font(.system(size: 34, weight: .heavy, design: .rounded)).foregroundStyle(.white)
Text("Tracker").font(.system(size: 34, weight: .heavy, design: .rounded)).foregroundStyle(Theme.brandOrange)
.shadow(color: Theme.brandOrange.opacity(0.6), radius: 12)
.offset(y: wave ? -2 : 2)
.animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: wave)
}
.onAppear { wave = true }
}
}

struct SplashView: View {
@State private var scale: CGFloat = 0.6
@State private var opacity: Double = 0
var body: some View {
ZStack {
Theme.appBackground.ignoresSafeArea()
VStack(spacing: 16) {
Image(systemName: "flame.fill").font(.system(size: 56)).foregroundStyle(Theme.brandOrange)
.shadow(color: Theme.brandOrange.opacity(0.7), radius: 24)
.scaleEffect(scale).opacity(opacity)
AnimatedBrand().scaleEffect(scale).opacity(opacity)
}
}
.onAppear {
withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) { scale = 1.0 }
withAnimation(.easeIn(duration: 0.4)) { opacity = 1.0 }
}
}
}

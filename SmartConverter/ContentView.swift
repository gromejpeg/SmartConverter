//
//  ContentView.swift
//  SmartConverter
//
//  Created by Gabriel Romero on 11/24/25.
//

import SwiftUI
import UIKit

// MARK: - Models

struct ConversionItem: Identifiable {
    let id = UUID()
    let label: String
    let fromUnit: String
    let toUnit: String
    let calculate: (Double) -> Double
}

struct Category: Identifiable {
    let id = UUID()
    let title: String
    let iconName: String
    let gradient: LinearGradient
    let conversions: [ConversionItem]
}

// MARK: - Main View

struct ContentView: View {
    @State private var inputValue: String = ""
    @State private var copiedId: UUID? = nil
    @State private var isInputActive: Bool = false
    
    // Background Animation States
    @State private var animateGradient: Bool = false
    
    // Computed property to get numerical value safely
    var val: Double {
        return Double(inputValue) ?? 0
    }
    
    // Helper to format results
    func format(_ num: Double) -> String {
        if inputValue.isEmpty { return "0" }
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: num)) ?? "0"
    }
    
    // Data definition with specific gradients per category
    var categories: [Category] {
        [
            Category(title: "Temperature", iconName: "thermometer.medium", gradient: LinearGradient(colors: [.orange, .red], startPoint: .topLeading, endPoint: .bottomTrailing), conversions: [
                ConversionItem(label: "Celsius to Fahrenheit", fromUnit: "°C", toUnit: "°F", calculate: { $0 * 9/5 + 32 }),
                ConversionItem(label: "Fahrenheit to Celsius", fromUnit: "°F", toUnit: "°C", calculate: { ($0 - 32) * 5/9 })
            ]),
            Category(title: "Length", iconName: "ruler", gradient: LinearGradient(colors: [.blue, .cyan], startPoint: .topLeading, endPoint: .bottomTrailing), conversions: [
                ConversionItem(label: "Meters to Feet", fromUnit: "m", toUnit: "ft", calculate: { $0 * 3.28084 }),
                ConversionItem(label: "Feet to Meters", fromUnit: "ft", toUnit: "m", calculate: { $0 / 3.28084 }),
                ConversionItem(label: "Miles to KM", fromUnit: "mi", toUnit: "km", calculate: { $0 / 0.621371 })
            ]),
            Category(title: "Weight", iconName: "scalemass", gradient: LinearGradient(colors: [.purple, .indigo], startPoint: .topLeading, endPoint: .bottomTrailing), conversions: [
                ConversionItem(label: "KG to Lbs", fromUnit: "kg", toUnit: "lbs", calculate: { $0 * 2.20462 }),
                ConversionItem(label: "Lbs to KG", fromUnit: "lbs", toUnit: "kg", calculate: { $0 / 2.20462 })
            ]),
            Category(title: "Speed", iconName: "wind", gradient: LinearGradient(colors: [.mint, .teal], startPoint: .topLeading, endPoint: .bottomTrailing), conversions: [
                ConversionItem(label: "KM/H to MPH", fromUnit: "km/h", toUnit: "mph", calculate: { $0 * 0.621371 }),
                ConversionItem(label: "MPH to KM/H", fromUnit: "mph", toUnit: "km/h", calculate: { $0 / 0.621371 })
            ])
        ]
    }

    var body: some View {
        ZStack {
            // MARK: - Ambient Background
            // A deep, dark base with moving aurora lights
            Color(red: 0.05, green: 0.05, blue: 0.1).ignoresSafeArea()
            
            ZStack {
                // Orb 1
                Circle()
                    .fill(Color.blue.opacity(0.4))
                    .frame(width: 300, height: 300)
                    .blur(radius: 60)
                    .offset(x: animateGradient ? -100 : 100, y: animateGradient ? -150 : -50)
                
                // Orb 2
                Circle()
                    .fill(Color.purple.opacity(0.4))
                    .frame(width: 350, height: 350)
                    .blur(radius: 70)
                    .offset(x: animateGradient ? 100 : -50, y: animateGradient ? 100 : 200)
                
                // Orb 3
                Circle()
                    .fill(Color.cyan.opacity(0.3))
                    .frame(width: 250, height: 250)
                    .blur(radius: 50)
                    .offset(x: animateGradient ? -50 : -150, y: animateGradient ? 250 : 0)
            }
            .animation(.easeInOut(duration: 10).repeatForever(autoreverses: true), value: animateGradient)
            .onAppear { animateGradient = true }
            .ignoresSafeArea()
            
            
            VStack(spacing: 0) {
                // MARK: - Hero Input Section
                VStack(spacing: 20) {
                    Text("CONVERTER")
                        .font(.system(size: 14, weight: .black))
                        .tracking(4)
                        .foregroundStyle(.white.opacity(0.6))
                        .padding(.top, 20)
                    
                    ZStack {
                        // Glowing backdrop for input
                        if !inputValue.isEmpty {
                            Circle()
                                .fill(Color.white.opacity(0.1))
                                .blur(radius: 30)
                                .frame(width: 200, height: 200)
                        }
                        
                        TextField("0", text: $inputValue)
                            .font(.system(size: 86, weight: .thin, design: .rounded))
                            .multilineTextAlignment(.center)
                            .keyboardType(.decimalPad)
                            .foregroundStyle(.white)
                            .tint(.white) // Cursor color
                            .shadow(color: .white.opacity(0.5), radius: 20, x: 0, y: 0)
                    }
                    .frame(height: 120)
                    
                    if inputValue.isEmpty {
                        Text("Tap to enter value")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(.white.opacity(0.4))
                    }
                }
                .padding(.bottom, 40)
                .background(
                    LinearGradient(colors: [.black.opacity(0.0), .black.opacity(0.2)], startPoint: .top, endPoint: .bottom)
                )
                
                // MARK: - Glass Content
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        ForEach(categories) { category in
                            VStack(alignment: .leading, spacing: 16) {
                                
                                // Category Pill
                                HStack {
                                    Image(systemName: category.iconName)
                                    Text(category.title.uppercased())
                                        .font(.system(size: 12, weight: .bold))
                                        .tracking(1)
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(.ultraThinMaterial)
                                .clipShape(Capsule())
                                .foregroundStyle(.white.opacity(0.8))
                                .padding(.leading, 8)
                                
                                // Cards Grid
                                VStack(spacing: 12) {
                                    ForEach(category.conversions) { item in
                                        GlassConversionCard(
                                            item: item,
                                            inputValue: inputValue,
                                            result: format(item.calculate(val)),
                                            isCopied: copiedId == item.id,
                                            gradient: category.gradient
                                        ) {
                                            copyToClipboard(text: format(item.calculate(val)), id: item.id)
                                        }
                                    }
                                }
                            }
                        }
                        
                        // Footer
                        Text("Designed Gabriel Romero")
                            .font(.caption2)
                            .foregroundStyle(.white.opacity(0.2))
                            .padding(.top, 40)
                            .padding(.bottom, 60)
                    }
                    .padding(.horizontal, 20)
                }
                .mask(
                    LinearGradient(gradient: Gradient(stops: [
                        .init(color: .clear, location: 0),
                        .init(color: .black, location: 0.05),
                        .init(color: .black, location: 1)
                    ]), startPoint: .top, endPoint: .bottom)
                )
            }
        }
        .colorScheme(.dark) // Force dark mode for this aesthetic
    }
    
    func copyToClipboard(text: String, id: UUID) {
        UIPasteboard.general.string = text
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            copiedId = id
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                if copiedId == id {
                    copiedId = nil
                }
            }
        }
    }
}

// MARK: - Premium Glass Card

struct GlassConversionCard: View {
    let item: ConversionItem
    let inputValue: String
    let result: String
    let isCopied: Bool
    let gradient: LinearGradient
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 0) {
                // Value Section
                HStack(alignment: .firstTextBaseline) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(item.fromUnit)
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(.white.opacity(0.4))
                        Text(inputValue.isEmpty ? "0" : inputValue)
                            .font(.system(size: 24, weight: .light, design: .rounded))
                            .foregroundStyle(.white.opacity(0.8))
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Arrow with Glow
                    Image(systemName: "arrow.right")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(.white.opacity(0.2))
                        .padding(.horizontal, 10)
                    
                    // Result Section
                    VStack(alignment: .trailing, spacing: 2) {
                        Text(item.toUnit)
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(isCopied ? .green : .white.opacity(0.4))
                        
                        Text(result)
                            .font(.system(size: 28, weight: .medium, design: .rounded))
                            .foregroundStyle(inputValue.isEmpty ? .white.opacity(0.3) : .white)
                            .shadow(color: isCopied ? .green.opacity(0.5) : .clear, radius: 10)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                            .contentTransition(.numericText())
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 24)
            .background(.ultraThinMaterial)
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(
                        LinearGradient(
                            colors: [
                                .white.opacity(isCopied ? 0.5 : 0.15),
                                .white.opacity(isCopied ? 0.2 : 0.05)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .shadow(color: .black.opacity(0.2), radius: 15, x: 0, y: 10)
        }
        .buttonStyle(BouncyButtonStyle())
        .animation(.default, value: result)
    }
}

// MARK: - Animation Styles

struct BouncyButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .brightness(configuration.isPressed ? 0.1 : 0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

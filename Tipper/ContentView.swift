//
//  ContentView.swift
//  Tipper
//
//  Created by Dillon Teakell on 12/1/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var checkAmount: Double = 0
    private let tipPercentages = [0, 10, 15, 20, 25, 30]
    @FocusState private var isFocused: Bool
    @State private var selectedTipPercentage: Int = 20
    
    // Computed Properties
    var totalTipped: Double {
        let tipAmount = Double(selectedTipPercentage)
        let tipTotal = checkAmount / 100 * tipAmount
        return tipTotal
    }
    var checkTotal: Double {
        let tipAmount = Double(selectedTipPercentage)
        let tipTotal = checkAmount / 100 * tipAmount
        let grandTotal = checkAmount + tipTotal
        return grandTotal
    }
    
    private let currencyCode = Locale.current.currency?.identifier ?? "USD"
    private var checkTotalColor: Color {
        if selectedTipPercentage == 0 {
            return .red
        } else if selectedTipPercentage < 15 {
            return .orange
        } else {
            return .green
        }
    }
    
    
    // Accessibility Properties
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize: DynamicTypeSize
    private var accessibilityTextRequiresScrollView: Bool {
        if dynamicTypeSize >= .accessibility1 {
            return true
        } else {
            return false
        }
    }
    
    
    var body: some View {
        if accessibilityTextRequiresScrollView {
            NavigationStack {
                ScrollView {
                    VStack {
                        // Original Check Amount View
                        OriginalTextAmountView(checkAmount: $checkAmount)
                            .focused($isFocused)
                        
                        // Tip Percentage
                        TipPercentageView(
                            selectedTipPercentage: $selectedTipPercentage,
                            tipPercentages: tipPercentages
                        )
                        
                        // Check Total
                        CheckTotalView(
                            checkTotal: checkTotal,
                            checkTotalColor: checkTotalColor
                        )
                    }
                    .toolbar {
                        ToolbarItem(placement: .keyboard) {
                            Spacer()
                            Button("Done") {
                                if isFocused {
                                    isFocused = false
                                }
                            }
                        }
                    }
                    .padding()
                    .navigationTitle("Tip")
                }
            }
        } else {
            NavigationStack {
                VStack {
                    // Original Check Amount View
                    OriginalTextAmountView(checkAmount: $checkAmount)
                        .focused($isFocused)
                    
                    // Tip Percentage
                    TipPercentageView(
                        selectedTipPercentage: $selectedTipPercentage,
                        tipPercentages: tipPercentages
                    )
                    
                    // Check Total
                    CheckTotalView(
                        checkTotal: checkTotal,
                        checkTotalColor: checkTotalColor
                    )
                }
                .toolbar {
                    ToolbarItem(placement: .keyboard) {
                        HStack {
                            Spacer()
                            Button("Done") {
                                isFocused = false
                            }
                        }
                    }
                }
                .padding()
                .navigationTitle("Tip")
                
                Spacer()
            }
        }
    }
}



struct OriginalTextAmountView: View {
    @Binding var checkAmount: Double
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize: DynamicTypeSize
    
    private let currencyCode = Locale.current.currency?.identifier ?? "USD"
    var body: some View {
        // Original Check Amount View
        VStack (alignment: .leading) {
            Text("Original Check Amount")
                .padding(dynamicTypeSize > .xxxLarge ? [.top, .horizontal] : .horizontal)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(3)
            TextField("Enter check amount here", value: $checkAmount, format: .currency(code: currencyCode))
            .padding(dynamicTypeSize > .xxxLarge ? [.bottom, .horizontal] : .horizontal)
            .font(.title2)
            .fontWeight(.semibold)
            .keyboardType(.decimalPad)

        }
        .cardStyle()
    }
}

struct TipPercentageView: View {
    
    @Binding var selectedTipPercentage: Int
    var tipPercentages: [Int]
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize: DynamicTypeSize
    
    var body: some View {
        VStack (alignment: .leading) {
            
            Text("Tip Percentage")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(dynamicTypeSize > .xxxLarge ? [.top, .horizontal] : .horizontal)
            
            HStack {
                Picker("Tip Percentage", selection: $selectedTipPercentage) {
                    ForEach(tipPercentages, id: \.self) { percentage in
                        Text("\(percentage)%")
                    }
                    
                }
                
                .font(.title2)
                
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding(dynamicTypeSize > .xxxLarge ? [.bottom, .horizontal]: .leading, 6)
            .tint(.primary)
            
        }
        .cardStyle()
    }
}

struct CheckTotalView: View {
    
    var checkTotal: Double
    var checkTotalColor: Color
    private let currencyCode = Locale.current.currency?.identifier ?? "USD"
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize: DynamicTypeSize
    
    var body: some View {
        // Check Total
        VStack (alignment: .leading) {
            Text("Check Total")
                .padding(dynamicTypeSize > .xxxLarge ? [.top, .horizontal] : .horizontal)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            
            Text("\(checkTotal.formatted(.currency(code: currencyCode)))")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(checkTotalColor)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(dynamicTypeSize > .xxxLarge ? [.bottom, .horizontal] : .horizontal)
                .padding(.vertical, 0.5)
            
            
        }
        .cardStyle()
    }
}

struct Card: ViewModifier {
    @ScaledMetric private var cardHeight = 80
    @ScaledMetric private var dynamicCardHeight = 90
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize: DynamicTypeSize
    func body(content: Content) -> some View {
        content
            .frame(
                maxWidth: .infinity,
                maxHeight: dynamicTypeSize > .xxxLarge ? dynamicCardHeight : cardHeight
            )
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            
    }
}

extension View {
    func cardStyle() -> some View {
        modifier(Card())
    }
}


#Preview {
    NavigationStack {
        ContentView()
    }
}

//
//  MacrosChart.swift
//  AthletesDiaryApp
//
//  Created by sherzod on 13/05/24.
//

import SwiftUI
import Charts

struct Product: Identifiable {
    let id = UUID()
    let title: String
    let grams: Double
}



extension Product: Equatable {
    static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id
    }
}



struct SectorChartExample: View {
    @State private var selectedAngle: Double?
    
    @ObservedObject var breakfastList: MealList
    @ObservedObject var lunchList: MealList
    @ObservedObject var dinnerList: MealList
    @ObservedObject var otherList: MealList

    private var products: [Product] {
        [
            .init(title: "Fat", grams: Double(nutrientsCount(for: \.fat))),
            .init(title: "Carbs", grams: Double(nutrientsCount(for: \.carbs))),
            .init(title: "Protein", grams: Double(nutrientsCount(for: \.protein)))
        ]
    }
    
    private var totalGrams: Double {
        products.map(\.grams).reduce(0, +)
    }

    private var categoryRanges: [(category: String, range: Range<Double>)] {
        var ranges = [(category: String, range: Range<Double>)]()
        var start: Double = 0

        for product in products {
            let end = start + product.grams
            ranges.append((category: product.title, range: start..<end))
            start = end
        }

        return ranges
    }

    private var selectedProduct: Product? {
        guard let selectedAngle else { return nil }
        if let selected = categoryRanges.firstIndex(where: { $0.range.contains(selectedAngle) }) {
            return products[selected]
        }
        return nil
    }

    private func formatValue(_ value: Double) -> String {
        let percentage = (value / totalGrams) * 100
        return String(format: "%.2f%%", percentage)
    }

    var body: some View {
        Chart(products) { product in
            SectorMark(
                angle: .value(
                    Text(verbatim: product.title),
                    product.grams
                ),
                innerRadius: .ratio(0.6),
                angularInset: 5
            )
            .cornerRadius(10)
            .foregroundStyle(
                by: .value(
                    Text(verbatim: product.title),
                    product.title
                )
            )
            .opacity(product == selectedProduct ? 1 : 0.8)
        }
        .chartLegend(alignment: .center, spacing: 20){
            HStack{
                Spacer()
                Image(systemName: "circle.fill")
                    .frame(width: 0.5, height: 0.5)
                    .foregroundStyle(Color.blue)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 3))
                Text("Fat: \(nutrientsCount(for: \.fat))g")
                    .foregroundStyle(Color.gray)
                    .font(.system(size: 14))
                Spacer()
                Image(systemName: "circle.fill")
                    .frame(width: 0.5, height: 0.5)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 3))
                    .foregroundStyle(Color.yellow)
                Text("Protein: \(nutrientsCount(for: \.protein))g")
                    .foregroundStyle(Color.gray)
                    .font(.system(size: 14))
                Spacer()
                Image(systemName: "circle.fill")
                    .frame(width: 0.5, height: 0.5)
                    .foregroundStyle(Color.green)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 3))
                Text("Carbs: \(nutrientsCount(for: \.carbs))g")
                    .foregroundStyle(Color.gray)
                    .font(.system(size: 14))
                Spacer()
            }
        }
        .padding()
        .scaledToFit()
        .chartAngleSelection(value: $selectedAngle)
        .chartBackground { chartProxy in
            GeometryReader { geometry in
                if let anchor = chartProxy.plotFrame {
                    let frame = geometry[anchor]
                    VStack {
                        Text(selectedProduct?.title ?? "Macros")
                            .font(.title)
                            .fontWeight(.bold)
                        Text(formatValue(selectedProduct?.grams ?? totalGrams))
                        Text("\(Int(selectedProduct?.grams ?? totalGrams)) g")
                            .foregroundStyle(Color.gray)
                    
                    }
                    .position(x: frame.midX, y: frame.midY)
                }
            }
        }
    }
    private func nutrientsCount(for property: KeyPath<MealListItem, Int>) -> Int {
        [breakfastList.items, lunchList.items, dinnerList.items, otherList.items]
            .flatMap { $0 }
            .reduce(0) { $0 + $1[keyPath: property] }
    }
    private func categoryNutrients(_ items: [MealListItem], for property: KeyPath<MealListItem, Int>) -> Int {
        items.reduce(0) { $0 + $1[keyPath: property] }
    }
}


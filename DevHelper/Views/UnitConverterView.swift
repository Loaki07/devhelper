import SwiftUI

struct UnitConverterView: View {
    @State private var selectedCategory: UnitCategory = .data
    @State private var fromUnit: String = ""
    @State private var toUnit: String = ""
    @State private var inputValue: String = ""
    @State private var outputValue: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Unit Converter")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            // Category Selection
            Picker("Category", selection: $selectedCategory) {
                ForEach(UnitCategory.allCases, id: \.self) { category in
                    Text(category.title)
                        .tag(category)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .onChange(of: selectedCategory) { _, newCategory in
                let units = newCategory.units
                fromUnit = units.first?.name ?? ""
                toUnit = units.count > 1 ? units[1].name : units.first?.name ?? ""
                convertUnits()
            }
            
            HStack(spacing: 40) {
                // From Unit
                VStack(alignment: .leading, spacing: 10) {
                    Text("From")
                        .font(.headline)
                    
                    Picker("From Unit", selection: $fromUnit) {
                        ForEach(selectedCategory.units, id: \.name) { unit in
                            Text(unit.symbol)
                                .tag(unit.name)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .onChange(of: fromUnit) { _, _ in
                        convertUnits()
                    }
                    
                    TextField("Enter value", text: $inputValue)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onChange(of: inputValue) { _, _ in
                            convertUnits()
                        }
                }
                
                Image(systemName: "arrow.right")
                    .font(.title)
                    .foregroundColor(.blue)
                
                // To Unit
                VStack(alignment: .leading, spacing: 10) {
                    Text("To")
                        .font(.headline)
                    
                    Picker("To Unit", selection: $toUnit) {
                        ForEach(selectedCategory.units, id: \.name) { unit in
                            Text(unit.symbol)
                                .tag(unit.name)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .onChange(of: toUnit) { _, _ in
                        convertUnits()
                    }
                    
                    TextField("Result", text: $outputValue)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disabled(true)
                }
            }
            .padding(.horizontal, 0)
            
            // Swap Button
            Button("Swap Units") {
                let temp = fromUnit
                fromUnit = toUnit
                toUnit = temp
                convertUnits()
            }
            .buttonStyle(.bordered)
            
            Spacer()
        }
        .padding()
        .onAppear {
            let units = selectedCategory.units
            fromUnit = units.first?.name ?? ""
            toUnit = units.count > 1 ? units[1].name : units.first?.name ?? ""
        }
    }
    
    private func convertUnits() {
        guard let inputDouble = Double(inputValue),
              let fromUnitData = selectedCategory.units.first(where: { $0.name == fromUnit }),
              let toUnitData = selectedCategory.units.first(where: { $0.name == toUnit }) else {
            outputValue = ""
            return
        }
        
        let result: Double
        
        if selectedCategory == .temperature {
            result = convertTemperature(inputDouble, from: fromUnitData.name, to: toUnitData.name)
        } else {
            // Convert to base unit first, then to target unit
            let baseValue = inputDouble * fromUnitData.toBaseMultiplier
            result = baseValue / toUnitData.toBaseMultiplier
        }
        
        // Format the result properly, removing only trailing zeros
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 10
        formatter.minimumFractionDigits = 0
        outputValue = formatter.string(from: NSNumber(value: result)) ?? "0"
    }
    
    private func convertTemperature(_ value: Double, from fromUnit: String, to toUnit: String) -> Double {
        // Convert from source to Celsius first
        let celsius: Double
        switch fromUnit {
        case "celsius":
            celsius = value
        case "fahrenheit":
            celsius = (value - 32) * 5/9
        case "kelvin":
            celsius = value - 273.15
        default:
            celsius = value
        }
        
        // Convert from Celsius to target unit
        switch toUnit {
        case "celsius":
            return celsius
        case "fahrenheit":
            return celsius * 9/5 + 32
        case "kelvin":
            return celsius + 273.15
        default:
            return celsius
        }
    }
}

enum UnitCategory: String, CaseIterable {
    case data, length, weight, temperature, area, volume
    
    var title: String {
        switch self {
        case .length: return "Length"
        case .weight: return "Weight"
        case .temperature: return "Temperature"
        case .data: return "Data"
        case .area: return "Area"
        case .volume: return "Volume"
        }
    }
    
    var units: [UnitData] {
        switch self {
        case .length:
            return [
                UnitData(name: "millimeter", symbol: "mm", toBaseMultiplier: 0.001),
                UnitData(name: "centimeter", symbol: "cm", toBaseMultiplier: 0.01),
                UnitData(name: "meter", symbol: "m", toBaseMultiplier: 1.0),
                UnitData(name: "kilometer", symbol: "km", toBaseMultiplier: 1000.0),
                UnitData(name: "inch", symbol: "in", toBaseMultiplier: 0.0254),
                UnitData(name: "foot", symbol: "ft", toBaseMultiplier: 0.3048),
                UnitData(name: "yard", symbol: "yd", toBaseMultiplier: 0.9144),
                UnitData(name: "mile", symbol: "mi", toBaseMultiplier: 1609.344)
            ]
        case .weight:
            return [
                UnitData(name: "milligram", symbol: "mg", toBaseMultiplier: 0.001),
                UnitData(name: "gram", symbol: "g", toBaseMultiplier: 1.0),
                UnitData(name: "kilogram", symbol: "kg", toBaseMultiplier: 1000.0),
                UnitData(name: "ounce", symbol: "oz", toBaseMultiplier: 28.3495),
                UnitData(name: "pound", symbol: "lb", toBaseMultiplier: 453.592),
                UnitData(name: "ton", symbol: "ton", toBaseMultiplier: 1000000.0)
            ]
        case .temperature:
            return [
                UnitData(name: "celsius", symbol: "°C", toBaseMultiplier: 1.0),
                UnitData(name: "fahrenheit", symbol: "°F", toBaseMultiplier: 1.0),
                UnitData(name: "kelvin", symbol: "K", toBaseMultiplier: 1.0)
            ]
        case .data:
            return [
                UnitData(name: "byte", symbol: "B", toBaseMultiplier: 1.0),
                UnitData(name: "kilobyte", symbol: "KB", toBaseMultiplier: 1024.0),
                UnitData(name: "megabyte", symbol: "MB", toBaseMultiplier: 1024.0 * 1024.0),
                UnitData(name: "gigabyte", symbol: "GB", toBaseMultiplier: 1024.0 * 1024.0 * 1024.0),
                UnitData(name: "terabyte", symbol: "TB", toBaseMultiplier: 1024.0 * 1024.0 * 1024.0 * 1024.0),
                UnitData(name: "petabyte", symbol: "PB", toBaseMultiplier: 1024.0 * 1024.0 * 1024.0 * 1024.0 * 1024.0)
            ]
        case .area:
            return [
                UnitData(name: "square_meter", symbol: "m²", toBaseMultiplier: 1.0),
                UnitData(name: "square_foot", symbol: "ft²", toBaseMultiplier: 0.092903),
                UnitData(name: "acre", symbol: "ac", toBaseMultiplier: 4046.86),
                UnitData(name: "hectare", symbol: "ha", toBaseMultiplier: 10000.0)
            ]
        case .volume:
            return [
                UnitData(name: "milliliter", symbol: "mL", toBaseMultiplier: 0.001),
                UnitData(name: "liter", symbol: "L", toBaseMultiplier: 1.0),
                UnitData(name: "gallon", symbol: "gal", toBaseMultiplier: 3.78541),
                UnitData(name: "quart", symbol: "qt", toBaseMultiplier: 0.946353),
                UnitData(name: "pint", symbol: "pt", toBaseMultiplier: 0.473176),
                UnitData(name: "cup", symbol: "cup", toBaseMultiplier: 0.236588)
            ]
        }
    }
}

struct UnitData {
    let name: String
    let symbol: String
    let toBaseMultiplier: Double
}

#Preview {
    UnitConverterView()
}
import SwiftUI
import CompactSlider

struct SeedsView: View {
    
    @EnvironmentObject var context: GenerationContext

    var body: some View {
        HStack {
            Text("Seeds")
                .style(.control)
            
            InfoButton {
                VStack {
                    Text("Random seed which to start generation")
                }
                .padding()
            }
        }
        HStack {
            TextField("RANDOM", value: $context.seed, formatter: .seed)
                .textFieldStyle(.roundedBorder)
        }
    }
    
    private func createSeedSlider() -> some View {
        let seedBinding = Binding<Double> {
            Double(context.seed)
        } set: {
            context.seed = .init($0)
        }
        
        return CompactSlider(value: seedBinding, in: 1...20, step: 1) {
            Text("Seeds")
            Spacer()
            Text("\(context.seed)")
        }
        .padding(.bottom, 5)
    }
}

extension Formatter {
    static let seed: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimum = 0
        formatter.maximum = NSNumber(value: UInt32.max)
        formatter.maximumFractionDigits = 0
        formatter.usesGroupingSeparator = false
        formatter.hasThousandSeparators = false
        formatter.alwaysShowsDecimalSeparator = false
        formatter.zeroSymbol = ""
        return formatter
    }()
}

#Preview {
    SeedsView()
}

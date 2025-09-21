// -------------------------------------------------------------
// Widgets/HabitWidgets.swift – Progress ring + quote
// -------------------------------------------------------------
import WidgetKit
import SwiftUI

struct HabitEntry: TimelineEntry { let date: Date; let progress: Double; let quote: String }

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> HabitEntry { .init(date: Date(), progress: 0.42, quote: "Küçük adımlar…") }
    func getSnapshot(in context: Context, completion: @escaping (HabitEntry) -> ()) { completion(placeholder(in: context)) }
    func getTimeline(in context: Context, completion: @escaping (Timeline<HabitEntry>) -> ()) {
        // Simple: read Core Data via App Group if needed; here we dummy compute
        let entry = HabitEntry(date: Date(), progress: 0.75, quote: "Disiplin, motivasyonu yener.")
        completion(Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(60*30))))
    }
}

struct HabitWidgetView: View {
    var entry: Provider.Entry
    var body: some View {
        VStack(alignment: .center) {
            ProgressRingView(progress: entry.progress)
                .frame(width: 90, height: 90)
            Text("%\(Int(entry.progress * 100))").font(.headline)
            Text(entry.quote).font(.caption).multilineTextAlignment(.center)
        }.padding()
    }
}

@main
struct HabitWidgets: Widget {
    let kind: String = "HabitWidgets"
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in HabitWidgetView(entry: entry) }
            .configurationDisplayName("Günlük İlerleme")
            .description("Bugünkü ilerleme ve motivasyon sözü.")
            .supportedFamilies([.systemSmall, .systemMedium])
    }
}

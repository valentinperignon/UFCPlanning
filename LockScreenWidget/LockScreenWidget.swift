//
//  LockScreenWidget.swift
//  LockScreenWidget
//
//  Created by Valentin Perignon on 21/09/2022.
//

import UFCPlanningCore
import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> NextLessonEntry {
        NextLessonEntry(date: .now, lesson: Constants.widgetLessonPlaceholder)
    }

    func getSnapshot(in context: Context, completion: @escaping (NextLessonEntry) -> ()) {
        let entry = NextLessonEntry(date: .now, lesson: Constants.widgetLessonPlaceholder)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let emptyTimeline = Timeline(
            entries: [NextLessonEntry(date: .now, lesson: nil)],
            policy: .after(.now.addingTimeInterval(300)) // Refresh again in 5 minutes
        )

        Task {
            let lessons = try? await PlanningManager.shared.fetchNextLessons()
            guard let lessons = lessons,
                  let nextLesson = lessons.first
            else {
                completion(emptyTimeline)
                return
            }

            var lessonToDisplay: Lesson? = nextLesson
            if nextLesson.end < .now.addingTimeInterval(Constants.refreshWidget) {
                lessonToDisplay = lessons.count > 1 ? lessons[1] : nil
            }

            if let lessonToDisplay = lessonToDisplay {
                completion(Timeline(
                    entries: [NextLessonEntry(date: .now, lesson: lessonToDisplay)],
                    policy: .after(lessonToDisplay.end.addingTimeInterval(Constants.refreshWidget))
                ))
            } else {
                completion(emptyTimeline)
            }
        }
    }
}

struct NextLessonEntry: TimelineEntry {
    let date: Date
    let lesson: Lesson?
}

struct LockScreenWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        HStack {
            if let lesson = entry.lesson {
                nextLesson(lesson)
            } else {
                Text("Aucun cours à venir")
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func nextLesson(_ lesson: Lesson) -> some View {
        Group {
            RoundedRectangle(cornerRadius: 25)
                .frame(width: 3)
                .frame(maxHeight: .infinity)

            VStack(alignment: .leading) {
                Text("\(lesson.formattedStart) - \(lesson.formattedEnd)")
                    .font(.caption)
                Text(lesson.name)
                    .font(.headline)
                if let about = lesson.about {
                    Text(about)
                }
            }
        }
    }
}

@main
struct LockScreenWidget: Widget {
    let kind: String = "LockScreenWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            LockScreenWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Mon prochain cours")
        .description("Afficher le prochain cours.")
        .supportedFamilies([.accessoryRectangular])
    }
}

struct LockScreenWidget_Previews: PreviewProvider {
    static var previews: some View {
        LockScreenWidgetEntryView(entry: NextLessonEntry(date: .now, lesson: Constants.widgetLessonPlaceholder))
            .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
    }
}

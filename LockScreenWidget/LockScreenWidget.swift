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
        Task {
            do {
                let lessons = try await PlanningManager.shared.fetchNextLessons()
                guard let nextLesson = lessons.first else {
                    completion(emptyTimeline(error: .emptyLesson))
                    return
                }

                var lessonToDisplay: Lesson? = nextLesson
                if nextLesson.end < .now.addingTimeInterval(Constants.refreshWidget) {
                    lessonToDisplay = lessons.count > 1 ? lessons[1] : nil
                }

                if let lessonToDisplay = lessonToDisplay {
                    var reloadAfter = lessonToDisplay.end.addingTimeInterval(Constants.refreshWidget)
                    if !Calendar.current.isDateInToday(lessonToDisplay.start) {
                        reloadAfter = Calendar.current.startOfDay(for: lessonToDisplay.start)
                    }
                    completion(Timeline(
                        entries: [NextLessonEntry(date: .now, lesson: lessonToDisplay)],
                        policy: .after(reloadAfter)
                    ))
                } else {
                    completion(emptyTimeline(error: .emptyLesson))
                }
            } catch {
                completion(emptyTimeline(error: .cannotFetchLessons))
            }
        }
    }

    private func emptyTimeline(error: WidgetError) -> Timeline<NextLessonEntry> {
        return Timeline(
            entries: [NextLessonEntry(error: error)],
            policy: .after(.now.addingTimeInterval(error.timeToWaitToRefresh))
        )
    }
}

struct NextLessonEntry: TimelineEntry {
    let date: Date
    let lesson: Lesson?
    let error: WidgetError?

    init(date: Date, lesson: Lesson?) {
        self.date = date
        self.lesson = lesson
        self.error = nil
    }

    init(error: WidgetError) {
        self.date = .now
        self.lesson = nil
        self.error = error
    }
}

struct LockScreenWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        HStack {
            if let lesson = entry.lesson {
                nextLesson(lesson)
            } else if let error = entry.error {
                Text(error.description)
            } else {
                Text("Erreur")
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
                Text(nextLessonDate(lesson: lesson))
                    .font(.caption)
                Text(lesson.name)
                    .font(.headline)
                if let about = lesson.about {
                    Text(about)
                }
            }
        }
    }

    private func nextLessonDate(lesson: Lesson) -> String {
        if Calendar.current.isDateInToday(lesson.start) {
            return "\(lesson.formattedStart) - \(lesson.formattedEnd)"
        }
        if Calendar.current.isDateInTomorrow(lesson.start) {
            return "Demain à \(lesson.formattedStart)"
        }
        return "\(lesson.start.formatted(.dateTime.day())) à \(lesson.formattedStart)"

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

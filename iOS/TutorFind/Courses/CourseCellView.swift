
import SwiftUI
struct CourseCellView: View {
	var displayTime: Bool = false
    @ObservedObject var courseVM: CourseViewModel
    var body: some View {
        let stack = VStack(alignment: .leading) {
            HStack{
				Text(courseVM.model.title)
                .font(.headline)
            }
			Label(courseVM.model.teacherName, systemImage: "person")
			if displayTime{
				Text("\(courseVM.model.startTime.minuteAndHourString()) - \(courseVM.model.startTime.advanced(by: Double(courseVM.model.lengthInMinutes*60)).minuteAndHourString())")
			}else{
            HStack {
                Label("Κάθε \(courseVM.model.frequency.map{$0.getPrefix()}.joined(separator: "/"))", systemImage: "calendar")
                Spacer()
                Label("\(courseVM.model.lengthInMinutes)m", systemImage: "clock")
                    .padding(.trailing, 20)
            }
            .font(.caption)
			}
        }
		if displayTime{
			stack
				.padding()
				.frame(height: 60)
		}else{
			stack
				.padding()
				.foregroundColor(.white)
				.background(courseVM.model.color)
				.frame(height: 60)
		}
    }
}

struct CardView_Previews: PreviewProvider {
    static var course = Course.data[0]
    static var previews: some View {
        CourseCellView(courseVM: CourseViewModel(model: course))
    }
}

import SwiftUI

struct AboutView: View {
    var body: some View {
        ZStack {
                VStack(spacing: 24) {
                    Text("""
                    Hi! This is a weather app that can advise whether now is a good time to do a certain activity. It can also notify you when a good time to do an activity in the future comes.
                    Have fun with it ᥫ᭡。
                    """)
                    .modifier(AboutTextStyle())

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Credits")
                            .bold()
                            .font(.title3)
                            .modifier(AboutTextStyle())

                        creditRow("Weather data", "Open-Meteo", "https://open-meteo.com/")
                        creditRow("Photo", "Connor McManus via Pexels", "https://www.pexels.com/photo/clouds-and-rainfall-14319807/")
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Licenses")
                            .bold()
                            .font(.title3)
                            .modifier(AboutTextStyle())

                        creditRow("Open-Meteo data", "CC BY 4.0", "https://creativecommons.org/licenses/by/4.0/")
                        creditRow("Open-Meteo SDK", "MIT License", "https://github.com/open-meteo/sdk/blob/main/LICENSE")
                        creditRow("Google FlatBuffers", "Apache License 2.0", "https://github.com/google/flatbuffers/blob/master/LICENSE")
                        creditRow("Pexels", "Pexels License", "https://www.pexels.com/license/")
                    }

                    VStack(spacing: 4) {
                        Text("Created by")
                            .modifier(AboutTextStyle())

                        Link("🐙 highness-ru",
                             destination: URL(string: "https://github.com/highness-ru")!)
                            .modifier(AboutTextStyle())
                    }
                }
                .modifier(AboutBoxStyle())
                .padding()
        }
        .screenBackground("pexels-connorscottmcmanus-14319807")
    }

    private func creditRow(_ title: String, _ linkText: String, _ url: String) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title + ":")
                .modifier(AboutTextStyle())

            Spacer(minLength: 8)

            Link(linkText, destination: URL(string: url)!)
                .modifier(AboutTextStyle())
                .multilineTextAlignment(.trailing)
        }
    }
}

#Preview {
    AboutView()
}

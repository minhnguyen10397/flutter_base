import SwiftUI

struct ContentView: View {

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)

                Text("Native iOS SwiftUI App")
                    .font(.title2)

                Button {
                    openFlutter()
                } label: {
                    Text("Mở Flutter Host App")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 32)
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)

            Text("Native iOS SwiftUI App")
                .font(.title2)

            Button {
                openFlutter()
            } label: {
                Text("Mở Flutter Host App")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 32)
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)

            Text("Native iOS SwiftUI App")
                .font(.title2)

            Button {
                openFlutter()
            } label: {
                Text("Mở Flutter Host App")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 32)
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)

            Text("Native iOS SwiftUI App")
                .font(.title2)

            Button {
                openFlutter()
            } label: {
                Text("Mở Flutter Host App")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 32)
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)

            Text("Native iOS SwiftUI App")
                .font(.title2)

            Button {
                openFlutter()
            } label: {
                Text("Mở Flutter Host App")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 32)
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)

            Text("Native iOS SwiftUI App")
                .font(.title2)

            Button {
                openFlutter()
            } label: {
                Text("Mở Flutter Host App")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 32)
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)

            Text("Native iOS SwiftUI App")
                .font(.title2)

            Button {
                openFlutter()
            } label: {
                Text("Mở Flutter Host App")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 32)
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)

            Text("Native iOS SwiftUI App")
                .font(.title2)

            Button {
                openFlutter()
            } label: {
                Text("Mở Flutter Host App")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 32)
            }
            .padding()
        }
    }
    
    private func openFlutter() {
        FlutterHelper.openFlutter()
    }
}

#Preview {
    ContentView()
}

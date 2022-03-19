//
//  URLReplaceError.swift
//  Combine Examples
//
//  Created by Steve Plavetzky on 3/19/22.
//

import SwiftUI
import Combine

class URLReplaceErrorVM: ObservableObject{
    @Published var imageView: Image?
    
    var cancellables: Set<AnyCancellable> = []
    
    
    func fetch(){
        let url = URL(string: "https://www.bigmountainstudio.com/image1")!
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map{$0.data}
            .tryMap{ data in
                guard let uiImage = UIImage(data: data) else {
                    throw ErrorForAlert(message: "Did not receive a valid image.")
                }
                return Image(uiImage: uiImage)
            }
            .replaceError(with: Image("Blue and Purple"))
            .receive(on: RunLoop.main)
            .sink{ [unowned self] image in
                imageView = image
            }
            .store(in: &cancellables)
    }
}

struct URLReplaceError: View {
    @StateObject var vm = URLReplaceErrorVM()
    
    var body: some View {
        VStack{
            DescView(desc: "If any errors occur in the pipeline, you can use the replaceError operator to supply default data")
            vm.imageView
                .cornerRadius(20)
        }
        .font(.title)
        .onAppear{
            vm.fetch()
        }
    }
}

struct URLReplaceError_Previews: PreviewProvider {
    static var previews: some View {
        URLReplaceError()
    }
}

//
//  URLDataIntro.swift
//  Combine Examples
//
//  Created by Steve Plavetzky on 3/19/22.
//

import SwiftUI
import Combine

struct CatFact: Decodable{
    let _id: String
    let text: String
}


class URLDataIntroVM: ObservableObject{
    @Published var dataToView: [CatFact] = []
    var cancellables: Set<AnyCancellable> = []
    
    func fetch() {
        let url = URL(string: "https://cat-fact.herokuapp.com/facts")!
        URLSession.shared.dataTaskPublisher(for: url)
        //This can be shorted to the following: .map {$0.data}
            .map{ (data: Data, response: URLResponse) in
                //map takes just the data out of the tuple and returns it
                return data
            }
            .decode(type: [CatFact].self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                //If an error is returned, it goes to sink and gets canceled
                print(completion)
            }, receiveValue: {[unowned self] catFact in
                dataToView = catFact
            })
            .store(in: &cancellables)
    }
    
}

struct URLDataIntro: View {
    @StateObject var vm = URLDataIntroVM()
    
    var body: some View {
        VStack{
            DescView(desc: "URLSession has a dataTaskPublisher you can use to get data from a URL and run it through a pipeline.")
            
            List(vm.dataToView, id: \._id) {catFact in
                Text(catFact.text)
            }
            .font(.title3)
        }
        .font(.title)
        .onAppear{
            vm.fetch()
        }
    }
}

struct URLDataIntro_Previews: PreviewProvider {
    static var previews: some View {
        URLDataIntro()
    }
}

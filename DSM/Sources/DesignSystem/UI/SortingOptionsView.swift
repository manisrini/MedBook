//
//  SwiftUIView.swift
//  DesignSystem
//
//  Created by Manikandan on 22/11/24.
//

import SwiftUI

public enum SortingType{
    case Rating
    case Title
    case Hits
}

public struct Option{
    public let id : String
    public let name : String
    public let type : SortingType
    var isSelected : Bool
    
    public init(id: String, name: String,type : SortingType,isSelected : Bool = false) {
        self.id = id
        self.name = name
        self.type = type
        self.isSelected = isSelected
    }
}

public struct SortingOptionsView: View {
    
    @State var options : [Option] = [
        .init(id: "1", name: "Title", type: .Title),
        .init(id: "2", name: "Average", type: .Rating),
        .init(id: "3", name: "Hits", type: .Hits),
    ]
    var didTapBtn : ((Option)->())?
    
    public init(didTapBtn: ((Option)->())? = nil) {
        self.didTapBtn = didTapBtn
    }
    
    public var body: some View {
        HStack{
            Text("Sort By:")
            
            Spacer(minLength: 25)
            
            ScrollView(.horizontal) {
                HStack(spacing:25){
                    ForEach(options,id: \.id) { opt in
                            Button {
                                self.updateView(for: opt)
                                self.didTapBtn?(opt)
                            } label: {
                                if opt.isSelected{
                                    RoundedLabelView(text: opt.name)
                                }else{
                                    Text(opt.name)
                                        .foregroundStyle(Color.black)
                                }
                            }
                        }
                    }
                }
            }
        .padding(.horizontal,10)
    }
    
    private func updateView(for selectedOption : Option){
        var tempOptions = options
        for (index,option) in options.enumerated(){
            if option.id == selectedOption.id{
                tempOptions[index].isSelected = true
            }else{
                tempOptions[index].isSelected = false
            }
        }
        self.options = tempOptions
    }
}

struct RoundedLabelView: View {
    
    var text : String
    
    var body: some View {
        Text(text)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.gray.opacity(0.3))
            .foregroundColor(.black)
            .cornerRadius(10)
    }
}

#Preview {
    SortingOptionsView()
}

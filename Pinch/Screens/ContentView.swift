//
//  ContentView.swift
//  Pinch
//
//  Created by Anuj Soni on 12/03/22.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - Functions
    func resetImageState()->(){
    withAnimation(.spring()){
    imageScale = 1
    imageOffset = .zero
    }
    }
    // MARK: - Scaling Property
    @State private var isAnimating:Bool = false
    @State private var imageScale:CGFloat = 1
    @State private var imageOffset:CGSize = CGSize.zero
    @State private var isDrawerOpen:Bool = false
    @State private var pageIndex : Int = 1
    
    var body: some View {
        
        NavigationView{
        
        ZStack{
            
            // MARK: - Transparent Background
            Color.clear
            
            // MARK: - page image
            Image(pagesData[pageIndex-1].imageName)
                .resizable()
                .scaledToFit()
                //.aspectRatio(contentMode:.fit)
                .cornerRadius(10)
                .padding()
                .shadow(color: .black.opacity(0.2), radius: 12, x: 2, y: 2)
                .opacity(isAnimating ? 1:0)
                .animation(.linear(duration:1), value: isAnimating)
                .offset(x:imageOffset.width,y:imageOffset.height)
                .scaleEffect(imageScale)
               
        }//ZSTACK
        // MARK: 1- On Tap Gesture
        .onTapGesture(count:2){
            withAnimation(.spring()){
            if imageScale == 1{
                imageScale = 5
            }else{
//                imageScale = 1
//                imageOffset = .zero
                resetImageState()
            }
            }
        }
        // MARK: 2 - Drag Gesture
        .gesture(
            DragGesture()
            .onChanged{value in
            withAnimation(.linear(duration:1))
            {
            imageOffset = value.translation
            }
            }
            .onEnded{_ in
            if imageScale<=1{
            resetImageState()
            }
            }
        )
        // MARK: 3 - Magnification
        .gesture(
        MagnificationGesture()
        .onChanged{value in
        withAnimation(.linear(duration:1)){
            if (value>=0 && value<=5){
                imageScale = value
            } else {
                imageScale = 5
            }
        }
        }
        .onEnded{value in
        if ((value<=1) || imageScale<=1){
        resetImageState()
        }
        }
        )
        .onAppear{
            //withAnimation(.linear(duration:1)){
            isAnimating.toggle()
            //}
        }
        // MARK: - Info Panel
        .overlay(alignment:.top, content: {
            InfoPanelView(scale:imageScale, offset:imageOffset)
                .padding(.horizontal)
                .padding(.top,30)
        })
        // MARK: - Controls
        .overlay(alignment:.bottom){
        Group{
        HStack{
        //Scale Down
        Button{
        withAnimation(.spring()){
        if imageScale>1{
        imageScale -= 1
            
        if imageScale <= 1{
        resetImageState()
        }
        }
        }
        } label: {
        ControlImageView(symbolname:"minus.magnifyingglass")
        }
        //Reset
        Button{
        resetImageState()
        } label: {
        ControlImageView(symbolname:"arrow.up.left.and.down.right.magnifyingglass")
        }
        //Scale Up
        Button{
        withAnimation(.spring()){
//        if imageScale<5{
//        imageScale += 1
//
//        if imageScale > 5{
//        imageScale = 5
//        }
//        }
        
        //More Efficient Way
        if imageScale<5{
        imageScale+=1
        }
        
        }
        } label: {
        ControlImageView(symbolname:"plus.magnifyingglass")
        }
        }//CONTROLS
        .padding(EdgeInsets(top:12, leading: 20, bottom: 12, trailing: 20))
        .background(.ultraThinMaterial)
        .cornerRadius(12)
        .opacity(isAnimating ? 1:0)
            /*alternative
            On HStack
             .frame() //deprciated warning
             .padding(.bottom,30)
             */
        }//GROUP
        .padding(.bottom,30)
        }//OVERLAY
        // MARK: - Drawer
        .overlay(alignment:.topTrailing){
        HStack(spacing:12){
        // MARK: - Drawer Handle
            Image(systemName:isDrawerOpen ? "chevron.compact.right" : "chevron.compact.left")
                .resizable()
                .scaledToFit()
                .frame(height:40)
                .padding(8)
                .foregroundStyle(.secondary)
                .onTapGesture{
                    withAnimation(.easeOut){
                    isDrawerOpen.toggle()
                    }
                }
            
        // MARK: - Thumbnails
            ForEach(pagesData){item in
                Image(item.thumbnailImageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width:80)
                    .cornerRadius(8)
                    .shadow(radius:4)
                    .opacity(isDrawerOpen ? 1 : 0)
                    .animation(.easeOut(duration:0.5),value: isDrawerOpen)
                    .onTapGesture{
                        isAnimating = true
                        pageIndex = item.id
                    }
            }
            
            Spacer()
        }
        .padding(EdgeInsets(top:16, leading: 8, bottom: 16, trailing:8))
        .background(.ultraThinMaterial)
        .cornerRadius(12)
        .opacity(isAnimating ? 1 : 0)
        .frame(width:260)
        .padding(.top,UIScreen.main.bounds.height/12)
        .offset(x:isDrawerOpen ? 20 : 215 )
        }
        
        .navigationTitle("Pinch & Zoom")
        .navigationBarTitleDisplayMode(.inline)
        }.navigationViewStyle(.stack)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().preferredColorScheme(.light)
        
    }
}





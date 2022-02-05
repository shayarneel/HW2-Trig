//
//  ContentView.swift
//  Shared
//
//  Created by Jeff Terry on 1/23/21.
//

import SwiftUI
import CorePlot

typealias plotDataType = [CPTScatterPlotField : Double]

struct ContentView: View {
    @EnvironmentObject var plotDataModel :PlotDataClass
    @ObservedObject private var trigCalculator = Trig_X_Calculator()
    @State var xInput: String = "\(Double.pi/2.0)"
    @State var trigOutput: String = "0.0"
    @State var computerTrig: String = "\(cos(Double.pi/2.0))"
    @State var error: String = "0.0"
    @State var isChecked:Bool = false
    @State var trigFunc = "cos(x):"
  
    

    var body: some View {
        
        VStack{
      
            CorePlot(dataForPlot: $plotDataModel.plotData, changingPlotParameters: $plotDataModel.changingPlotParameters)
                .setPlotPadding(left: 10)
                .setPlotPadding(right: 10)
                .setPlotPadding(top: 10)
                .setPlotPadding(bottom: 10)
                .padding()
            
            Divider()
            
            HStack{
                
                HStack(alignment: .center) {
                    Text("x:")
                        .font(.callout)
                        .bold()
                    TextField("xValue", text: $xInput)
                        .padding()
                }.padding()
                
                HStack(alignment: .center) {
                    Text(trigFunc)
                        .font(.callout)
                        .bold()
                    TextField("cos(x)", text: $trigOutput)
                        .padding()
                }.padding()
                
                Toggle(isOn: $isChecked) {
                            Text("Display Error")
                        }
                .padding()
                
                
            }
            
            HStack{
                
                HStack(alignment: .center) {
                    Text("Expected:")
                        .font(.callout)
                        .bold()
                    TextField("Expected:", text: $computerTrig)
                        .padding()
                }.padding()
                
                HStack(alignment: .center) {
                    Text("Error:")
                        .font(.callout)
                        .bold()
                    TextField("Error", text: $error)
                        .padding()
                }.padding()
            
                
            }
            
            
            HStack{
                Button("Calculate cos(x)", action: {self.calculateCos_X()} )
                .padding()
                
            }
            
            HStack{
                Button("Calculate sin(x)", action: {self.calculateSin_X()} )
                .padding()
                
            }
            
        }
        
    }
    
    
    
    
    /// calculateCos_X
    /// Function accepts the command to start the calculation from the GUI
    func calculateCos_X(){
        
        trigFunc = "cos(x):"
        
        let x = Double(xInput)
        xInput = "\(x!)"
        
        var cos_x = 0.0
        let actualcos_x = cos(x!)
        var errorCalc = 0.0
        
        //pass the plotDataModel to the cosCalculator
        trigCalculator.plotDataModel = self.plotDataModel
        
        //tell the cosCalculator to plot Data or Error
        trigCalculator.plotError = self.isChecked
        
        
        //Calculate the new plotting data and place in the plotDataModel
        cos_x = trigCalculator.calculate_cos_x(x: x!)
        

        print("The cos(\(x!)) = \(cos_x)")
        print("computer calcuates \(actualcos_x)")
        
        trigOutput = "\(cos_x)"
        
        computerTrig = "\(actualcos_x)"
        
        if(actualcos_x != 0.0){
            
            var numerator = cos_x - actualcos_x
            
            if(numerator == 0.0) {numerator = 1.0E-16}
            
            errorCalc = log10(abs((numerator)/actualcos_x))
            
        }
        else {
            errorCalc = 0.0
        }
        
        error = "\(errorCalc)"
        
    }
    

    /// calculateSin_X
    /// Function accepts the command to start the calculation from the GUI
    func calculateSin_X(){
        
        trigFunc = "sin(x):"
        
        let x = Double(xInput)
        xInput = "\(x!)"
        
        var sin_x = 0.0
        let actualsin_x = sin(x!)
        var errorCalc = 0.0
        
        //pass the plotDataModel to the cosCalculator
        trigCalculator.plotDataModel = self.plotDataModel
        
        //tell the cosCalculator to plot Data or Error
        trigCalculator.plotError = self.isChecked
        
        
        //Calculate the new plotting data and place in the plotDataModel
        sin_x = trigCalculator.calculate_sin_x(x: x!)
        

        print("The sin(\(x!)) = \(sin_x)")
        print("computer calcuates \(actualsin_x)")
        
        trigOutput = "\(sin_x)"
        
        computerTrig = "\(actualsin_x)"
        
        if(actualsin_x != 0.0){
            
            var numerator = sin_x - actualsin_x
            
            if(numerator == 0.0) {numerator = 1.0E-16}
            
            errorCalc = log10(abs((numerator)/actualsin_x))
            
        }
        else {
            errorCalc = 0.0
        }
        
        error = "\(errorCalc)"
        
    }
    
    
    
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

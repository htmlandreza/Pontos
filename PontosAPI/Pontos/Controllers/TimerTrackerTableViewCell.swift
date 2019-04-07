//
//  TimerTrackerTableViewCell.swift
//  
//
//  Created by Andreza Moreira on 03/04/19.
//

import UIKit

class TimerTrackerTableViewCell: UITableViewCell {
    var user: ClockifyTimeEntries!

    // MARK: componentes da célula
    @IBOutlet weak var dateStartTimeLabel: UILabel!
    @IBOutlet weak var dateEndTimeLabel: UILabel!
    @IBOutlet weak var descriptionTimeLabel: UILabel!
    @IBOutlet weak var durationTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: prepare - passar informações pra outra tela
    func prepare(with user: ClockifyTimeEntries ){
        // converte o horário inicial pra UTC-3 (pt-br)
        let dateStringStart = user.timeInterval.start
        let formatterStart = DateFormatter()
        formatterStart.locale = Locale.init(identifier: "pt-br")
        formatterStart.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
        let dateStart = formatterStart.date(from: dateStringStart)
        formatterStart.dateFormat = "yyyy-MM-dd HH:mm"
        let startTime = formatterStart.string(from: dateStart!)
        //print(startTime)
        
        // converte o horário final pra UTC-3 (pt-br)
        let dateStringEnd = user.timeInterval.end
        let formatterEnd = DateFormatter()
        formatterEnd.locale = Locale.init(identifier: "pt-br")
        formatterEnd.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
        let dateEnd = formatterEnd.date(from: dateStringEnd)
        formatterEnd.dateFormat = "yyyy-MM-dd HH:mm"
        let endTime = formatterEnd.string(from: dateEnd!)
        //print(endTime)
        
        // Tratada: Data e hora inicial
        let resultStartTime = startTime.components(separatedBy: [ "-", " ", ":"])
        let dataStart = (resultStartTime[2])
        let mesStart = (resultStartTime[1])
        let anoStart = (resultStartTime[0])
        let horaStart = (resultStartTime[3])
        let minStart = (resultStartTime[4])
        
        // Tratada: Data e hora final
        let resultStopTime = endTime.components(separatedBy: [ "-", " ", ":"])
        let dataEnd = (resultStopTime[2])
        let mesEnd = (resultStopTime[1])
        let anoEnd = (resultStopTime[0])
        let horaEnd = (resultStopTime[3])
        let minEnd = (resultStopTime[4])
        
        // Tratada: Duração
        let durationTime = user.timeInterval.duration
        let resultDurationTime = durationTime.components(separatedBy: ["P", "T", "H", "M"])
        //print (resultStartTime)
        let horaDuration = (resultDurationTime[2])
        var minDuration: String? = nil
        if resultDurationTime[3] == ""{
            minDuration = "00"
        } else if resultDurationTime[1] != "" {
            minDuration = (resultDurationTime[3])
            if minDuration!.count == 1 {
            minDuration = minDuration! + "0"
            }
        }
    
        // MARK: montando cada célula
        dateStartTimeLabel.text = dataStart + "/" + mesStart + "/" + anoStart + " às " + horaStart + ":" + minStart
        dateEndTimeLabel.text = dataEnd + "/" + mesEnd + "/" + anoEnd + " às " + horaEnd + ":" + minEnd
        //("\(dataStart) a \(user.timeInterval.end)")
        descriptionTimeLabel.text = user.description
        durationTimeLabel.text = "0" + horaDuration + ":" + (minDuration)!
    }
    
}

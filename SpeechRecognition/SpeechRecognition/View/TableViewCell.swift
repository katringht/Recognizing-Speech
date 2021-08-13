//
//  TableViewCell.swift
//  SpeechRecognition
//
//  Created by Ekaterina Tarasova on 13.08.2021.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet var cellSpeechText: UILabel!
    
    func setUp(with sp: SpeachRecog) {
        cellSpeechText.text = sp.speechtext
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

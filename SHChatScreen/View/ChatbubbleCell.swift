//
//  ChatbubbleCell.swift
//  ChatScreen
//

import UIKit

class ChatbubbleCell: UITableViewCell {

    @IBOutlet weak var chatView: BubbleView!
    @IBOutlet weak var chatLabel: UILabel!
    
    var message = String(){
        didSet{
            chatLabel.text = message
            chatLabel.setLineSpacing(lineSpacing: 2)
        }
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

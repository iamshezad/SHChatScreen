//
//  SHChatViewController.swift
//  SHChatScreen
//

import UIKit

class SHChatViewController: UIViewController,UITextViewDelegate {
    
    @IBOutlet weak var chatTableView: UITableView!
    
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    
    var messages = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        //Tap to dismiss keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Setup UI
    func setupUI(){
        title = "SHChat Screen"
        chatTableView.tableFooterView = UIView()
        messageTextView.delegate = self
        messageTextView.layer.cornerRadius = 20
        messageTextView.layer.masksToBounds = true
        sendButton.layer.cornerRadius = 20
        sendButton.layer.masksToBounds = true
    }
    
    // function which is triggered when handleTap is called
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
       view.endEditing(true)
    }
    
    //Handle Keyboard
    override func viewWillAppear(_ animated: Bool) {
        //keyboard observer
        self.initKeyboardObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //remove observer
        self.removeKeyboardObserver()
    }
    
    private func initKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            print("keyboard height:\(keyboardHeight)")
            self.textViewBottomConstraint.constant = keyboardHeight+10
            self.buttonBottomConstraint.constant = keyboardHeight+10
            self.view.layoutIfNeeded()
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        self.textViewBottomConstraint.constant = 10
        self.buttonBottomConstraint.constant = 10
        self.view.layoutIfNeeded()
    }
    
    private func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self) //remove observer
    }
    
    //Handle TextView
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: messageTextView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        textViewHeightConstraint.constant = min(150, max(40, estimatedSize.height))
        if estimatedSize.height >= 150{
            messageTextView.isScrollEnabled = true
        }else{
            messageTextView.isScrollEnabled = false
        }
        self.view.layoutIfNeeded()
    }
    
    //Send button Action
    @IBAction func sendAction(_ sender: UIButton) {
        if messageTextView.text != ""{
            messages.append(messageTextView.text)
            messageTextView.text = ""
            textViewHeightConstraint.constant = 40
            messageTextView.isScrollEnabled = false
            view.endEditing(true)
            chatTableView.reloadData()
            
        }
    }
}

//TableView Delegate and DataSource

extension SHChatViewController: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row%2 == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "outGoingCell", for: indexPath) as! ChatbubbleCell
            cell.message = messages[indexPath.row]
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "inComingCell", for: indexPath) as! ChatbubbleCell
            cell.chatView.isIncoming = true
            cell.message = messages[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}



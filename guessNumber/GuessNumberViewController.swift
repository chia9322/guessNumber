import UIKit

class GuessNumberViewController: UIViewController {
    
    var randomNumber: Int = 0
    var life: Int = 5
    var rangeMax: Int = 99
    var rangeMin: Int = 1
    
    @IBOutlet var inputTextField: UITextField!
    @IBOutlet var messageLabel: UILabel!
    
    @IBOutlet var starImageViews: [UIImageView]!
    
    @IBOutlet var goButton: UIButton!
    @IBOutlet var goButtonWidth: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // goButton樣式設定
        goButton.clipsToBounds = true
        goButton.layer.cornerRadius = goButton.frame.width/2
        // 指定數字鍵盤
        inputTextField.keyboardType = .numberPad
        // 限制TextField輸入字串位元數協定
        inputTextField.delegate = self
        // 點選畫面任一處時關閉小鍵盤
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(GuessNumberViewController.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
        
        startNewGame()
    }
    
    // 點選畫面任一處時關閉小鍵盤
    @objc func didTapView() {
        self.view.endEditing(true)
    }

    @IBAction func goButtonPressed(_ sender: Any) {
        if let goButtonTitle = goButton.title(for: .normal) {
            if goButtonTitle == "Go" {
                // 當按鈕為"Go"時，檢查數字
                checkNumber()
            } else {
                // 當按鈕為"Try Again時，重新開始遊戲"
                startNewGame()
            }
        }
    }
    
    func checkNumber() {
        if let inputText = inputTextField.text {
            if let number = Int(inputText) {
                if number == randomNumber {
                    messageLabel.text = "You're right!"
                    gameOver()
                } else {
                    starImageViews[life].isHidden = true
                    life -= 1
                    if number > randomNumber {
                        rangeMax = number
                        messageLabel.text = "Too high! (\(rangeMin)~\(rangeMax))"
                    } else {
                        rangeMin = number
                        messageLabel.text = "Too low. (\(rangeMin)~\(rangeMax))"
                    }
                    inputTextField.text = ""
                    if life < 0 {
                        messageLabel.text = "Game over. The number is \(randomNumber)."
                        gameOver()
                    }
                }
            }
        }
    }
    
    func gameOver() {
        // 將按鈕變為Try again樣式
        goButton.setTitle("Try again", for: .normal)
        goButtonWidth.constant = 200
        // 關閉textField輸入功能
        inputTextField.isEnabled = false
    }
    
    func startNewGame() {
        // 將按鈕變為Go樣式
        goButton.setTitle("Go", for: .normal)
        goButtonWidth.constant = 60
        // 清空textField
        inputTextField.text = ""
        inputTextField.isEnabled = true
        // 重設message
        messageLabel.text = "Guess a number between 1~99"
        
        // 隨機產生數字
        randomNumber = Int.random(in: 1...99)
        rangeMin = 1
        rangeMax = 99
        
        // 重設星星數目
        life = 5
        for starImageView in starImageViews {
            starImageView.isHidden = false
        }
    }
    
}

// 限制TextField輸入字串位元數協定
extension GuessNumberViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        // text為目前textField的字串，string為使用者輸入字串，newLength為使用者按下數字後整個字串新的長度
        let newLength = text.count + string.count
        // 當newLength不超過二字元時，回傳true，更新textField字串
        if newLength <= 2 {
            return true
        // 反之若是newLength超過二字元時，則回傳false，無論使用者按了什麼按鈕都不會更新textField
        } else {
            return false
        }
    }
}

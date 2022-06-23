//
//  ViewController.swift


import UIKit
import SpreadsheetView

class SeatSelectionVC: UIViewController, SpreadsheetViewDataSource, SpreadsheetViewDelegate {
    
    
    @IBOutlet weak var vwmain: SpreadsheetView!
    @IBOutlet weak var makePayment: UIButton!
    
    private let spreadsheetView =  SpreadsheetView()

    var theaterData : TheaterModel!
    var movieData: MovieModel!
    var selectedDate: Date!

   
    @IBAction func btnMakePayment(_ sender: UIButton) {
        if let vc = UIStoryboard.main.instantiateViewController(withClass: AddNewCardVC.self) {
            vc.theaterData = self.theaterData
            vc.movieData = self.movieData
            vc.selectedDate = self.selectedDate
            vc.selectedSeats = self.spreadsheetView.indexPathsForSelectedItems
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spreadsheetView.register(HourCell.self, forCellWithReuseIdentifier: HourCell.identifier)
        spreadsheetView.delegate = self
        spreadsheetView.dataSource = self
        spreadsheetView.allowsMultipleSelection = true
        spreadsheetView.gridStyle = .solid(width: 1.0, color: .black)
        self.vwmain.addSubview(spreadsheetView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        spreadsheetView.frame = CGRect(x: 0, y: 50, width: self.vwmain.frame.width, height: self.vwmain.frame.height-80)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        spreadsheetView.flashScrollIndicators()
    }
    
    func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int {
        return Int(theaterData.row) ?? 0
    }
    
    func numberOfColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return Int(theaterData.column) ?? 0
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
        40
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow row: Int) -> CGFloat {
        40
    }
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell? {
        let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: "HourCell", for: indexPath) as? HourCell
        cell?.label.backgroundColor  = .green
        return cell
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, didSelectItemAt indexPath: IndexPath) {
        let cell = spreadsheetView.cellForItem(at: indexPath) as? HourCell
        cell?.label.backgroundColor = .red
        print("(C\(indexPath.column) , R\(indexPath.row))")
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, didDeselectItemAt indexPath: IndexPath) {
        let cell = spreadsheetView.cellForItem(at: indexPath) as? HourCell
        cell?.label.backgroundColor = .green
    }
}


class HourCell: Cell {
    
    static let identifier = "HourCell"
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        label.frame = bounds

        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.backgroundColor = UIColor(red: 0.220, green: 0.471, blue: 0.871, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 2

        addSubview(label)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

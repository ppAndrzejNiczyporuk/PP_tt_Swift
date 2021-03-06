//
//  ViewController.swift
//  tt
//
//  Created by programista on 17/04/2019.
//  Copyright © 2019 programista. All rights reserved.
//

import UIKit
import SWXMLHash

protocol ParcelDisplayable: class {
    var parcel: PPParcel? { get set }
}

class ParcelDetailViewController: UIViewController, ParcelDisplayable {
    var parcel: PPParcel?{
        didSet {
            updateParcelInfo()
        }
    }

    @IBOutlet weak var txtStatus: UITextField!
    @IBOutlet weak var labStatus: UILabel!
    @IBOutlet weak var tableViewDetail: UITableView!
    @IBOutlet weak var labRodzajPrzes: UILabel!
    @IBOutlet weak var txtRodzajPrzes: UITextField!
    @IBOutlet weak var txtParcel: UITextField!
    var status = "???"
    var mutableData:NSMutableData = NSMutableData()
    var currentElementName:String = ""
    let komStatus = komunikatStatus
    let pStatus = przesylkaStatus
    let kRP = kodRodzajPrzes
    var zdarzenia : [Zdarzenie]? = nil
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateParcelInfo()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewDetail.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableViewDetail.dataSource = self;
        // Do any additional setup after loading the view.
    }

    func actionCheck() {
        let numOfParcel = txtParcel.text
        let soapMessage = "<soapenv:Envelope xmlns:soapenv='http://schemas.xmlsoap.org/soap/envelope/' xmlns:sled='http://sledzenie.pocztapolska.pl'> <soapenv:Header> <wsse:Security soapenv:mustUnderstand='1' xmlns:wsse='http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd'> <wsse:UsernameToken wsu:Id='UsernameToken-2' xmlns:wsu='http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd'> <wsse:Username>sledzeniepp</wsse:Username> <wsse:Password Type='http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText'>PPSA</wsse:Password> <wsse:Nonce EncodingType='http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary'>X41PkdzntfgpowZsKegMFg==</wsse:Nonce> <wsu:Created>2011-12-08T07:59:28.656Z</wsu:Created> </wsse:UsernameToken></wsse:Security> </soapenv:Header> <soapenv:Body> <sled:sprawdzPrzesylke> <sled:numer>" + (numOfParcel!) + "</sled:numer> </sled:sprawdzPrzesylke> </soapenv:Body> </soapenv:Envelope>"
        //print(soapMessage)
        let urlString = "https://tt.poczta-polska.pl/Sledzenie/services/Sledzenie.SledzenieHttpSoap11Endpoint/"
        let url = URL(string: urlString)
        let theRequest = NSMutableURLRequest(url: url!)
        let msgLength = soapMessage.count
        //: Keep-Alive
        theRequest.addValue("Keep-Alive", forHTTPHeaderField: "Connection")
        theRequest.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        theRequest.addValue(String(msgLength), forHTTPHeaderField: "Content-Length")
        theRequest.addValue("urn:sprawdzPrzesylke", forHTTPHeaderField: "SOAPAction")
        theRequest.addValue("gzip,deflate", forHTTPHeaderField: "Accept-Encoding")
        theRequest.httpMethod = "POST"
        theRequest.httpBody = soapMessage.data(using: String.Encoding.utf8, allowLossyConversion: false)
        let connection = NSURLConnection(request: theRequest as URLRequest, delegate: self, startImmediately: true)
        showToast(message: status)
        connection!.start()
        
        
    }
    func connectionDidFinishLoading(_ connection: NSURLConnection) {
        // tu będzie cała magia <#code#>
//        let xmlParser = XMLParser(data: mutableData as Data)
//        xmlParser.delegate = self
//        xmlParser.parse()
//        xmlParser.shouldResolveExternalEntities = true
//        showToast(message: komStatus[status]!)
        let xml = SWXMLHash.parse(mutableData as Data)
        self.status = xml["soapenv:Envelope"]["soapenv:Body"]["ns:sprawdzPrzesylkeResponse"]["ns:return"]["ax21:status"].element!.text
        let intStatus = Int(self.status)
        if intStatus == 0
        {
         //   NSDictionary xmlDictionary = xml["soapenv:Envelope"]["soapenv:Body"]["ns:sprawdzPrzesylkeResponse"]["ns:return"]["ax21:danePrzesylki"]["ax21:kodRodzPrzes"].element!.text
          
            
            txtRodzajPrzes.text = kRP[xml["soapenv:Envelope"]["soapenv:Body"]["ns:sprawdzPrzesylkeResponse"]["ns:return"]["ax21:danePrzesylki"]["ax21:kodRodzPrzes"].element!.text]
            self.zdarzenia = try! xml["soapenv:Envelope"]["soapenv:Body"]["ns:sprawdzPrzesylkeResponse"]["ns:return"]["ax21:danePrzesylki"]["ax21:zdarzenia"]["ax21:zdarzenie"].value()
            //odwrocenie zdarzeń żeby najnowsze było na górze
            self.zdarzenia = self.zdarzenia?.reversed()
            self.tableViewDetail.reloadData()
            //DispatchQueue.main.async { self.tableViewDetail.reloadData() }
            IBOutletOn()
            showToast(message: "Status Ok")
        }
        else
        {
            IBOutletOff()
            txtStatus.text = pStatus[self.status]
            showToast(message: "Status Bad")
        }
    }
  
    func IBOutletOn()
    {
        //show list & hide status
        labStatus.isHidden = true
        txtStatus.isHidden = true
        tableViewDetail.isHidden = false
        labRodzajPrzes.isHidden = false
        txtRodzajPrzes.isHidden = false
    }
    
    func IBOutletOff()
    {
        //hide list & show status
        labStatus.isHidden = false
        txtStatus.isHidden = false
        tableViewDetail.isHidden = true
        labRodzajPrzes.isHidden = true
        txtRodzajPrzes.isHidden = true
        
    }
    
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }

}

extension ParcelDetailViewController: NSURLConnectionDelegate, NSURLConnectionDataDelegate, UITableViewDataSource {
   
    func connection(_ connection: NSURLConnection, didFailWithError error: Error) {
        let txtSentence = "connection error = \(error)"
        showToast(message: txtSentence)
    }
    
    func connection(_ connection: NSURLConnection, didReceive response: URLResponse) {
        mutableData = NSMutableData()
    }
    func connection(_ connection: NSURLConnection, didReceive data: Data) {
        mutableData.append(data)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if zdarzenia == nil
        {
            return 0
        }
        else
        {
            return zdarzenia!.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cell")
        cell.detailTextLabel?.text = self.zdarzenia![indexPath.item].nazwa + " " + self.zdarzenia![indexPath.item].jednostkaNazwa
        cell.textLabel?.text = self.zdarzenia![indexPath.item].czas
        return cell
    }
}

extension ParcelDetailViewController {
    
    func updateParcelInfo() {
        guard isViewLoaded,
            let parcel = parcel else {
                return
        }
        txtParcel.text = parcel.numer
        actionCheck()
    }
    

}


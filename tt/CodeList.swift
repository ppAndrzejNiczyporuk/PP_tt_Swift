//
//  CodeList.swift
//  tt
//
//  Created by programista on 17/04/2019.
//  Copyright © 2019 programista. All rights reserved.
//

import Foundation
import SWXMLHash

var komunikatStatus:[String:String] =
    ["0":"Ok",
     "-1":"zapytanie o zbyt dużą liczbę przesyłek",
     "-2":"brak uprawnień do sprawdzania wielu przesyłek",
     "-3":"daty podane w wywołaniu są błędne",
     "-99":"inny błąd"]

var przesylkaStatus:[String:String] =
    ["0":"Ok",
     "1":"są inne przesyłki o takim numerze",
     "2":"przesyłka o podanym numerze jest w systemie, ale nie ma zdarzeń w podanym okresie",
     "-1":"w systemie nie ma przesyłki o takim numerze.",
     "-2":"podany numer przesyłki jest błędny",
     "-99":"inny błąd"
]
var  kodRodzajPrzes:[String:String] =
    ["AA"    :    "Paczka pocztowa Atestowa",
     "B"    :    "Pocztex Kurier 48",
     "BPR"    :    "Przesyłka biznesowa PLUS",
     "CCRI"    :    "CCRI (IBRS)",
     "CK"    :    "Cekogram",
     "DA"    :    "Druk adresowy",
     "DB"    :    "Druk bezadresowy",
     "E"    :    "EMS zwykly",
     "E05"    :    "EMS 0,5 Kilo Pack",
     "E1"    :    "EMS Kilo Pack",
     "ED"    :    "EMS Document Pack",
     "EF1"    :    "EMS Full Pack 1",
     "EF2"    :    "EMS Full Pack 2",
     "EK"    :    "Paczka Mini",
     "EL"    :    "E-Przesyłka list",
     "ELB"    :    "E-Przesyłka list pobranie",
     "EM"    :    "EMS Maxi Pack 50",
     "EM_"    :    "EMS Towary",
     "EMS"    :    "EMS - Przesyłka kurierska zagraniczna",
     "EMS1"    :    "EMS Kilo Pack",
     "EMSD"    :    "EMS Document Pack",
     "EP"    :    "E-Przesyłka paczka",
     "EPB"    :    "E-Przesyłka paczka pobranie",
     "EUKPR"    :    "Express Ukraina",
     "EXP"    :    "GLOBAL Expres",
     "G"    :    "Przesyłka gabarytowa ekonomiczna",
     "GPR"    :    "Przesyłka gabarytowa priorytetowa",
     "HPR"    :    "Przesyłka hybrydowa rejestrowana",
     "K"    :    "List zwykły kartowany ekonomiczny",
     "KPR"    :    "List zwykły kartowany priorytetowy",
     "L"    :    "List zwykły ekonomiczny",
     "LB"    :    "Przesyłka pobraniowa ekonomiczna list",
     "LBPR"    :    "Przesyłka pobraniowa priorytetowa list",
     "LD"    :    "List dworcowy",
     "LPR"    :    "List zwykły priorytetowy",
     "LW"    :    "List wartościowy ekonomiczny",
     "LWB"    :    "E-Przesyłka list pobranie",
     "LWPR"    :    "List wartościowy priorytetowy",
     "LWS"    :    "E-Przesyłka list",
     "M"    :    "Worek M",
     "MEK"    :    "Worek specjalny M ekonomiczny",
     "MP"    :    "Multi Paczka Ekonomiczna",
     "MPPR"    :    "Multi Paczka Priorytetowa",
     "MPR"    :    "Worek M priorytetowy",
     "MR"    :    "Worek M polecony ekonomiczny",
     "MREK"    :    "Worek polecony M ekonomiczny",
     "MRPR"    :    "Worek M polecony priorytetowy",
     "N"    :    "Nieokreślony typ",
     "NZNP"    :    "Przesyłka nierejestrowana z numerem",
     "NZNPR"    :    "Przesyłka nierejestrowana z numerem priorytetowa",
     "P"    :    "Paczka pocztowa ekonomiczna",
     "PAK"    :    "Pakiet bez karty",
     "PB"    :    "Przesyłka pobraniowa ekonomiczna paczka",
     "PBPR"    :    "Przesyłka pobraniowa priorytetowa paczka",
     "PD"    :    "Przesyłka dworcowa",
     "PEK"    :    "Paczka pocztowa ekonomiczna",
     "PL"    :    "Paleta",
     "PM"    :    "paczka mała zwykła",
     "PMW"    :    "paczka mała wartościowa",
     "PP"    :    "POCZTEX PROCEDURA",
     "PP1"    :    "POCZTEX PROCEDURA powrotna do DOKu",
     "PP2"    :    "POCZTEX PROCEDURA powrotna do nadawcy",
     "PPL"    :    "Przesyłka paletowa",
     "PPLUS"    :    "Paczka+",
     "PPR"    :    "Paczka pocztowa priorytetowa",
     "PRZPO"    :    "Przekaz pocztowy",
     "PW"    :    "Paczka wartościowa ekonomiczna",
     "PWB"    :    "E-Przesyłka paczka pobranie",
     "PWPR"    :    "Paczka wartościowa priorytetowa",
     "PWS"    :    "E-Przesyłka paczka",
     "PX"    :    "Pocztex - Przesyłka kurierska krajowa",
     "PXF1"    :    "Pocztex Full Pack 1",
     "PXF2"    :    "Pocztex Full Pack 2",
     "PXN"    :    "Pocztex - Przesyłka kurierska krajowa",
     "PXPB"    :    "Pocztex pobranie",
     "R"    :    "List polecony ekonomiczny",
     "RD"    :    "List polecony dworcowy",
     "RPR"    :    "List polecony priorytetowy",
     "S"    :    "Przesyłka umowna monitorowana",
     "SPR"    :    "Przesyłka listowa monitorowana",
     "UK"    :    "Usługa Kurierska",
     "UKPR"    :    "UKPR",
     "UP"    :    "Usługa Pocztowa",
     "WP"    :    "Przesyłka wielopaczkowa",
     "XXXX"    :    "PACZKA"
]

struct Zdarzenie: XMLIndexerDeserializable {
    let jednostkaNazwa: String
    let czas: String
    let nazwa: String
    
    static func deserialize(_ node: XMLIndexer) throws -> Zdarzenie {
        return try Zdarzenie(
            jednostkaNazwa: node["ax21:jednostka"]["ax21:nazwa"].value(),
            czas: node["ax21:czas"].value(),
            nazwa: node["ax21:nazwa"].value()
        )
    }
}

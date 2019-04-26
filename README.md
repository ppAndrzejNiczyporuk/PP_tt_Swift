# PP_tt_Swift
Poczta Polska śledzenie w Swift 

Opis poprawnego Envelop wpisanego w kodzie 

<soapenv:Header>
 <wsse:Security
 soapenv:mustUnderstand='1'
 xmlns:wsse='http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd'>
 <wsse:UsernameToken wsu:Id='UsernameToken-2'
 xmlns:wsu='http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd'>
 <wsse:Username>sledzeniepp</wsse:Username>
 <wsse:Password
 Type='http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText'>PPSA</wsse:Password>
 <wsse:Nonce
 EncodingType='http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary'>X41PkdzntfgpowZsKegMFg==</wsse:Nonce>
 <wsu:Created>2011-12-08T07:59:28.656Z</wsu:Created>
 </wsse:UsernameToken>
 </wsse:Security>
</soapenv:Header>
 

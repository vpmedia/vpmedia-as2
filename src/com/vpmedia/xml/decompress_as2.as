**-----------------------------------------------------------------------------
*	This method has been overridden to check for
	compressed data. If found, the data is decompressed
	and then parsed with (native) parseXML. If no
	compressed data is found, parsing commences immediately.
------------------------------------------------------------------------------*/
private function onData( inData:String ) : Void {
 
 	if (inData != undefined) {
  
  		var i:String = inData;
  
  		// compressed data found, decompress...
  		// direct copy of source at http://www.strille.net/tutorials/FlashXMLCompressor/
  		// except for strict typing of variables and slight optimization of for..loop
  		if (i.charAt(0) != '<') {
   
   			var ecPos:Number = i.indexOf(" ")+1;
   			var eC:String = i.charAt(ecPos);
   			i = i.substr(ecPos+1);
   			var o:String = "";
   			var iL:Number = i.length;
   			var n:Number = 0;
   			for ( n = 0; n < iL; ++n) {
    
    				if (i.charAt(n) == eC) {
     					var p = i.charCodeAt(n+1)*114 + i.charCodeAt(n+2) - 1610;
     					var l = i.charCodeAt(n+3)-14;
     					o += o.substr(-p, l);
     					n += 3;
     				} else {
     					o += i.charAt(n);
     				}
    			}
   
   			// decompression done, parse xml
   			parseXML(o);
   
   		} else {
   
   			// normal XML file found, parse it right away
   			parseXML(i);
   		}
  
  		// trigger onLoad with true result
  		onLoad(true);
  
  	} else {
  
  		// trigger onLoad with false result
  		onLoad(false);
  
  	}
}
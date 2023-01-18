/**
* SWFHistory - part fo the Bumpslide Library
* requires Geoff Stearns' SWFObject
* @author David Knape
*/
var SWFHistory = new Object();
SWFHistory.connId = Math.floor(Math.random() * 100000).toString(16);
if(this!=top) top.SWFHistory = SWFHistory;

SWFHistory.embed = function (debug) {	
	if(debug!==true) debug = false;
	// make sure they have flash
	if(deconcept.SWFObjectUtil.getPlayerVersion().major<6) return; 
	var height = debug ? 22 : 0;
	var stateVars = document.location.search.slice(1);
	document.write( '<iframe  name="swfhistory" id="swfhistory" src="swfhistory.html?'+stateVars+'" frameborder="0" scrolling="no" width="100%" height="'+height+'"></iframe>');
}


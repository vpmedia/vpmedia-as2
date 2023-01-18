import com.bumpslide.util.Debug;
/**
* Manages communication with main SWF in SWFHistory Framework
* 
* SWFHistory is the Bumpslide browser history tracking implementation.
* This class should be instantiated from within a swf that will be embedded
* as the the swfhistory.swf.
* 
* You can build a SWF to perform this function by using an MTASC command line
* similar to the one below.  A compiled version should be found in 
* the bumpslide examples directory under swfhistory.
* 
* @mtasc -swf com/bumpslide/example/history/build/swfhistory.swf -header 500:22:12:333333 -main
* @author David Knape
*/

class com.bumpslide.data.HistorySwf
{	
	static public function main( my_mc:MovieClip ) 
	{
		// init history swf with connection ID and state info pulled from flashVars
		var h = new HistorySwf(my_mc);
		
		// pull connection id and statevars from url
		h.init( _root.connId, _root.stateVars );		
	}
	
	var controllerConnId:String;
	var serializedStateInfo:String;	
	var listener:LocalConnection;
	var sender:LocalConnection;
	var mMc:MovieClip;
	
	static var LC_READYCHECK : String = 'swfhistory_ready';
	static var LC_CONTROL : String = 'swfhistory_control';
	
	function HistorySwf(mc:MovieClip) {
		
		Stage.scaleMode = "noScale";
		Stage.align="TL";
		
		mMc = mc;
		mMc.createTextField('debug_txt', 99974, 0, 0, 300, 100);
		mMc.debug_txt.setNewTextFormat( new TextFormat('Verdana', 10, 0xffffff) );
		mMc.debug_txt.autoSize = true;
	}
	
	function init(connId, stateVars) 
	{				
		mMc.debug_txt.text = 'lc_id: '+_root.connId + ',  stateVars: '+stateVars;
		if(stateVars==undefined || stateVars=='undefined') stateVars = '';
		
		debug('Connection ID: '+_root.connId );
				
		controllerConnId = LC_CONTROL+connId;
		serializedStateInfo = stateVars;
		
		// setup listener for callback
		listener = new LocalConnection();
		listener.allowDomain = function(domain){ return true; }
		listener.scope = this;		
		listener.readyCheck = function () { 
			this.scope.debug('ReadyCheck Event Received');
			this.scope.sendHistoryNavEvent(); 
		}
		listener.connect(LC_READYCHECK+connId);
		
		// send state info to main swf	
		sender = new LocalConnection();
		if(!sendHistoryNavEvent()) {
			debug('Initial send failed, waiting for ReadyCheck Event.');
		}		
	}
	
	function sendHistoryNavEvent() : Boolean 
	{
		debug('Sending: '+serializedStateInfo);
		return sender.send(controllerConnId, "historyNavTo", serializedStateInfo);
	}
	
	function debug(s) {
		com.bumpslide.util.Debug.trace('[HistorySWF] '+s);
	}
}
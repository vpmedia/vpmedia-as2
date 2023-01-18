//////////////////////////////////////////////////
//FCComponent is a class which takes care of
//all repetitive features of a flashcom component
//////////////////////////////////////////////////
import NetConnection;
import NetStream;
import SharedObject;
import mx.flashcom.core.gFlashcom;
//[Event("netStatus")]
//[Event("disconect")]
[Event("callFailed")]
[Event("connectAppShutdown")]
[Event("connectClosed")]
[Event("connectFailed")]
[Event("connectInvalidApp")]
[Event("connectRejected")]
[Event("connectSuccess")]
class mx.flashcom.core.FCComponent
{
	private var __name:String;//Temporary Value for Prefix
	private var __prefix:String;//Call Prefix for server calls and unique object naming
	private var __base:Object;//Base FC Component
	private var __nc:NetConnection;//NetConnection
	private var __fc_class:String;//FC Class Name
	private var __statusCount:Number = 0;//NetConnection Status counter
	private var __historyObject:Object = new Object();
	public var gFlashCom;
	function FCComponent() {
		if(_global.gFlashcom == null){
			__historyObject.instanceOfOneOffCode = false;
		}
		gFlashCom = new gFlashcom();
	}
	function init(netC,fc_class, from) {
		//Called in component 'connect' function
		//netC as the net connection object
		//fc_class as the class name and server class name (should be the same)
		//from is the called from object used for dispatching events
		__name = (from._name == null ? "_DEFAULT_" : from._name);
		if(typeof(from) == "string"){
			__name = from;
		}
		__prefix =  fc_class+"."+__name+".";
		from.nc = netC;
		if (netC[fc_class] == null) {
			netC[fc_class] = {};
		}
		///////////////////////////////////
		//Enables calls directally to the component with a server prefix of Class/instance/method
		var netComp = netC[fc_class];
		netComp[from._name] = from;
		var __parent = this;
		///////////////////////////////////////////////
		netC.onStatus = function(info:Object){
			//Seperate the status object and dispatch it as an event
			var stub:Array=info.code.split(".");
			stub[1] = stub[1].toLowerCase();
			info.type=stub[1]+stub[2];
			info.target=from;
			from.dispatchEvent(info);
			if(__parent.__statusCount == 0 && __parent.__historyObject.acepted != true){
				if(info.code == "NetConnection.Connect.Success"){
					from.acceptConnection();
					__parent.__historyObject.acepted = true;
				}
			}
			__parent.__statusCount++;
		}
		__base = from;
		__nc = netC;
		__fc_class = fc_class;
		if(__statusCount == 0 && netC.isConnected == true){
			from.acceptConnection();
			__historyObject.acepted = true;
		}
		if(!netC.receiveLocalPush){
			netC.receiveLocalPush = function(property, value){
				_global.gFlashcom[property] = value;
			}
		}
		if(!netC.receiveLocalEvent){
			netC.receiveLocalEvent = function(eventData){
				_global.gFlashcom.dispatchEvent(eventData);
			}
		}
	}
	public function call(){
		//Get params sent and add the call prefix to the call method
		arguments[0] = __prefix+arguments[0];
		__nc.call.apply(__nc,arguments);
	}
	public function close(){
		//Close the NC object relating to this component
		__nc[__fc_class] = null;
	}
	function get prefix():String
	{
		//Return the call prefix
		return __prefix;
	}
	function get NetConnection():NetConnection
	{
		//Return the netConnection object
		return __nc;
	}
	function set NetConnection(newNc:NetConnection)
	{
		init(newNc,__fc_class,__base);
	}
	function get isConnected():Boolean
	{
		//Return the status of the netConnection
		return __nc.isConnected;
	}
	function get uri():String
	{
		//Return the netConnection uri
		return __nc.uri;
	}
}
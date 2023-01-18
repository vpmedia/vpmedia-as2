import mx.flashcom.core.FCComponent;
//
class mx.flashcom.core.ClientContainer
{
	//Net connection
	private var __nc:NetConnection;
	//Shared object which receives all the data calls
	private var __so:SharedObject;
	//FCComponent instance
	private var FCClientContainer:FCComponent;
	//the owner object, it should have the onNewClient, onLostClient, onUpdate methods
	private var __instance:Object;
	//Instance name of the owner
	private var op:String;
	//Users that have been dealt with
	private var handledID:Object;
	//
	function ClientContainer(inst:Object){
		__instance = inst;
		op = __instance._name;
		//
		handledID = new Object();
	}
	function connect(nc:NetConnection, user_data:Object){
		__nc = nc;
		FCClientContainer = new FCComponent();
		FCClientContainer.init(nc, "ClientContainer", op);
		__so = SharedObject.getRemote(FCClientContainer.prefix + "cm",nc.uri,false);
		var __parent = this;
		__so.newUser = function(id:Number, data:Object){
			if(!__parent.handledID[id]){
				__parent.handledID[id] = true;
				__parent.__instance.onNewClient(id, data);
			}
		}
		__so.lostUser = function(id:Number){
			__parent.__instance.onLostClient(id);
		}
		__so.update = function(id:Number, prop:Object, val:Object){
			__parent.__instance.onUpdate(id, prop, val);
		}
		__so.connect(nc);
		nc[FCClientContainer.prefix + "getInit"] = function(data:Object){
			for(var i:String in data){
				if(!__parent.handledID[i]){
					__parent.handledID[i] = true;
					__parent.__instance.onNewClient(i, data[i]);
				}
			}
		}
		//
		if(user_data)
		{
			FCClientContainer.call("connect", null, user_data);
		}
	}
	public function setProperty(prop:String, val:String)
	{
		FCClientContainer.call("changeProperty", null, prop, val, true);
	}
}
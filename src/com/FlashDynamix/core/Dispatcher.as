import com.FlashDynamix.events.Event;
//
class com.FlashDynamix.core.Dispatcher {
	/**
	@ignore
	*/
	private var bObj:Object;
	/**
	@ignore
	*/
	private var lObj:Object;
	//
	public function Dispatcher() {
		lObj = new Object();
		bObj = new Object();
		AsBroadcaster.initialize(bObj);
	}
	public function removeListeners() {
		for (var item in lObj) {
			removeListener(item);
		}
		lObj = new Object();
	}
	/**
	* Subscribes an event listener object to the component
	*/
	public function addListener(t:String, e:Object) {
		//
		var lo:Object = new Object();
		lo[t] = e[t];
		bObj.addListener(lo);
		//
		lObj[t] = lo;
	}
	/**
	* Adds a listener to the class
	*/
	public function addListeners(e:Object) {
		for (var item in e) {
			addListener(item, e);
		}
	}
	/**
	* Removes a specific listener from the class
	*/
	public function removeListener(t:String) {
		bObj.removeListener(lObj[t]);
		delete lObj[t];
	}
	/**
	* Dispatches a named event to subsribed listeners
	*/
	public function dispatchEvent(e:Event) {
		bObj.broadcastMessage(e.name, e.value);
	}
}
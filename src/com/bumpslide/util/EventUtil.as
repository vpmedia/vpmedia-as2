class com.bumpslide.util.EventUtil
{
	private function EventUtil(){};
	
	static function getListeners( dispatcher:Object, eventName:String ) {
		return dispatcher["__q_" + eventName];
	}
	
}

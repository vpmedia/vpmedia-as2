/*
created by Satori Canton
(c) 2005 ActionScript.com
*/
import com.actionscript.SatoriArray;
class com.actionscript.AScomponent extends MovieClip {
	
	private var _listenerArray:SatoriArray;
	
	function AScomponent() {
		this._listenerArray = new SatoriArray();
	}
	
	public function addListener(o:Object):Number{
		var l = this._listenerArray.length;
		while(l--) {
			if(this._listenerArray[l] == o) {
				return this._listenerArray.length;
			}		
		}
		return this._listenerArray.push(o);
		
	}
	public function removeListener(o:Object):Void {
		var l = this._listenerArray.length;
		while(l--) {
			if(this._listenerArray[l] == o) {
				this._listenerArray.pull(l);
			}
		}
	}
	
	private function broadcastEvent(s:String):Void {
		var l = this._listenerArray.length;
		while(l--){
			this._listenerArray[l][s](this);
		}
	}
}
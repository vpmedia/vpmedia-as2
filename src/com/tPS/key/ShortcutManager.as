/**
* Shortcut Manager
* @author tPS
* @version 1
*/
class com.tPS.key.ShortcutManager extends com.tPS.event.AeventSource{
	private var shortcuts:Array;
	private var pressedKeys:Array;
	
	function ShortcutManager(){
		setup();
	}
	
	private function setup():Void{
		Key.addListener(this);
		init();
	}
	
	private function init():Void{
		shortcuts = [];
		pressedKeys = [];
	}
	
	
	private function onKeyDown():Void{
		if(insertUnique(Key.getCode())){
			var scIndex:Number = isShortcut();
			if(scIndex>-1){
				broadcastMessage("onShortcut",scIndex);
			}
		}
	}
	
	private function onKeyUp(){
		pressedKeys = [];
	}
	
	private function insertUnique():Boolean{
		var toInsert:Boolean = true;
		var i:Number = pressedKeys.length;
		while(--i > -1){
			if(pressedKeys[i] == arguments[0]){
				toInsert = false;
				break;
			}
		}
		pressedKeys.push(arguments[0]);
		return toInsert;
	}

	private function isShortcut():Number{
		var isSc:Number = -1;
		var i:Number = shortcuts.length;
		while(--i > -1){
			var iscut:Number = 0;
			var j:Number = -1;
			while(++j < shortcuts[i].length){
				if(Key.isDown(shortcuts[i][j])){
					iscut ++;
				}
			}
			if(iscut == shortcuts[i].length){
				isSc = i;
				break;
			}
		}
		return isSc;
	}
	
	function registerSC($key1:Number,$key2:Number,$key3:Number):Void{
		shortcuts.push(arguments);
	}
	
}

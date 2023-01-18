/**
* @author Patrick Matte
* last revision January 30th 2006
*/

class com.blitzagency.ui.BasicButton extends com.blitzagency.ui.UIObject {

	public var onDragOverEvent:Function;
	public var onDragOutEvent:Function;
	public var onRollOverEvent:Function;
	public var onRollOutEvent:Function;
	public var onPressEvent:Function;
	public var onReleaseEvent:Function;
	public var onReleaseOutsideEvent:Function;
	public var onLoadEvent:Function;
	public var onEnableEvent:Function;
	public var onDisableEvent:Function;
	public var onSelectEvent:Function;
	public var onDeselectEvent:Function;
	public var isEnabled:Boolean = true;
	private var hitzone:MovieClip;
	
	public function BasicButton(){
		super();
		hitzone = this;
	}
	
	private function onLoad():Void{
		enabled = isEnabled;
		onLoadEvent();
		dispatchEvent({type:"onLoad",target:this});
	}
		
	public function onButtonDragOver():Void{
		onDragOverEvent();
		dispatchEvent({type:"onDragOver",target:this});
	}
	
	public function onButtonDragOut():Void{
		onDragOutEvent();
		dispatchEvent({type:"onDragOut",target:this});
	}
	
	public function onButtonRollOver():Void{
		onRollOverEvent();
		dispatchEvent({type:"onRollOver",target:this});
	}
	
	public function onButtonRollOut():Void{
		onRollOutEvent();
		dispatchEvent({type:"onRollOut",target:this});
	}
	
	public function onButtonPress():Void{
		onPressEvent();
		dispatchEvent({type:"onPress",target:this});
	}
	
	public function onButtonRelease():Void{
		onReleaseEvent();
		dispatchEvent({type:"onRelease",target:this});
	}
	
	public function onButtonReleaseOutside():Void{
		onReleaseOutsideEvent();
		dispatchEvent({type:"onReleaseOutside",target:this});
	}
	
	public function set handCursor(value:Boolean):Void{
		this.useHandCursor = value;
	}

	public function set enabled(value:Boolean):Void{
		if(value){
			hitzone.onRollOver = onButtonRollOver;
			hitzone.onRollOut = onButtonRollOut;
			hitzone.onPress = onButtonPress;
			hitzone.onRelease = onButtonRelease;
			hitzone.onReleaseOutside = onButtonReleaseOutside;
			hitzone.onDragOver = onButtonDragOver;
			hitzone.onDragOut = onButtonDragOut;
			onEnableEvent();
		}else{
			delete hitzone.onRollOver;
			delete hitzone.onRollOut;
			delete hitzone.onPress;
			delete hitzone.onRelease;
			delete hitzone.onReleaseOutside;
			delete hitzone.onDragOver;
			delete hitzone.onDragOut;
			onDisableEvent();
		}
	}
		
	public function set selected(value:Boolean):Void{
		if(value){
			enabled = false;
			onSelectEvent();
		}else{
			enabled = true;
			onDeselectEvent();
		}
	}
	
}
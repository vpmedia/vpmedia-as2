import net.manaca.lang.event.Event;

/**
 * 
 * @author Wersling
 * @version 1.0, 2006-5-15
 */
class net.manaca.lang.event.ButtonEvent extends Event {
	private var className : String = "net.manaca.lang.event.ButtonEvent";
	/** 在复选框上单击（松开）鼠标时，或者如果复选框具有焦点并按下空格键时触发。 */
	static public var CLICK:String =	"click";
	/** 当在按钮上单击鼠标按钮，然后将鼠标指针拖动到按钮之外时 */
	static public var DRAG_OUT:String =	"dragOut";
	
	/** 当用户在按钮外部按下鼠标按钮，然后将鼠标指针拖动到按钮之上时 */
	static public var DRAG_OVER:String = 	"dragOver";
	
	/** 当按钮具有键盘焦点而且按下某按键时调用 */
	static public var KEY_DOWN:String = 	"keyDown";
	
	/** 当按钮具有输入焦点而且释放某按键时调用 */
	static public var KEY_UP:String = 	"keyUp";
	
	/** 当按下按钮时调用 */
	static public var PRESS:String = 	"press";
	
	/** 当释放按钮时调用 */
	static public var RELEASE:String = 	"release";
	
	/** 在这样的情况下调用：在鼠标指针位于按钮内部的情况下按下按钮，然后将鼠标指针移到该按钮外部并释放鼠标按钮 */
	static public var RELEASE_OUT_SIDE:String = 	"releaseOutside";
	
	/** 当鼠标指针移至按钮区域之外时调用 */
	static public var ROLL_OUT:String = 	"rollOut";
	
	/** 当鼠标指针移过按钮区域时调用 */
	static public var ROLL_OVER:String = 	"rollOver";
	
	public function ButtonEvent(type : String, value, target : Object) {
		super(type, value, target);
	}

}
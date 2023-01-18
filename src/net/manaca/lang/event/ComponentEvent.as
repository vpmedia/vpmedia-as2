import net.manaca.lang.event.Event;

/**
 * 组件的事件
 * @author Wersling
 * @version 1.0, 2006-4-30
 */
class net.manaca.lang.event.ComponentEvent extends Event {
	private var className : String = "net.manaca.lang.event.ComponentEvent";
	static public var onRelease:String =	"onRelease";
	static public var onPress:String = 	"onPress";
	static public var onRollOver:String = 	"onRollOver";
	static public var onRollOut:String = 	"onRollOut";
	static public var onReleaseOutside:String = 	"onReleaseOutside";
	public function ComponentEvent(type : String, value, target : Object) {
		super(type, value, target);
	}

}
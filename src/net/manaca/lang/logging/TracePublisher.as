//import net.manaca.data.concurrent.StringUtil;
import net.manaca.lang.logging.IPublisher;
import net.manaca.lang.logging.LogEvent;
import net.manaca.util.StringUtil;

/**
 * Trace放式发布
 * @author Wersling
 * @version 1.0, 2005-10-22
 */
class net.manaca.lang.logging.TracePublisher implements IPublisher {
	private var className : String = "wersling.log.TracePublisher";
	private var _maxDepth : Number;

	private var inProgress : Array;
	/**
	 * 构造函数
	 * @param 无
	 */
	public function TracePublisher() {
		maxDepth = 4;
	}
	/**
	 * 发布信息
	 * @param e 一个LogEvent对象
	 */
	public function publish(e : LogEvent) : Void {
		inProgress = new Array();
		var arg:Object = e.argument;
		var txt:String = "[" + e.level.getName() + "]";
		txt += " : ";
		//txt += analyzeObj(arg,1);
		txt += arg.toString();
		trace(txt);
	}
	public function toString():String
	{
		return className;
	}
	private function analyzeObj(o,depth:Number):String {
		var txt:String = "";
		var typeOf:String = typeof(o);
		if(typeOf == "string") {
			// STRING
			txt += "\"" + o + "\"";
		} else if(typeOf == "boolean" || typeOf == "number") {
			// BOOLEAN / NUMBER
			txt += o;
		} else if(typeOf == "undefined" || typeOf == "null") {
			// UNDEFINED / NULL
			txt += "("+typeOf+")";
		} else {
			// OBJECT
			var stringifyObj:Boolean = false;
			var analize:Boolean = true;
			if(o instanceof Array) {
				// ARRAY
				typeOf = "array";
				stringifyObj = false;
			} else if(o instanceof Button) {
				// BUTTON
				typeOf = "button";
				stringifyObj = true;
			} else if(o instanceof Date) {
				// DATE
				typeOf = "date";
				analize = false;
				stringifyObj = true;
			} else if(o instanceof Color) {
				// COLOR
				typeOf = "color";
				analize = false;
				stringifyObj = true;
				o = o.getRGB().toString(16);
			} else if(o instanceof MovieClip) {
				// MOVIECLIP
				typeOf = "movieclip";
				stringifyObj = true;
			} else if(o instanceof XML) {
				// XML
				typeOf = "xml";
				analize = false;
				stringifyObj = true;
			} else if(o instanceof XMLNode) {
				// XML
				typeOf = "xmlnode";
				analize = false;
				stringifyObj = true;
			} else if(o instanceof Sound) {
				// SOUND
				typeOf = "sound";
			} else if(o instanceof TextField) {
				typeOf = "textfield";
				stringifyObj = true;
			} else if(o instanceof Function) {
				typeOf = "function";
				analize = false;
			}
			txt += "(" ;
			if(stringifyObj) txt += typeOf + " " + o;
			else if(typeOf == "object") txt += o;
			else if(typeOf == "array") txt += typeOf + ":" + o.length;
			else txt += typeOf;
			txt += ")";
			
			// detect cross-reference
			for (var i=0; i<inProgress.length; i++) {
				if (inProgress[i] == o) return txt + ": **cross-reference**";
			}
			inProgress.push(o);
			
			if(analize && depth <= _maxDepth) {
				var txtProps = "";
				if(typeOf == "array") {
					for(var i:Number=0; i<o.length; i++) {
						txtProps += "\n" +
						StringUtil.multiply( "\t", (depth+1) ) +
						i + ":" +
						analyzeObj(o[i], (depth+1) );
					}
				} else {
					for(var prop in o) {
						txtProps += "\n" +
							StringUtil.multiply( "\t", (depth+1) ) +
							prop + ":" +
							analyzeObj(o[prop], (depth+1) );
					}
				}
				if(txtProps.length > 0) txt += " {" + txtProps + "\n" + StringUtil.multiply( "\t", depth ) + "}";
			}
			
			inProgress.pop();
		}
		return txt;
	}
	
	/**
	 * 信息输出最底级别
	 * @param  value 参数类型：Number 
	 * @return 返回值类型：Number 
	 */
	public function set maxDepth ( value:Number) :Void
	{
		_maxDepth=  value;
	}
	public function get maxDepth() :Number
	{
		return _maxDepth;
	}
}
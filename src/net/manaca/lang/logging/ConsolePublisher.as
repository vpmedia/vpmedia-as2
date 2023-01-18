import net.manaca.lang.logging.IPublisher;
import net.manaca.lang.logging.LogEvent;
import net.manaca.lang.logging.PropertyInspector;
/**
 * 发送到服务端测试 
 * @author Wersling
 * @version 1.0, 2005-10-23
 */
class net.manaca.lang.logging.ConsolePublisher implements IPublisher {
	private var className : String = "wersling.log.ConsolePublisher";
	private var _version:Number=0.15;
	private var _maxDepth:Number;
	private var _showFunctions:Boolean=false;
	private var _inProgressObjs:Array;
	private var _inProgressSerial:Array;
	/**
	 * 构造函数
	 * @param 无
	 */
	public function ConsolePublisher() {
		maxDepth = 4;
		
	}
	/**
	 * 发布信息
	 * @param e 一个LogEvent对象
	 */
	public function publish(e:LogEvent):Void {
		_inProgressObjs = new Array();
		_inProgressSerial = new Array();
		var o:Object = LogEvent.serialize(e);
		o.argument = serializeObj(o.argument,1);
		o.version = _version;
		//var tp:TracePublisher = new TracePublisher();
		//tp.publish(LogEvent.deserialize(o));
		var lc = new LocalConnection();
		lc.send("_luminicbox_log_console", "log", o);
	}
	private function serializeObj(o,depth:Number):Object {
		var serial:Object = new Object();
		var type:Object = getType(o);
		serial.type = type.name;
		//可以直接显示的
		if(!type.inspectable) {
			serial.value = o;
		} else if(type.stringify) {//XML
			serial.value = o.toString();
		} else {
			var items:Array = new Array();
			serial.value = items;
			// add target if possible
			if(type.name == "movieclip" || type.name == "button" || type.name == "object" || type.name == "textfield") serial.id = ""+o;
			// detect recursion
			for (var i=0; i<_inProgressObjs.length; i++) {
				if(_inProgressObjs[i] == o) {
					// cross-reference detected
					var refSerial:Object = _inProgressSerial[i];
					var newSerial:Object = {value:refSerial.value,type:refSerial.type,crossRef:true};
					if(refSerial.id) newSerial.id = refSerial.id;
					return newSerial;
				}
			}
			_inProgressObjs.push(o);
			_inProgressSerial.push(serial);
			// validate current depth
			if(depth <= _maxDepth) {
				if(type.properties) {
					// inspect built-in properties
					var props = new Object();
					for(var i:Number=0; i<type.properties.length; i++) {
						props[type.properties[i]] = o[type.properties[i]];
					}
					props = serializeObj(props, _maxDepth);
					props.type = "properties";
					items.push( {property:"$properties",value:props } );
				}
				// serialize fields
				if(o instanceof Array) {
					// array fields
					for(var pos:Number=0; pos<o.length; pos++) items.push( {property:pos,value:serializeObj( o[pos], (depth+1) )} );
				} else {
					// object fields
					for(var prop:String in o) {
						if( !(o[prop] instanceof Function && !_showFunctions) ) {
							// avoid inspecting built-in properties again
							var serialize = true;
							if(type.properties) {
								for(var i:Number=0; i<type.properties.length; i++) {
									if(prop == type.properties[i]) serialize = false;
								}
							}
							if(serialize) items.push( {property:prop,value:serializeObj( o[prop], (depth+1) )} );
						}
					}
				}
			} else {
				// max depth reached
				serial.reachLimit =true;
			}
			_inProgressObjs.pop();
			_inProgressSerial.pop();
		}
		return serial;
	}
	/**
	 * 分析数据类型
	 */
	private function getType(o):Object {
		var typeOf = typeof(o);
		var type:Object = new Object();
		type.inspectable = true;
		type.name = typeOf;
		if(typeOf == "string" || typeOf == "boolean" || typeOf == "number" || typeOf == "undefined" || typeOf == "null") {
			type.inspectable = false;
		} else if(o instanceof Date) {
			type.inspectable = false;
			type.name = "date";
		} else if(o instanceof Array) {
			type.name = "array";
		} else if(o instanceof Button) {
			type.name = "button";
			type.properties = PropertyInspector.buttonProperties;
		} else if(o instanceof MovieClip) {
			type.name = "movieclip";
			type.properties = PropertyInspector.movieClipProperties;
		} else if(o instanceof XML) {
			type.name = "xml";
			type.stringify = true;
		} else if(o instanceof XMLNode) {
			type.name = "xmlnode";
			type.stringify = true;
		} else if(o instanceof Color) {
			type.name = "color";
		} else if(o instanceof Sound) {
			type.name = "sound";
			type.properties = PropertyInspector.soundProperties;
		} else if(o instanceof TextField) {
			type.name = "textfield";
			type.properties = PropertyInspector.textFieldProperties;
		}
		return type;
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
	public function set showFunctions(value:Boolean) { _showFunctions = value; }
	public function get showFunctions():Boolean { return _showFunctions; }
	public function toString() : String {
		return className;
	}
	
}
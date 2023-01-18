import com.code4net.system.SmartCallback;

class com.code4net.XML.ParserXML extends XML{
	private var _object:Object;
	private var _i:Number;
	private var sc:SmartCallback;
	
	public function ParserXML() {
		init.apply(this, arguments);
	}

	public function init (obj:Object,_sc:SmartCallback) {
		_i = new Number(0);
		_object = obj;
		sc = _sc;
		ignoreWhite = true;
	}
	
	public function onLoad (success:Boolean) {
		if(success) {
			_i = 0;
			parse(firstChild,_object);
		}else{
			trace("error parsing");
			sc.run(false);
		}
	}
	private function parse (xml2parse:Object,obj:Object) {
		var currentNode:Object = xml2parse;
		var iterator:Object;
		
		_i++;
		
		if (currentNode.hasChildNodes()) {
			currentNode = currentNode.firstChild;
			do {
				var ref:Array;
				var k:Number;
				
				if (obj[currentNode.nodeName] == undefined) {
						obj[currentNode.nodeName] = new Object();
						ref = obj[currentNode.nodeName];
						
						ref.attributes = currentNode.attributes;
						
						if(currentNode.firstChild.nodeType == 3) {
							ref.data = currentNode.firstChild.nodeValue;
							continue;
						}
				} else {
					if (obj[currentNode.nodeName].__proto__ != Array.prototype) {
						var tmp:Object = obj[currentNode.nodeName];
						obj[currentNode.nodeName] = new Array();
						k = obj[currentNode.nodeName].push(tmp);
					}else{
						k = obj[currentNode.nodeName].push();
					}

					ref = obj[currentNode.nodeName][k] = new Array();
				}
				parse(currentNode,ref);
			}while(currentNode = currentNode.nextSibling);
		}
		
		if(!Boolean(--_i)) sc.run(true);
	}
}

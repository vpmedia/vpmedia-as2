
/**
 * com.sekati.services.AmbientOrb
 * @version 1.0.5
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
/**
 * Ambient Orb developer channel controller class
 * {@code Usage:
 * var orb:AmbientOrb = new AmbientOrb("AAA-BBB-CCC");
 * orb.config ( getColorByProp("name","red"), getAnimByProp("name","heartbeat"), "Orb Test" );
 * }
 * @see <a href="http://www.ambientdevices.com/developer/Tech%20FAQ.html">http://www.ambientdevices.com/developer/Tech%20FAQ.html</a>
 */
class com.sekati.services.AmbientOrb {

	private var _devId:String;
	private static var _URI:String = "http://myambient.com:8080/java/my_devices/submitdata.jsp";	
	private static var _SPECTRUM:Array = [ {id:"0", hex:"0xFF0000", name:"red"}, 
								 {id:"1", hex:"0xFF2B00", name:"light red"}, 
								 {id:"2", hex:"0xFF5500", name:"dark orange"}, 
								 {id:"3", hex:"0xFF8000", name:"orange"}, 
								 {id:"4", hex:"0xFFAA00", name:"light orange"}, 
								 {id:"5", hex:"0xFFD500", name:"dark yellow"}, 
								 {id:"6", hex:"0xFFFF00", name:"yellow"}, 
								 {id:"7", hex:"0xD4FF00", name:"lime green"}, 
								 {id:"8", hex:"0xAAFF00", name:"pale green"}, 
								 {id:"9", hex:"0x80FF00", name:"green -3"}, 
								 {id:"10", hex:"0x55FF00", name:"green -2"}, 
								 {id:"11", hex:"0x2BFF00", name:"green -1"}, 
								 {id:"12", hex:"0x00FF00", name:"green"}, 
								 {id:"13", hex:"0x00FF2A", name:"green +1"}, 
								 {id:"14", hex:"0x00FF55", name:"green +2"}, 
								 {id:"15", hex:"0x00FF80", name:"pale aqua"}, 
								 {id:"16", hex:"0x00FFAA", name:"aqua"}, 
								 {id:"17", hex:"0x00FFD4", name:"dark aqua"}, 
								 {id:"18", hex:"0x00FFFF", name:"cyan"}, 
								 {id:"19", hex:"0x00D4FF", name:"dark cyan"}, 
								 {id:"20", hex:"0x00AAFF", name:"light blue"}, 
								 {id:"21", hex:"0x0080FF", name:"sky blue"}, 
								 {id:"22", hex:"0x0055FF", name:"blue -2"}, 
								 {id:"23", hex:"0x002AFF", name:"blue -1"}, 
								 {id:"24", hex:"0x0000FF", name:"blue"}, 
								 {id:"25", hex:"0x2A00FF", name:"deep blue"}, 
								 {id:"26", hex:"0x5500FF", name:"very deep blue"}, 
								 {id:"27", hex:"0x8000FF", name:"violet"}, 
								 {id:"28", hex:"0xAA00FF", name:"purple"}, 
								 {id:"29", hex:"0xD500FF", name:"light purple"}, 
								 {id:"30", hex:"0xFF00FF", name:"magenta"}, 
								 {id:"31", hex:"0xFF00D5", name:"magenta +1"}, 
								 {id:"32", hex:"0xFF00AA", name:"magenta +2"}, 
								 {id:"33", hex:"0xFF0080", name:"magenta +3"}, 
								 {id:"34", hex:"0xFF0055", name:"magenta +4"}, 
								 {id:"35", hex:"0xFF002B", name:"magenta +5"}, 
								 {id:"36", hex:"0xFFFFFF", name:"white"} ];
	private static var _ANIM:Array = [ {id:"0", name:"none"}, 
							 {id:"1", name:"very slow"}, 
							 {id:"2", name:"slow"}, 
							 {id:"3", name:"medium slow"}, 
							 {id:"4", name:"medium"}, 
							 {id:"5", name:"medium fast"}, 
							 {id:"6", name:"fast"}, 
							 {id:"7", name:"very fast"}, 
							 {id:"8", name:"crescendo"}, 
							 {id:"9", name:"heartbeat"} ];
	private static var _CODE:Array = [ {id:"0", type:"OK", desc:"data inserted OK"}, 
							 {id:"1", type:"error", desc:"'color' term not defined. Must be number between 0 - 36."}, 
							 {id:"2", type:"error", desc:"error parsing 'color' term. Must be number between 0 - 36."}, 
							 {id:"3", type:"error", desc:"'color' value out of range. . Must be number between 0 - 36."}, 
							 {id:"4", type:"warning", desc:"'anim' term not defined. Must be number between 0 - 9. Assuming 'none'."}, 
							 {id:"5", type:"error", desc:"error parsing 'anim' term. Must be number between 0 - 9."}, 
							 {id:"6", type:"error", desc:"'anim' value out of range. . Must be number between 0 - 9."}, 
							 {id:"7", type:"error", desc:"The term 'devID' was not specified."}, 
							 {id:"8", type:"error", desc:"The specified devID is not a premium account."}, 
							 {id:"9", type:"warning", desc:"The specified devID is not set to the developer channel."}, 
							 {id:"10", type:"error", desc:"The specified devID is not in the Ambient database."}, 
							 {id:"11", type:"warning", desc:"The comment contains invalid characters. Ignoring comment."}, 
							 {id:"12", type:"error", desc:"Unspecific error"}, 
							 {id:"13", type:"error", desc:"You are not authorized to submit data to this account (not yet implemented)"} ];

	/**
	 * Constructor
	 * @param devId (String) - orb device id to be controlled by this instance
	 * @return Void
	 */
	public function AmbientOrb(devId:String) {
		_devId = devId;
	}

	/**
	 * devId setter
	 * @param (String) instance device Id
	 * @return Void
	 */
	public function set devId(devId:String):Void {
		if (devId) {
			_devId = devId;
		}
	}

	/**
	 * devId getter
	 * @return String - instance device id
	 */
	public function get devId():String {
		return _devId;	
	}

	/**
	 * spectrum getter
	 */
	public function get spectrum():Array {
		return _SPECTRUM;
	}

	/**
	 * anim getter
	 */
	public function get anim():Array {
		return _ANIM;
	}

	/**
	 * server code getter
	 */
	public function get code():Array {
		return _CODE;
	}		

	/**
	 * locate a color object by one of its properties
	 * @param prop (String) - acceptable props: "id", "hex", "name"
	 * @param key (String) - value to match by, e.g: "0xFF00FF"
	 * @return Object - the matched _SPECTRUM object
	 * @throws Error on failed match
	 */
	public function getColorByProp(prop:String,key:String):Object {
		for (var i:Number = 0; i < _SPECTRUM.length ; i++) {
			var o:Object = _SPECTRUM[i];
			if(o[prop].toUpperCase( ) == key.toUpperCase( )) {
				return o;	
			}
		}
		throw new Error( "@@@ com.sekati.services.AmbientOrb Error: could not find match for " + prop + ": " + key );
	}

	/**
	 * locate an animation by one of its properties
	 * @param prop (String) - acceptable props: "id", "name"
	 * @param key (String) - value to match by, e.g: "slow"
	 * @return Object - the matched _ANIM object
	 * @throws Error on failed match
	 */
	public function getAnimByProp(prop:String,key:String):Object {
		for (var i:Number = 0; i < _ANIM.length ; i++) {
			var o:Object = _ANIM[i];
			if(o[prop].toUpperCase( ) == key.toUpperCase( )) {
				return o;	
			}
		}
		throw new Error( "@@@ com.sekati.services.AmbientOrb Error: could not find match for " + prop + ": " + key );		
	}

	/**
	 * locate a server code by one of its properties
	 * @param prop (String) - acceptable props: "id", "desc"
	 * @param key (String) - value to match by, e.g: "Unspecific error"
	 * @return Object - the matched _CODE object
	 * @throws Error on failed match
	 */
	 
	public function getCodeByProp(prop:String,key:String):Object {
		for (var i:Number = 0; i < _CODE.length ; i++) {
			var o:Object = _CODE[i];
			if(o[prop].toUpperCase( ) == key.toUpperCase( )) {
				return o;	
			}
		}
		throw new Error( "@@@ com.sekati.services.AmbientOrb Error: could not find match for " + prop + ": " + key );		
	}

	/**
	 * send new configuration to the ambient orb device id
	 * @param colorId (String)
	 * @param animId (String)
	 * @param comment (String)
	 * @return Void
	 * @throws Error if instance device id, colorId,animId params have not been set
	 * {@code Usage:
	 * orb.config ( getColorByProp("name","red"), getAnimByProp("name","heartbeat"), "Orb Test" );
	 * }
	 */
	public function config(colorId:String, animId:String, comment:String):Void {
		if (!_devId) {
			throw new Error( "@@@ com.sekati.services.AmbientOrb Error: Device ID not set" );
			return;
		}
		if (!colorId) {
			throw new Error( "@@@ com.sekati.services.AmbientOrb Error: invalid config colorId arg" );
			return;
		}
		if (!animId) {
			throw new Error( "@@@ com.sekati.services.AmbientOrb Error: invalid config animId arg" );
			return;
		}
		if (!comment) {
			comment = "com.sekati.services.AmbientOrb";
		}
		var xm:XML = new XML( );
		xm.ignoreWhite = true;
		var query:String = _URI + "?devID=" + _devId + "&anim=" + animId + "&color=" + colorId + "&comment=" + escape( comment );
		trace( "query string: " + query );
		xm.onLoad = function (success:Boolean):Void {
			var xObj:Object = xparse( xm );
			trace( "object returned: " + xObj );
		};
		xm.load( query );
	}

	/**
	 * xml parser
	 */
	private function xparse(n:XML):Object {
		var o:String = new String( n.firstChild.nodeValue ), s:Object, i:Number, t:Object;
		for (s = (o == "null") ? n.firstChild : n.childNodes[1]; s != null ; s = s.nextSibling) {
			t = s.childNodes.length > 0 ? arguments.callee( s ) : new String( s.nodeValue );
			if (s.firstChild.nodeValue != undefined) {
				t.val = s.firstChild.nodeValue;
			}
			for (i in s.attributes) {
				t[i] = s.attributes[i];
			}
			if (o[s.nodeName] != undefined) {
				if (!(o[s.nodeName] instanceof Array)) {
					o[s.nodeName] = [ o[s.nodeName] ];
				}
				o[s.nodeName].push( t );
			} else {
				o[s.nodeName] = t;
			}
		}
		return o;
	}
}
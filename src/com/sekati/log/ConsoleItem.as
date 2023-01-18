/**
 * com.sekati.log.ConsoleItem
 * @version 1.1.3
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */

import com.sekati.display.BaseClip;
import com.sekati.log.ConsoleStyle;
import com.sekati.utils.Delegate;

/**
 * Console Item UI
 * {@code Usage:
 * 	var meta:MovieClip = ClassUtils.createEmptyMovieClip (com.sekati.log.ConsoleItem, this, "consoleMetaItem", {_x:5, _y:5, _isMeta:true});
 *	var data0:Object = {id:0, type:"status", origin:"_level0", message:"Generic status report.", benchmark:0.3339};
 * 	var c0:MovieClip = ClassUtils.createEmptyMovieClip (com.sekati.log.ConsoleItem, this, "consoleItem0", {_x:5, _y:21, _data:data0});
 * }
 * @see {@link com.sekati.log.Console}
 */
class com.sekati.log.ConsoleItem extends BaseClip {

	// data = {id:Number, type:String, origin:String, message:String, benchmark:Number, _isMeta:Boolean}
	public var _data:Object;
	private var _cs:ConsoleStyle;
	private var _style:Object;
	public var _bg:MovieClip;
	public var _line:MovieClip;
	public var _idTf:TextField;
	public var _typeTf:TextField;
	public var _originTf:TextField;
	public var _messageTf:TextField;
	public var _benchmarkTf:TextField;

	/**
	 * ConsoleItem Constructor.
	 */
	public function ConsoleItem() {	
		//trace("ConsoleItem: "+_this._name+".__RUID = "+_this.__RUID+";");
		_cs = ConsoleStyle.getInstance( );
		_style = (!_data._isMeta) ? _cs.CSS.item : _cs.CSS.meta_item;
		
		// rect	- createStyledRect (target:MovieClip, layout:Object, color:Object)
		_bg = _cs.createStyledRectangle( _this, _style.bg );
		_line = _cs.createStyledRectangle( _this, _style.line );
		
		// text - createStyledTextField (target:MovieClip, layout:Object, color:Object, str:String)
		_idTf = _cs.createStyledTextField( _this, _style.textfields.id, _data.id );
		_typeTf = _cs.createStyledTextField( _this, _style.textfields.type, _data.type );
		_originTf = _cs.createStyledTextField( _this, _style.textfields.origin, _data.origin );
		_messageTf = _cs.createStyledTextField( _this, _style.textfields.message, _data.message );
		_benchmarkTf = _cs.createStyledTextField( _this, _style.textfields.benchmark, _data.benchmark );
		
		// alignments
		//_bg._height = _messageTf._height;
		//_line._y = _messageTf._height;
		var tallestTf:TextField = (_messageTf._height > _originTf._height) ? _messageTf : _originTf;
		_bg._height = tallestTf._height;
		_line._y = tallestTf._height;	
				
		// event
		_bg.onPress = Delegate.create( _this, toClipboard );
		//_bg.useHandCursor = false;		
	}

	/**
	 * Copy string data to clipboard.
	 * @return Void
	 */	
	private function toClipboard():Void {
		System.setClipboard( toString( ) );
	}

	/**
	 * Return ConsoleItem string data 
	 * @return String
	 */
	public function toString():String {
		var tab:String = "\t";
		var str:String = _idTf.text + tab + _typeTf.text + tab + _originTf.text + tab + _messageTf.text + tab + _benchmarkTf.text;
		return str;		
	}

	/**
	 * calls superclasses BaseClip.destroy and executes its own destroy behaviors.
	 * @return Void
	 */
	public function destroy():Void {
		super.destroy( );
		//trace(_this._name+" ConsoleItem destroy()");
	}	
}
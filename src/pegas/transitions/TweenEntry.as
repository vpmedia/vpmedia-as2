/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is PEGAS Framework.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

import vegas.core.CoreObject;
import vegas.core.ICloneable;

/**
 * A basic TweenEntry used in the Tween class to fill this model.
 * @author eKameleon
 */
class pegas.transitions.TweenEntry extends CoreObject implements ICloneable
{
	
	/**
	 * Creates a new TweenEntry instance.
	 */	
	public function TweenEntry(p:String, e:Function, b:Number, f:Number) 
	{
		begin = b ;
		setEasing(e) ;
		finish = f ;
		prop = p ;
	}

	/**
	 * Defined the begin value.
	 */
	public var begin:Number ;

	public function get easing():Function 
	{
		return getEasing() ;
	}
	
	public function set easing( f:Function ):Void 
	{
		setEasing(f) ;
	}

	/**
	 * (read-write) Returns the finish value.
	 * @return the finish value.
	 */
	public function get finish():Number 
	{
		return getFinish() ;
	}
	
	/**
	 * (read-write) Sets the finish value.
	 */
	public function set finish(n:Number):Void 
	{
		setFinish(n) ;
	}

	public var isCached:Boolean ;

	public var prevPos:Number ;

	public var prop:String ;

	public function clone() 
	{
		var t:TweenEntry = new TweenEntry (prop, getEasing(), begin, finish);
		return t ;
	}

	public function getChange():Number 
	{
		return _change ;	
	}

	public function getEasing():Function 
	{
		return _easing ;	
	}

	public function getFinish():Number 
	{
		return _finish ;
	}
	
	public function getPosition(t:Number , d:Number):Number 
	{
		var f:Function = _easing ;
		return f( t, begin, getChange() , d ) ;
	}
	
	static public function noEasing(t:Number, b:Number, c:Number, d:Number):Number 
	{
		return c*t/d + b;
	}
	
	public function setEasing( e:Function ):Void 
	{
		_easing	= e || TweenEntry.noEasing ;
	}
	
	public function setFinish(n:Number):Void 
	{
		_finish = n ;
		_setChange(n) ;
	}
	
	public function setPosition(value:Number):Number 
	{
		prevPos = _pos ;
		_pos = value ;
		return value ;
	}
	
	public function toString():String 
	{
		return "[TweenEntry" + (prop ? (":" + prop) : "") + "]" ;
	}

	private var _change:Number ;
	private var _easing:Function = TweenEntry.noEasing ;
	private var _finish:Number ;
	private var _pos ;
	
	private function _setChange(n:Number):Void 
	{
		var c:Number = n - begin ;
		_change = isNaN(c) ? 0 : c ;
	}

}
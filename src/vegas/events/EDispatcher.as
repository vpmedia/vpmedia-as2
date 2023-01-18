/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is Vegas Framework.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

import vegas.events.Delegate;
import vegas.util.Mixin;

/**
 * The old event model of VEGAS inspired by the <a href='http://livedocs.macromedia.com/flash/mx2004/main_7_2/wwhelp/wwhimpl/common/html/wwhelp.htm?context=Flash_MX_2004&file=00003105.html'>mx.events.EventDispatcher</a> in the V2 components framework and inspired by the <a href='http://www.gskinner.com/blog/archives/000027.html>GDispatcher</a> class of Grant Skinner.
 * <p>This event model is depreciated, used {@code EventDispatcher} class in VEGAS please.</p>
 * @author eKameleon
 * @see IDispatcher interface to creates concrete EDispatcher implementations.
 * @see FastDispatcher
 * @see EventDispatcher
 * @see vegas.events.type package with all core class with the IDispatcher implementation and the EDispatcher mixin.
 */
class vegas.events.EDispatcher 
{
	
	/**
	 * Launch the mixin of the specified target object. 
	 * Injected in this object the methods addEventListener, dispatchEvent, eventListenerExists, removeAllEventListeners, removeEventListener and dispatchEvent.
	 * @see Mixin  
	 */
	static public function initialize ( target ):Void 
	{
		var attributes:Array = 
		[
			"addEventListener" , "dispatchEvent", "eventListenerExists" ,
			"removeAllEventListeners" , "removeEventListener" , "updateEvent" 
		] ;
		var mix:Mixin = new Mixin( EDispatcher, target, attributes ) ; 
		mix.run() ;
	}
	
	static public function dispatch( target, a:Array , ev ):Void 
	{
		for (var each:String in a) 
		{
			var item = a[each] ;
			var o = item.o ;
			var f = item.f ;
			var tof:String = typeof(o) ;
			if (tof == "object" || tof == "movieclip") 
			{
				if (f instanceof Function) 
				{
					Delegate.create(o, f)(ev) ;
				}
				else if (o["handleEvent"] && !f) 
				{
					o["handleEvent"](ev) ;
				}
				else 
				{
					if (f == undefined) f = ev.type ;
					if (typeof(f) == "string") 
					{
						o[f].apply(o, [ev]) ;
					}
				}
			} 
			else  // function 
			{
				o.apply(target, [ev]) ;
			}
		}	
	}
	
	static public function indexOf( a:Array, o , f):Number 
	{
		var l:Number = a.length ;
		while (--l > -1) 
		{
			var item = a[l] ;
			if (item.o == o && item.f == f) return l ; 
		}
		return -1;
	}
	
	/**
	 * Returns the string representation of this singleton.
	 * @return the string representation of this singleton.
	 */
	static public function toString() : String 
	{
		return "[EDispatcher]";
	}
	
	private var _listeners ;
	
	private function addEventListener( eventName:String, obj, func ):Void 
	{
		if (!eventName) return ;
		if (!_listeners) _listeners = {} ;
		var a:Array = _listeners[eventName] ;
		if (!a) _listeners[eventName] = a = [] ;
		if (EDispatcher.indexOf( a , obj , func) == -1) 
		{
			a.push({ o:obj , f:func }) ;
		}
	}
	
	private function dispatchEvent(ev):Void 
	{
		if (ev.type == "ALL") return ;
		var a:Array ; 
		if (ev.target == undefined) ev.target = this ;
		this[ev.type + "_handler"](ev) ;
		a = _listeners[ev.type] ;
		if (a) EDispatcher.dispatch(ev.target, a, ev) ;
		a = _listeners["ALL"] ;
		if (a) EDispatcher.dispatch(ev.target, a, ev) ;
	}
	
	private function eventListenerExists(eventName:String, obj , func):Boolean 
	{
		var a:Array = _listeners[eventName] ;
		return (EDispatcher.indexOf(a, obj, func)  > -1) ;
	}

	private function removeAllEventListeners(eventName:String):Void 
	{
		if (eventName) delete _listeners[eventName] ;
		else delete _listeners ;
	}

	private function removeEventListener( eventName:String, obj , func):Void 
	{
		var a:Array = _listeners[eventName] ;
		if (!a) return ;
		var id:Number = EDispatcher.indexOf(a, obj, func) ;
		if (id > -1) a.splice(id, 1) ;
	}
	
	private function updateEvent(eventName:String, oInit):Void 
	{
		var ev = { 	type:eventName, target:this } ;
		if ( oInit != undefined ) for (var each:String in oInit) ev[each] = oInit[each] ;
		dispatchEvent( ev ) ;
	}
	
}

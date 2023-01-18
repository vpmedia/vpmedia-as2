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

// TODO continueTo()
// TODO yoyo()
// TODO Optimiser les tweens car pour le moment c'est TROP LENT !!!

import pegas.transitions.Motion;
import pegas.transitions.TweenEntry;
import pegas.transitions.TweenProvider;

/**
 * The Tween class lets you use ActionScript to move, resize, and fade movie clips easily on the Stage by specifying a property of the target movie clip to be tween animated over a number of frames or seconds.
 * The Tween class also lets you specify a variety of easing methods.
 * <p>Easing refers to gradual acceleration or deceleration during an animation, which helps your animations appear more realistic.</p>
 * <p><b>Example :</b></p>
 * {@code
 * import asgard.process.ActionEvent ;
 * import asgard.transitions.Tween ;
 * import asgard.transitions.easing.* ;
 * 
 * import vegas.events.Delegate ;
 * import vegas.events.EventListener ;
 * 
 * var onDebug:Function = function(ev:ActionEvent):Void
 * {
 *     trace (":: debug -> " + ev.type + " : " + ev.target ) ;
 * }
 * 
 * var debug:EventListener = new Delegate(this, onDebug) ;
 * 
 * var tw:Tween = new Tween (mc, "_x", Elastic.easeOut, mc._x, 400, 2, true, true) ;
 * tw.addEventListener("ALL", debug) ;
 * }
 * @author eKameleon
 */
class pegas.transitions.Tween extends Motion 
{

	/**
	 * Creates a new Tween instance.
	 * <p><b>Usage :</b></p>
	 * {@code
	 * var tw:Tween = new Tween( obj, prop:String, e:Function, b:Number, f:Number, d:Number , u:Boolean, auto:Boolean) ;
	 * var tw:Tween = new Tween( obj, ar:Array ) ;
	 * }
	 */
	function Tween( args ) 
	{
		var obj = arguments[0] ;
		if (obj) 
		{
			setTarget(obj) ;
		}
		else 
		{
			return ;
		}
		var l:Number = arguments.length ;
		if (l == 2 && arguments[1] instanceof Array) 
		{
			setTweenProvider(arguments[1]) ;
		} 
		else if (l > 2) 
		{
			var p:String = arguments[1] ; // property
			var e:Function = arguments[2] ; // easing
			var b:Number = arguments[3] ; // begin
			var f:Number = arguments[4] ; // finish
			var d:Number = arguments[5] ; // duration
			var u:Boolean = arguments[6] ; // useSeconds
			var a:Boolean = arguments[7] ; // auto start
			setDuration(d) ;
			useSeconds = u ;
			setTweenProvider( [new TweenEntry(p, e, b, f)] ) ;
			if (a) run() ;
		}
	}

	/**
	 * (read-write) Returns the model of this Tween object.
	 * @return the model of this Tween object.
	 */
	public function get tweenProvider():TweenProvider 
	{
		return getTweenProvider() ;
	}

	/**
	 * (read-write) Sets the model of this Tween object.
	 */
	public function set tweenProvider( o ):Void 
	{
		setTweenProvider(o) ;
	}

	/**
	 * Removes all entries in the model of this Tween object.
	 */
	public function clear():Void 
	{
		if (running) this.stop() ;
		if (_model) _model.clear() ;
		notifyCleared() ;
	}

	/**
	 * Returns a shallow copy of this Tween object.
	 * @return a shallow copy of this Tween object.
	 */
	/*override*/ public function clone() 
	{
		var t:Tween = new Tween() ;
		t.setTarget(getTarget()) ;
		t.duration = getDuration() ;
		t.useSeconds = useSeconds ;
		if (size() > 0) t.setTweenProvider(getTweenProvider().clone()) ;
		return t ;
	}

	/**
	 * Returns the TweenProvider model reference of this Tween object.
	 * @return the TweenProvider model reference of this Tween object.
	 */
	public function getTweenProvider():TweenProvider 
	{
		return _model ;
	}
	
	/**
	 * Inserts a TweenEnry in the model of the Tween object.
	 * @param entry a TweenEntry reference.
	 */
	public function insert( entry:TweenEntry ):Void 
	{
		if (!_model) setTweenProvider() ;
		_model.insert( entry ) ;
	}

	/**
	 * Inserts a new property in the Tween object.
	 * @param prop the string representation of the number property.
	 * @param easing the easing method used by the Tween on this property.
	 * @param begin the begin value.
	 * @param finish the finish value.
	 * @return a TweenEntry defined by the specified arguments.
	 */
	public function insertProperty( prop , easing:Function, begin:Number, finish:Number):TweenEntry 
	{
		var e:TweenEntry = new TweenEntry(prop, easing, begin, finish) ;
		insert(e) ;
		return e ;
	}

	/**
	 * Remove a TweenEntry in the Tween Object.
	 */
	public function remove(o:TweenEntry):Void 
	{
		if (running) stop() ;
		_model.remove(o) ;
	}	
	
	/**
	 * Remove a property in the Tween Object.
	 */
	public function removeProperty(prop:String):Boolean 
	{
		if (running) stop() ;
		return _model.remove(prop) ;
	}

	/**
	 * Sets the model of this Tween object.
	 */
	public function setTweenProvider(o):Void 
	{
		if (o instanceof TweenProvider) 
		{
			_model = o ;
		}
		else if (o instanceof Array) 
		{
			_model = new TweenProvider(o) ;
		}
		else 
		{
			_model = new TweenProvider() ;
		}
	}
	
	/**
	 * The numbers of elements(properties) in the model of this Tween.
	 */
	public function size():Number 
	{
		return _model.size() ;
	}
	
	/**
	 * Update the current Tween in the time.
	 */
	/*override*/ public function update():Void 
	{
		var o = _target ;
		var t:Number = _time ;
		var d:Number = _duration ;
		var a:Array = _model.toArray() ;
		var l:Number = a.length ;
		while(--l > -1) 
		{
			var e:TweenEntry = a[l] ;
			o[e.prop] = e.setPosition( e.getPosition(t, d) ) ;
			updateAfterEvent() ;
		}
		notifyChanged() ;
	}
	
	private var _model:TweenProvider ;

}
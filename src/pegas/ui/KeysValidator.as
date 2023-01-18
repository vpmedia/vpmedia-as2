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

import vegas.core.IValidator;
import vegas.data.iterator.Iterator;
import vegas.data.set.HashSet;
import vegas.events.AbstractCoreEventDispatcher;
import vegas.events.ValidatorEvent;

/**
 * Set a collection of keys to validate an action.
 * <p><b>Example :</b></p>
 * {@code
 * import vegas.events.Delegate ;
 * import vegas.events.EventListener ;
 * import vegas.events.ValidatorEvent ;
 * 
 * import pegas.ui.Keyboard ;
 * import pegas.ui.KeysValidator ;
 * 
 * var onDebug:Function = function (ev:ValidatorEvent):Void
 * {
 *     trace ( this + " : " + ev.type ) ;
 * }
 * 
 * var debug:EventListener = new Delegate(this, onDebug) ;
 * 
 * var code_F:Number = Keyboard.getCharCode("f") ;
 * 
 * trace ("code F key : " + code_F) ;
 * trace ("code CTRL key : " + Keyboard.CONTROL) ;
 * 
 * var validator:KeysValidator = new KeysValidator() ;
 * validator.addEventListener(ValidatorEvent.VALID, debug) ;
 * validator.addEventListener(ValidatorEvent.INVALID, debug) ;
 * 
 * validator.codePolicy = KeysValidator.ASCII ; // ASCII or CODE
 *
 * validator.insert( Keyboard.CONTROL ) ;
 * validator.insert(code_F) ;
 * 
 * trace ("count keys : " + validator.countKeys()) ;
 * 
 * // Disabled Shortcuts in the flashplayer to test this example !
 * 
 * }
 * @author eKameleon
 * @see pegas.ui.Keyboard (key manager with F1..F12, etc. key codes)
 */
class pegas.ui.KeysValidator extends AbstractCoreEventDispatcher implements IValidator 
{
	
	/**
	 * Creates a new KeysValidator instance.
	 * @param keys An array of key codes to initialize the validator.
	 * @param bGlobal the flag to use a global event flow or a local event flow.
	 * @param sChannel the name of the global event flow if the {@code bGlobal} argument is {@code true}.
	 */
	public function KeysValidator( keys:Array ,bGlobal:Boolean , sChannel:String ) 
	{
		_cp  = KeysValidator.CODE ;
		_set = new HashSet( keys ) ;
		_reset() ;
		enabled = true ;
	}

	/**
	 * Indicates the code policy when the validator use the Key.getCode() method.
	 */
	static public var CODE:Number = 0 ;

	/**
	 * Indicates the code policy when the validator use the Key.ASCII() method.
	 */
	static public var ASCII:Number = 1 ;
	
	static private var __ASPF__ = _global.ASSetPropFlags(KeysValidator, null, 7, 7) ;
	
	/**
	 * Switch the validate process of this validator to use the {@code Key.getCode()} or the {@code Key.getASCII()} method.
	 * This virtual property value is KeysValidator.CODE (0) ou KeysValidator.ASCII (1).
	 * The default value of this property is KeysValidator.CODE (0).
	 */
	public function get codePolicy():Number 
	{
		return _cp ;
	}

	/**
	 * Switch the validate process of this validator to use the {@code Key.getCode()} or the {@code Key.getASCII()} method.
	 * This virtual property value is KeysValidator.CODE (0) ou KeysValidator.ASCII (1).
	 * The default value of this property is KeysValidator.CODE (0).
	 */
	public function set codePolicy(n:Number):Void 
	{
		setCodePolicy(n) ;
	}
	
	/**
	 * Indicates if the validator is active (true) or not (false).
	 */
	public function get enabled():Boolean
	{
		return _enabled ;	
	}
	
	/**
	 * Indicates if the validator is active (true) or not (false).
	 */
	public function set enabled(b:Boolean):Void
	{
		_enabled = b ;
		if( _enabled ) 
		{
			Key.addListener(this) ;
		}
		else
		{
			Key.removeListener(this) ;	
		}	
	}
	
	/**
	 * Clear all elements in this key validator.
	 */
	public function clear():Void 
	{
		_set.clear() ;
	}
	
	/**
	 * Returns the number of key codes in the internal collection of this validator.
	 * @return the number of key codes in the internal collection of this validator.
	 */
	public function countKeys():Number 
	{
		return _set.size() ;
	}
	
	/**
	 * Inserts a new keyCode in the internal {@code Set} of this validator if it is not already present..
	 */
	public function insert(keyCode:Number):Boolean 
	{
		var b:Boolean = _set.insert(keyCode) ;
		if (b) _reset() ;
		return b ;
	}
	
	/**
	 * Removes the specified key code in the validator if it's exist.
	 */
	public function remove(keyCode:Number):Boolean 
	{
		var b:Boolean = _set.remove(keyCode) ;
		if (b) _reset() ;
		return b ;
	}
	
	/**
	 * Sets and Switch the validate process of this validator to use the {@code Key.getCode()} or the {@code Key.getASCII()} method.
	 * This virtual property value is KeysValidator.CODE (0) ou KeysValidator.ASCII (1).
	 * The default value of this property is KeysValidator.CODE (0).
	 */
	public function setCodePolicy(code:Number):Void 
	{
		_cp = code ;
	}
	
	/**
	 * Returns {@code true} if the passed-in value is support by the validator.
	 * @return {@code true} if the passed-in value is support by the validator.
	 */
	public function supports(value):Boolean 
	{
		return _it.next() == value ;
	}

	/**
	 * Returns an Array representation of all key codes in this validator.
	 * @return an Array representation of all key codes in this validator.
	 */
	public function toArray():Array
	{
		return _set.toArray() ;
	}
	
	/**
	 * Validates the specified value in argument.
	 */	
	public function validate(value):Void 
	{
		if ( supports(value) ) 
		{
			if (!_it.hasNext()) 
			{
				_reset() ;
				dispatchEvent(new ValidatorEvent( ValidatorEvent.VALID, this)) ;
			}
		} 
		else 
		{
			_reset() ;
			dispatchEvent( new ValidatorEvent( ValidatorEvent.INVALID, this) ) ;
		}
	}
	
	private var _cp:Number ;

	/**
	 * The enabled flag of this validator.
	 */
	private var _enabled:Boolean ;
	
	/**
	 * The internal {@code Set} of this validator.
	 */
	private var _set:HashSet ;
	
	/**
	 * The internal iterator of this validator.
	 */
	private var _it:Iterator ;
	
	/**
	 * Reset the validator iterator.
	 */
	private function _reset():Void 
	{
		_it = _set.iterator() ;
	}
	
	/**
	 * Invoqued when the key is down.
	 */
	private function onKeyDown():Void 
	{
		var code:Number ;
		if (_cp == KeysValidator.ASCII) 
		{
			code = Key.getAscii() ;
			if (code == 0 || code == undefined ) 
			{
				code = Key.getCode() ;
			}
		} 
		else 
		{
			code = Key.getCode() ;
		}
		validate(code) ;
	}
	
	/**
	 * Invoqued when the keys are up.
	 */
	private function onKeyUp():Void 
	{
		_reset() ;
	}

}
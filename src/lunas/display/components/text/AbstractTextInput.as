/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is LunAS Library.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

import lunas.display.components.text.AbstractTextArea;
import lunas.display.group.TextInputGroup;

import pegas.events.FocusEvent;

import vegas.events.Delegate;

/**
 * This class simplify the implementation of the TextInput components.
 * @author eKameleon
 */
class lunas.display.components.text.AbstractTextInput extends AbstractTextArea 
{

	/**
	 * The abstract constructor to creates TextInput concrete class.
	 */
	private function AbstractTextInput() 
	{ 
		
		super() ;
		
		_eFocusIn = new FocusEvent(FocusEvent.FOCUS_IN, this) ;
		_eFocusOut = new FocusEvent(FocusEvent.FOCUS_OUT, this) ;
		
		field.onKillFocus = Delegate.create(this, notifyFocusOut) ;
		field.onSetFocus = Delegate.create(this, notifyFocusIn) ;
		
	}

	/**
	 * (read-write) Returns the maximum number of characters that the text field can contain. 
	 * A script may insert more text than the maxChars property allows; this property indicates only how much text a user can enter. 
	 * If this property is null, there is no limit to the amount of text a user can enter. The default value is null.
	 * @return the maximum number of characters that the text field can contain. 
	 */
	public function get maxChars():Number 
	{ 
		return getMaxChars() ; 
	}

	/**
	 * (read-write) Sets the maximum number of characters that the text field can contain. 
	 * A script may insert more text than the maxChars property allows; this property indicates only how much text a user can enter. 
	 * If this property is null, there is no limit to the amount of text a user can enter. The default value is null.
	 */
	public function set maxChars(n:Number):Void 
	{ 
		setMaxChars(n); 
	}

	/**
	 * (read-write) Returns a Boolean value indicating whether the text field is a password field (true) or not (false).
	 * @return a Boolean value indicating whether the text field is a password field (true) or not (false).
	 */
	public function get password():Boolean 
	{ 
		return getPassword(); 
	}

	/**
	 * (read-write) Sets a Boolean value indicating whether the text field is a password field (true) or not (false).
	 */
	public function set password(b:Boolean):Void 
	{ 
		setPassword(b); 
	}

	/**
	 * (read-write) Returns a Boolean value indicating whether the text field is a priority field (true) or not (false).
	 * @return a Boolean value indicating whether the text field is a priority field (true) or not (false).
	 */
	public function get priority():Boolean 
	{ 
		return getPriority(); 
	}

	/**
	 * (read-write) Sets a Boolean value indicating whether the text field is a priority field (true) or not (false).
	 */
	public function set priority(bool:Boolean):Void 
	{ 
		setPriority(bool); 
	}

	/**
	 * (read-write) Returns the set of characters that a user can enter in the text field.
	 * @return the set of characters that a user can enter in the text field.
	 */
	public function get restrict():String 
	{ 
		return getRestrict(); 
	}

	/**
	 * (read-write) Indicates the set of characters that a user can enter in the text field. 
	 * The default value is undefined. If this property is null or an empty string (""), a user can enter any character. If this property is a string of characters, the user can enter only characters in the string; the string is scanned from left to right. You can specify a range by using a dash (-).
	 * @see TextField
	 */
	public function set restrict(s:String):Void 
	{ 
		setRestrict(s); 
	}
	
	/**
	 * Returns the input field reference.
	 */
	public function getInputField():TextField 
	{
		return field ;
	}	
	
	/**
	 * Returns the maximum number of characters that the text field can contain. 
	 * A script may insert more text than the maxChars property allows; this property indicates only how much text a user can enter. 
	 * If this property is null, there is no limit to the amount of text a user can enter. The default value is null.
	 * @return the maximum number of characters that the text field can contain. 
	 */
	public function getMaxChars():Number 
	{ 
		return field.maxChars ; 
	}
	
	/**
	 * Returns a Boolean value indicating whether the text field is a password field (true) or not (false).
	 * @return a Boolean value indicating whether the text field is a password field (true) or not (false).
	 */
	public function getPassword():Boolean 
	{ 
		return field.password ; 
	}

	/**
	 * Returns a Boolean value indicating whether the text field is a priority field (true) or not (false).
	 * @return a Boolean value indicating whether the text field is a priority field (true) or not (false).
	 */
	public function getPriority():Boolean 
	{ 
		return _priority ; 
	}

	/**
	 * Returns the set of characters that a user can enter in the text field.
	 * @return the set of characters that a user can enter in the text field.
	 */
	public function getRestrict():String 
	{ 
		return field.restrict ;
	}
	
	/**
	 * This method is invoqued when the group or the groupName property are changed.
	 * The user can group all TextInput in a form and enable or disable all component if their are in the same group.
	 */
	/*override*/ public function groupPolicyChanged():Void 
	{
		TextInputGroup.getInstance().setGroupName( getGroupName(), this) ;
	}

	/**
	 * Notify the focus in of this component.
	 */
	public function notifyFocusIn( oldFocus ):Void 
	{
		_eFocusIn.relatedObject = oldFocus ;
		dispatchEvent(_eFocusIn) ;
	}

	/**
	 * Notify the focus out of this component.
	 */
	public function notifyFocusOut( newFocus ):Void 
	{
		_eFocusIn.relatedObject = newFocus ;
		dispatchEvent(_eFocusOut) ;
	}

	/**
	 * Sets the maximum number of characters that the text field can contain. 
	 * A script may insert more text than the maxChars property allows; this property indicates only how much text a user can enter. 
	 * If this property is null, there is no limit to the amount of text a user can enter. The default value is null.
	 */
	public function setMaxChars(n:Number):Void 
	{ 
		field.maxChars = n ; 
	}

	/**
	 * Sets a Boolean value indicating whether the text field is a password field (true) or not (false).
	 */
	public function setPassword(b:Boolean):Void 
	{ 
		field.password = b ; 
	}

	/**
	 * Sets a Boolean value indicating whether the text field is a priority field (true) or not (false).
	 */
	public function setPriority(bool:Boolean):Void 
	{ 
		_priority = bool ;
		update() ;
	}

	/**
	 * Indicates the set of characters that a user can enter in the text field. 
	 * The default value is undefined. If this property is null or an empty string (""), a user can enter any character. If this property is a string of characters, the user can enter only characters in the string; the string is scanned from left to right. You can specify a range by using a dash (-).
	 * @see TextField
	 */
	public function setRestrict(s:String):Void 
	{ 
		field.restrict = s ;
	}

	/**
	 * The event when the component is focus in.
	 */
	private var _eFocusIn:FocusEvent ;
	
	/**
	 * The event when the component is focus out.
	 */
	private var _eFocusOut:FocusEvent ;
	
	/**
	 * The priority value of the component.
	 */
	private var _priority:Boolean = false ;
	
}


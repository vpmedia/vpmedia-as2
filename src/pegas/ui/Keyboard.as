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

import vegas.core.types.Char;

/**
 * The Keyboard class is used to build an interface that can be controlled by a user with a standard keyboard. 
 * You can use the methods and properties of the Keyboard class without using a constructor. 
 * The properties of the Keyboard class are constants representing the keys that are most commonly used to control applications. 
 * @author eKameleon
 */
class pegas.ui.Keyboard 
{

	/**
	 * Constant associated with the key code value for the Backspace key (8).
	 */
	static public var BACKSPACE:Number = Key.BACKSPACE ;
	
	/**
	 * Constant associated with the key code value for the Caps Lock key (20).
	 */
	static public var CAPS_LOCK:Number = Key.CAPSLOCK ;
	
	/**
	 * Constant associated with the key code value for the Control key (17).
	 */
	static public var CONTROL:Number = Key.CONTROL ;
	
	/**
	 * Constant associated with the key code value for the Delete key (46).
	 */
	static public var DELETE:Number = Key.DELETEKEY ;
	
	/**
	 * Constant associated with the key code value for the Down Arrow key (40).
	 */
	static public var DOWN:Number = Key.DOWN ;
	
	/**
	 * Constant associated with the key code value for the End key (35).
	 */
	static public var END:Number = Key.END ;
	
	/**
	 * Constant associated with the key code value for the Enter key (13).
	 */
	static public var ENTER:Number = Key.ENTER ;
	
	/**
	 * Constant associated with the key code value for the Escape key (27).
	 */
	static public var ESCAPE:Number = Key.ESCAPE ;
	
	/**
	 * Constant associated with the key code value for the F1 key (112).
	 */
	static public var F1:Number = 112 ;
	
	/**
	 * Constant associated with the key code value for the F2 key (113).
	 */
	static public var F2:Number = 113 ;
	
	/**
	 * Constant associated with the key code value for the F3 key (114).
	 */
	static public var F3:Number = 114 ;
	
	/**
	 * Constant associated with the key code value for the F4 key (115).
	 */
	static public var F4:Number = 115 ;
	
	/**
	 * Constant associated with the key code value for the F5 key (116).
	 */
	static public var F5:Number = 116 ;
	
	/**
	 * Constant associated with the key code value for the F6 key (117).
	 */
	static public var F6:Number = 117 ;
	
	/**
	 * Constant associated with the key code value for the F7 key (118).
	 */
	static public var F7:Number = 118 ;
	
	/**
	 * Constant associated with the key code value for the F8 key (119).
	 */
	static public var F8:Number = 119 ;
	
	/**
	 * Constant associated with the key code value for the F9 key (120).
	 */
	static public var F9:Number = 120 ;
	
	/**
	 * Constant associated with the key code value for the F10 key (121).
	 */
	static public var F10:Number = 121 ;
	
	/**
	 * Constant associated with the key code value for the F11 key (122).
	 */
	static public var F11:Number = 122 ;
	
	/**
	 * Constant associated with the key code value for the F12 key (123).
	 */
	static public var F12:Number = 123 ;
	
	/**
	 * Constant associated with the key code value for the Home key (36).
	 */
	static public var HOME:Number = Key.HOME ;
	
	/**
	 * Constant associated with the key code value for the Insert key (45).
	 */
	static public var INSERT:Number = Key.INSERT ;
	
	/**
	 * Constant associated with the key code value for the Left Arrow key (37).
	 */
	static public var LEFT:Number = Key.LEFT ;
	
	/**
	 * Constant associated with the key code value for the number 0 key on the number pad (96).
	 */
	static public var NUMPAD_0:Number = 96 ;
	
	/**
	 * Constant associated with the key code value for the number 1 key on the number pad (97).
	 */
	static public var NUMPAD_1:Number = 97 ;
	
	/**
	 * Constant associated with the key code value for the number 2 key on the number pad (98).
	 */
	static public var NUMPAD_2:Number = 98 ;
	
	/**
	 * Constant associated with the key code value for the number 3 key on the number pad (99).
	 */
	static public var NUMPAD_3:Number = 99 ;
	
	/**
	 * Constant associated with the key code value for the number 4 key on the number pad (100).
	 */
	static public var NUMPAD_4:Number = 100 ;
	
	/**
	 * Constant associated with the key code value for the number 5 key on the number pad (101).
	 */
	static public var NUMPAD_5:Number = 101 ;
	
	/**
	 * Constant associated with the key code value for the number 6 key on the number pad (102).
	 */
	static public var NUMPAD_6:Number = 102 ;
	
	/**
	 * Constant associated with the key code value for the number 7 key on the number pad (103).
	 */
	static public var NUMPAD_7:Number = 103 ;
	
	/**
	 * Constant associated with the key code value for the number 8 key on the number pad (104).
	 */
	static public var NUMPAD_8:Number = 104 ;
	
	/**
	 * Constant associated with the key code value for the number 9 key on the number pad (105).
	 */
	static public var NUMPAD_9:Number = 105 ;
	
	/**
	 * Constant associated with the key code value for the addition key on the number pad (107).
	 */
	static public var NUMPAD_ADD:Number = 107 ;
	
	/**
	 * Constant associated with the key code value for the decimal key on the number pad (110).
	 */
	static public var NUMPAD_DECIMAL:Number = 110 ; 
	
	/**
	 * Constant associated with the key code value for the division key on the number pad (111).
	 */
	static public var NUMPAD_DIVIDE:Number = 111 ;
	
	/**
	 * Constant associated with the key code value for the Enter key on the number pad (108).
	 */
	static public var NUMPAD_ENTER:Number = 108 ;
	
	/**
	 * Constant associated with the key code value for the multiplication key on the number pad (106).
	 */
	static public var NUMPAD_MULTIPLY:Number = 106 ;
	
	/**
	 * Constant associated with the key code value for the subtraction key on the number pad (109).
	 */
	static public var NUMPAD_SUBTRACT:Number = 109 ; 
	
	/**
	 * Constant associated with the key code value for the Page Down key (34).
	 */
	static public var PAGE_DOWN:Number = Key.PGDN ;
	
	/**
	 * Constant associated with the key code value for the Page Up key (33).
	 */
	static public var PAGE_UP:Number = Key.PGUP ;
	
	/**
	 * Constant associated with the key code value for the Right Arrow key (39).
	 */
	static public var RIGHT:Number = Key.RIGHT ;
	
	/**
	 * Constant associated with the key code value for the Shift key (16).
	 */
	static public var SHIFT:Number = Key.SHIFT ;
	
	/**
	 * Constant associated with the key code value for the Spacebar (32).
	 */
	static public var SPACE:Number = Key.SPACE ;
	
	/**
	 * Constant associated with the key code value for the Tab key (9).
	 */
	static public var TAB:Number = Key.TAB ;
	
	/**
	 * Constant associated with the key code value for the Up Arrow key (38).
	 */
	static public var UP:Number = Key.UP ;

	static private var __ASPF__ = _global.ASSetPropFlags(Keyboard, null , 7, 7) ;

	/**
	 * Returns the char code number representation of the specified character passed-in argument.
	 * @return the char code number representation of the specified character passed-in argument.
	 */
	static public function getCharCode(char:String):Number 
	{
		return (new Char(char)).getCode() ;
	}

	
}
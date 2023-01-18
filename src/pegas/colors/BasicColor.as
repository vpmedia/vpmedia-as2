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
  
	- Nicolas Coevoet <http://niko.informatif.org/> (Documentation)

*/

import pegas.colors.ColorUtil;

import vegas.core.HashCode;
import vegas.core.IFormattable;
import vegas.core.IHashable;
import vegas.util.ConstructorUtil;

/**
 * {@code BasicColor} extends the Color Object.
 * <p>
 * {@code 
 * import pegas.colors.BasicColor;
 * var c : BasicColor = new BasicColor (this); // assuming 'this' is a MovieClip;
 * c.setRGB(0xFF9900);
 * }
 * </p>
 * @author eKameleon
 */
class pegas.colors.BasicColor extends Color implements IFormattable, IHashable 
{

	/**
	 * Creates an instance of a BasicColor.
	 * @since Flash 6
	 * <p>{@code new BasicColor(mc);</p>
	 * @param mc a MovieClip
	 */
	public function BasicColor (mc:MovieClip) 
	{ 
		super (mc) ;
		_mc = mc ;
	}

	static private var _initHashCode:Boolean = HashCode.initialize(BasicColor.prototype) ;

	/**
	 * Return the BasicColor target MovieClip.
	 * @since Flash 6
	 * @return mc a MovieClip
	 */	
	public function getTarget():MovieClip 
	{ 
		return _mc ;
	}

	/**
	 * This method is overrided !
 	 * @return a Number
	 * @see vegas.core.HashCode
	 */		
	public function hashCode():Number 
	{
		return null ;
	}

	/**
	* Invert color of the MovieClip
	* <p><b>Example</b><b>
	* {@code
	* import pegas.colors.BasicColor;
	* var c : BasicColor = new BasicColor (this);
	* c.invert();
	* }
	* @see asgard.colors.ColorUtil#invert
	*/
	public function invert():Void 
	{ 
		ColorUtil.invert(this) ; 
	}

	/**
	* Reset color of the MovieClip
	* @example <pre>
	* import pegas.colors.BasicColor;
	* var c : BasicColor = new BasicColor (this);
	* c.reset();
	* </pre>
	* @see asgard.colors.ColorUtil#reset
	*/
	public function reset():Void 
	{ 
		ColorUtil.reset(this) ;
	}

	/**
	* Return current instance name
	* @example <pre>
	* import pegas.colors.BasicColor;
	* var c : BasicColor = new BasicColor (this);
	* trace (c.toString());
	* </pre>
	* @return a String, the current instance string name
	* @see vegas.util.ConstructorUtil#getName
	*/	
	public function toString():String 
	{
		return "[" + ConstructorUtil.getName(this) + "]" ;
	}

	private var _mc:MovieClip ;

}


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

import vegas.util.ConstructorUtil;
import vegas.util.TypeUtil;

/**
 * This factory static class is an all-static class with methods to creates dynamic {@code MovieClip} or {@code Textfield} who used a custom class. 
 * @author eKameleon
 * @see ConstructorUtil
 */
class vegas.util.factory.DisplayFactory 
{
	
	/**
	 * Attachs a MovieClip in a target and register a custom constructor who inherit MovieClip in this instance.
	 * @see ConstructorUtil.createVisualInstance
	 */
	static public function attachChild
	( 
		fConstructor:Function, sID:String, sName:String,
		 nDepth:Number, mcTarget:MovieClip, init 
	) 
	{
		var oChild = mcTarget.attachMovie(sID, sName, nDepth) ;
		return ConstructorUtil.createVisualInstance( fConstructor, oChild, init) ;
	}
	
	/**
	 * Creates a new child object (MovieClip, TextField) with a custom constructor or an id link.
	 * @see ConstructorUtil
	 */
	static public function createChild ( oChild , p_name:String , p_depth:Number, p_target, p_init) 
	{
		
		var child ;
		
		if (oChild == null) 
		{
			child = p_target.createEmptyMovieClip(p_name, p_depth) ;
			for (var each in p_init) 
			{
				child[each] = p_init[each] ;
			}
			return child ;
			
		}
		else if (oChild instanceof Function) 
		{
			var p_class:Function = oChild ;
			if (ConstructorUtil.isSubConstructorOf(p_class, MovieClip))  
			{
				child = p_target.createEmptyMovieClip (p_name, p_depth) ;
			}
			else if (ConstructorUtil.isSubConstructorOf(p_class, TextField)) 
			{
				p_target.createTextField (p_name, p_depth, 0, 0, 0, 0) ;
				child = p_target[p_name] ;
			}
			return ConstructorUtil.createVisualInstance(p_class, child, p_init) ;
		}
		else if (TypeUtil.typesMatch(oChild, String)) 
		{
			return p_target.attachMovie(oChild, p_name, p_depth, p_init) ;
		}
	}
	
	/**
	 * Returns the depth of the display instance (MovieClip, TextField, Video).
	 * @param display The display reference (MovieClip, TextField, Video).
	 * @return the depth of the display instance (MovieClip, TextField, Video).
	 */
	static public function getDepth( display ):Number
	{
		return MovieClip.prototype.getDepth.call( display ) ;
	}
	
	/**
	 * Swaps the stacking, or depth level (z-order), of the specified display with display that is specified by the target parameter, or with the display that currently occupies the depth level that is specified in the target parameter.
	 * @param display An MovieClip, TextField or Video display object.
	 * @param target This parameter can take one of two forms:
	 * <bl>
	 * <li>A Number that specifies the depth level where the display is to be placed.</li>
	 * <li>A String that specifies the display instance whose depth is swapped with the movie clip for which the method is being applied. Both displays must have the same parent movie clip.</li>
	 * </bl>
	 */
	static public function swapDepths( display, target ):Void
	{
		MovieClip.prototype.swapDepths.call( display, target ) ;
	}
	
}
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

import lunas.core.IButton;
import lunas.core.IGroupable;
import lunas.group.AbstractGroup;

import vegas.data.map.HashMap;
import vegas.util.TypeUtil;

/**
 * This singleton class defined all groups for the different RadioButton in the application.
 * @author eKameleon
 */
class lunas.group.RadioButtonGroup extends AbstractGroup
{
	
	/**
	 * Creates a new RadioButtonGroup.
	 */
	public function RadioButtonGroup () 
	{
		groups = new HashMap() ;
	}
	
	/**
	 * Returns a singleton reference of the RadioButtonGroup class.
	 * @return a singleton reference of the RadioButtonGroup class.
	 */
	static public function getInstance():RadioButtonGroup 
	{
		if (_instance == undefined)  
		{
			_instance = new RadioButtonGroup () ;
		}
		return _instance ;
	}

	/**
	 * Selects the passed-in IGroupable item.
	 */	
	public function select( item:IGroupable ):Void
	{
		
		var button:IButton = IButton(item) ;
		
		if ( button != null && (button.getToggle() == false) ) 
		{
			return ;
		}

		var name:String = IGroupable( item ).getGroupName() ;
		
		if (groups.containsKey(name))
		{
			IButton(groups.get(name)).setSelected (false, true)  ;
		}
		
		groups.put( name, button ) ;
			
	}
	
	/**
	 * Unselect the specified item in argument. 
	 * This item can be a IGroupable object or the String representation of the name's group to unselect.
	 */
	public function unSelect( item ) : Void 
	{
		var name:String = null ;
		
		if ( TypeUtil.typesMatch( item, String) )
		{
			name = item ;
		}
		else if ( item instanceof IGroupable )
		{
			name = IGroupable(item).getGroupName() ;
		}
		
		if ( groups.containsKey( name ) )
		{
			var cur:IButton = IButton( groups.get(name) ) ;
			if (cur != null && (cur instanceof IButton))
			{
				cur.setSelected (false, true)  ;
				groups.remove(name) ;
			}
		}
	}
	
	static private var _instance : RadioButtonGroup ;	

}
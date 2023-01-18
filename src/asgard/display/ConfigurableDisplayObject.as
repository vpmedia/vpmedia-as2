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

import asgard.config.Config;
import asgard.config.ConfigCollector;
import asgard.config.IConfigurable;
import asgard.display.DisplayObject;

/**
 * This display is IConfigurable and is ready to uses the Config model of ASGard.
 * @author eKameleon
 */
class asgard.display.ConfigurableDisplayObject extends DisplayObject implements IConfigurable 
{
	
	/**
	 * Creates a new ConfigurableDisplayObject instance.
	 * @param sName the name of the display.
	 * @param target the DisplayObject instance control this target.
	 */
	public function ConfigurableDisplayObject(sName:String, target) 
	{
		super(sName, target);
		isConfigurable = true ;
	}

	/**
	 * Returns {@code true} if the display is configurable.
	 * @return {@code true} if the display is configurable.
	 */
	public function get isConfigurable():Boolean
	{
		return _isConfigurable ;
	}
	
	/**
	 * Sets if the display is configurable.
	 * @param b a boolean flag to determinaites if the display is configurable.
	 */
	public function set isConfigurable(b:Boolean):Void
	{
		_isConfigurable = (b == true) ;
		if (_isConfigurable)
		{
			ConfigCollector.insert(this) ;	
		}
		else
		{
			ConfigCollector.remove(this) ;
		}
	}

	/**
	 * Invoqued by the ConfigCollector when the ConfigCollector is running.*
	 * By default this method launch a search in the Config object with the name of the display and initialize the display.
	 * If you want use your custom setup method override this method.
	 */
	public function setup():Void 
	{
		var config:Object = Config.getInstance()[getName()] ; 
		if ( config != null ) 
		{
			for (var prop:String in config)
			{
				this[prop] = config[prop] ; 
			}
		}
		update() ;	
	}	 
	
	/**
	 * Update the display.
	 * You must override this method. This method is launch by the setup() method when the Config is checked.
	 */	
	public function update() : Void 
	{
		// overrides this method.
	}
	
	private var _isConfigurable:Boolean ;

}
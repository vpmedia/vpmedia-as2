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

import lunas.display.components.AbstractBuilder;
import lunas.display.components.container.ListContainer;

/**
 * AbstractListBuilder
 * @author eKameleon
 */
class lunas.display.components.list.AbstractListBuilder extends AbstractBuilder 
{
	
	/**
	 * Creates a new AbstractListBuilder instance.
	 */
	private function AbstractListBuilder(mc : MovieClip) {
		super(mc) ;
	}
	
	public var container:MovieClip ;
	
	public function clear():Void 
	{
		container.clear() ;
		container.removeMovieClip() ;
	}

	public function getContainerRenderer():Function 
	{
		return ListContainer ;
	}

	public function run():Void 
	{
		_createContainer() ;
	}
	
	public function update():Void 
	{
		_refreshContainer() ;
	}

	/*protected*/ private function _createContainer():Void 
	{
		container = target.createChild( getContainerRenderer(), "container", 50) ;
	}

	/*protected*/ private function _refreshContainer():Void 
	{
		// override this protected method
	}

}
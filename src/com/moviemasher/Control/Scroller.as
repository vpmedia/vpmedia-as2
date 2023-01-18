/*
* The contents of this file are subject to the Mozilla Public
* License Version 1.1 (the "License"); you may not use this
* file except in compliance with the License. You may obtain a
* copy of the License at http://www.mozilla.org/MPL/
* 
* Software distributed under the License is distributed on an
* "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express
* or implied. See the License for the specific language
* governing rights and limitations under the License.
* 
* The Original Code is 'Movie Masher'. The Initial Developer
* of the Original Code is Doug Anarino. Portions created by
* Doug Anarino are Copyright (C) 2007 Syntropo.com, Inc. All
* Rights Reserved.
*/



/** Icon control symbol adjusts visibility of other controls in same bar.
*/

class com.moviemasher.Control.Scroller extends com.moviemasher.Control.ControlIcon
{
	
	private function Scroller()
	{
		//_global.com.moviemasher.Control.Debug.msg('Instancing Scroller');
	}
	
	private function __release()
	{
		super.__release();
		panel.scrollToBarIndex(config.bar, config.scrolls_index, (config.first ? -1 : 1))
	}
}
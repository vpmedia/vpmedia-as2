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



/** BrowserList control symbol displays a button and maintains a list of {@link com.moviemasher.Media.Media} objects for display in the {@link com.moviemasher.Control.Browser}.
*/ 

class com.moviemasher.Control.BrowserList extends com.moviemasher.Control.ControlIcon
{
	private function BrowserList()
	{
		if (config.attributes == undefined) config.attributes = 'browser.items';
	}

	private function __dispatchPropertyChanged() : Void
	{
		if (! config.items.length) 
		{
			var params : Object = {};
			var found_one : Boolean = false;
			for (var k in config)
			{
				if (k.substr(0, 6) != 'filter') continue;
				if (k.length > 6) 
				{
					found_one = true;
					params[k.substr(6)] = config[k];	
				}
			}
			if (found_one) config.items = _global.com.moviemasher.Media.Media.localSearch(params);
			else config.items = _global.com.moviemasher.Media.Media;
		}
		super.__dispatchPropertyChanged();
	}
	
	
}
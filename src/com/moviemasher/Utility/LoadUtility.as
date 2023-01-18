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


/** Static class loads textual data (XML) from server.

*/

class com.moviemasher.Utility.LoadUtility
{
	
	static function cgi(callback, url, params, return_error)
	{
		var v = new LoadVars();
		var r = new LoadVars();
		if (params != undefined)
		{
			for (var k in params)
			{
				v[k] = params[k];
			}
		}
		__sendLoad(v, r, callback, url, return_error);
	}
	
	static function xml(callback, url, params, return_error)
	{
		var v = new XML();
		var r = new XML();
		r.contentType = "text/xml";
		r.ignoreWhite = true;
		
		var root_node = v.createElement('save');
		v.appendChild(root_node);
		if (params != undefined) __xmlData(v, root_node, params);
		__sendLoad(v, r, callback, url, return_error);
	}
	

// PRIVATE CLASS METHODS

	private static function __sendLoad(v, r, callback, url, return_error)
	{
		r.mm_callback = callback;
		r.mm_v = v;
		r.mm_url = url;
		r.mm_return_error = return_error;
		
		r.onData = function (d)
		{
			if (d != undefined) 
			{
				var x = new XML();
				x.ignoreWhite = true;
				x.parseXML(d);
				x.mm_url = this.mm_url;
				this.mm_callback.back(x);
			}
			else if (this.mm_return_error)
			{
				this.mm_callback.back();
			}
			else _global.com.moviemasher.Control.Debug.msg('LoadUtility.__sendLoad received no data');
		}
		v.sendAndLoad(url, r, 'POST');
	}
	
	private static function __xmlData(x, node, data)
	{
		switch (typeof(data))
		{
			case 'number': 
			case 'string': 
			{
				node.appendChild(x.createTextNode(data));
				break;	
			}
			case 'object':
			{
				var new_node;
				if (data instanceof Array) // it's an array?
				{
					var z = data.length;
					for (var i = 0; i < z; i++)
					{
						new_node = x.createElement('Object');
						node.appendChild(new_node);
						
						__xmlData(x, new_node, data[i]);
					}
				}
				else // hash
				{
					for (var k in data)
					{
						new_node = x.createElement(k);
						node.appendChild(new_node);
						
						__xmlData(x, new_node, data[k]);
						
					}
				}
				break;	
			}
		}
		
	}
}
/**
* The XMLShortcuts class enables shortcut access to All XML nodes. 
* @usage Copy XMLShortcuts.as to the class path. and write XMLShortcuts.activate() in your main method and stat using its right after that.
* @author Arul [arul@shockwvave-india.com] © 2006 Shockwave-India.com
* @version Pro 2.2 MTASC Edition
*/
class XMLShortcuts
{
	static var version=2.2;
	function XMLShortcuts ()
	{
		activate ();
	}
	/**
	* activate method enables XMLShortcuts
	*/
	static public function activate ()
	{
		trace("[XMLShortcuts] activate");
		
		var o = XMLNode.prototype;
		o.addProperty ('__text', function ()
		{
			// get __text
			return this.firstChild.nodeValue;
		}, function (v)
		{
			// set __text
			if (this.hasChildNodes ())
			{
				if (this.firstChild.nodeType == 3)
				{
					this.firstChild.nodeValue = v;
				} else 
				{
					this.insertBefore (this.rootNode.createTextNode (v) , this.firstChild);
				}
			} else 
			{
				this.appendChild (this.rootNode.createTextNode (v));
			}
		});
		
		
		
		
		o.addProperty ('rootNode', function ()
		{
			// get rootNode
			var s = this;
			while ( ! (s instanceof XML))
			{
				s = s.parentNode;
			}
			return s;
		}, null);
		
		
		
		
		o.__resolve = function (d)
		{
			//trace ('resolving ' + this.nodeName + '.' + d);
			var s;
			var ni = false;
			var m = false;
			var n = 0;
			var i;
			var a;
			switch (d)
			{
				case 'nodeIndex' :
					ni = true;
					d = this.nodeName;
					break;
					
				default :
					// check for _attribute
					//m: return Array
				
				switch (d.charAt (0))
				{
					case '$' :
						m = true;
					case '_' :
						d=d.substring(1);
						//return if attribute found
						if ( ! m && this.attributes [d] != undefined)
						{
							return this.attributes [d];
						}
						break;
					case '#' :
						//skip
						return;
				}
				//check index
				i = d.lastIndexOf ('_');
				if (i != - 1)
				{
					s =d.substr (i + 1);
					if ( ! isNaN (s))
					{
						n = Number (s);
						d = d.substring (0, i);
						
					}
				}
			}

			var p = ni ? this.parentNode : this;
			//generate links for child
			if (p.hasOwnProperty ('#' + d))
			{
				//last resolved array
				a = p ['#' + d];
				i = a.length;
				s = a [i - 1].nextSibling;
			} else 
			{
				i = 0;
				a = p ['#' + d] = [];
				_global.ASSetPropFlags (p, '#' + d, 1);
				s = p.firstChild;
			}
			//loop through
			do 
			{
				if (s.nodeName == d)
				{
					a.push (s);
					p [d + '_' + i] = s;
					s.nodeIndex = i;
					if (i == 0)
					{
						p [d] = s;
					}
					if ( ! m && ! ni && i == n)
					{
						// we have found the needed node
						return s;
					}
					if (s == this)
					{
						//nodeIndex found
						return i;
					}
					i ++;
				}
				s = s.nextSibling;
			} while (s != undefined);
			if (p.hasOwnProperty (d))
			{
				// we have completed full search for child nodes so update the $array
				p ['$' + d] = a;
			} else 
			{
				delete p ['#' + d];
			}
			return m ? a : undefined;
		};
		o ['#appendChild'] = o.appendChild;
		o ['#removeNode'] = o.removeNode;
		o ['#insertBefore'] = o.insertBefore;
		
		
		
		o.appendChild = function (c)
		{
			//trace ('appending child ' + c);
			if (c instanceof XML)
			{
				c = c.firstChild;
			}
			if (c.nodeType == 1)
			{
				var n = '#' + c.nodeName;
				if (this.hasOwnProperty (n))
				{
					var a = this [n];
					var l = a.length;
					a.push (c);
					this [c.nodeName + '_' + l] = c;
					c.nodeIndex = l;
				}
			}
			return this ['#appendChild'].apply (this, arguments);
		};
		
		
		
		o.removeNode = function ()
		{
			//trace ('removing node ' + this);
			if (this.nodeType == 1)
			{
				var p = this.parentNode;
				var n = this.nodeName;
				if (this.hasOwnProperty ('nodeIndex'))
				{
					var a = p ['#' + n];
					var ni = this.nodeIndex;
					a.splice (ni, 1);
					if (ni == 0)
					{
						p [n] = a [0];
					}
					var l = a.length;
					delete p [n + '_' + Math.max (ni, l)];
					for (var i = ni; i < l; i ++)
					{
						p [n + '_' + i] = a [i];
						a [i].nodeIndex = i;
					}
				}
			}
			return this ['#removeNode'].apply (this, arguments);
		};
		
		
		
		o.insertBefore = function (s, c)
		{
			//trace ('inserting ' + s + ' before ' + c);
			if (s instanceof XML)
			{
				s = s.firstChild;
			}
			if (s.nodeType == 1 && c.parentNode.hasOwnProperty (s.nodeName))
			{
				//inserted node is already indexed so check if anything needs to be altered
				var p = c.parentNode;
				var n = s.nodeName;
				var a = p ['#' + n];
				var ni = 0;
				var z = c;
				var skip = true;
				while (z != undefined)
				{
					if (z.nodeName == n)
					{
						if (z.hasOwnProperty ('nodeIndex'))
						{
							ni = z.nodeIndex;
							skip = false;
						}
						break;
					}
					z = z.previousSibling;
				}
				if ( ! skip)
				{
					a.splice (ni, 0, s);
					var l = a.length;
					for (var i = ni; i < l; i ++)
					{
						p [n + '_' + i] = a [i];
						if (i == 0)
						{
							p [n] = a [i];
						}
						a [i].nodeIndex = i;
					}
				}
			}
			return this ['#insertBefore'].apply (this, arguments);
		};
		_global.ASSetPropFlags (o, "__resolve,__text,#appendChild,#removeNode,#insertBefore", 1);
		o = XML.prototype;
		o ['#parseXML'] = o.parseXML;
		
		
		
		o.parseXML = function ()
		{
			var n = this.firstChild;
			while (n != undefined)
			{
				var x = n.nodeName;
				delete this [x];
				for (var i = 0; i < this ['#' + x].length; i ++)
				{
					delete this [x + '_' + i];
				}
				delete this ['$' + x];
				delete this ['#' + x];
				n = n.nextSibling;
			}
			return this ['#parseXML'].apply (this, arguments);
		};
		
		
		
		_global.ASSetPropFlags (o, "#parseXML", 1);
		delete o;
	}
}

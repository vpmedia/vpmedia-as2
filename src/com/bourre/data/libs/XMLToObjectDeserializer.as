/*
 * Copyright the original author or authors.
 * 
 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.mozilla.org/MPL/MPL-1.1.html
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
 
/**
 * @author Francis Bourre
 * @version 1.0
 */

import com.bourre.commands.Delegate;
import com.bourre.core.HashCodeFactory;
import com.bourre.data.collections.Map;
import com.bourre.data.libs.AbstractXMLToObjectDeserializer;
import com.bourre.log.PixlibDebug;
import com.bourre.log.PixlibStringifier;
import com.bourre.structures.Point;

class com.bourre.data.libs.XMLToObjectDeserializer 
	extends AbstractXMLToObjectDeserializer
{
	private var _m : Map;
	private var _bDeserializeAttributes : Boolean;
	
	public var pushInArray : Boolean;

	public static var DEBUG_IDENTICAL_NODE_NAMES : Boolean = false;
	public static var PUSHINARRAY_IDENTICAL_NODE_NAMES : Boolean = false;
	public static var ATTRIBUTE_TARGETED_PROPERTY_NAME : String = null;
	public static var DESERIALIZE_ATTRIBUTES : Boolean = false;
	
	public function XMLToObjectDeserializer() 
	{
		_m = new Map();

		addType("number", this, getNumber);
		addType("string", this, getString);
		addType("array", this, getArray);
		addType("boolean", this, getBoolean);
		addType("class", this, getInstance);
		addType("point", this, getPoint);
		addType(undefined, this, getObject);
		
		addType("xml2o", this, getObject); // deprecated!!!
		
		pushInArray = XMLToObjectDeserializer.PUSHINARRAY_IDENTICAL_NODE_NAMES;
		deserializeAttributes = XMLToObjectDeserializer.DESERIALIZE_ATTRIBUTES;
	}

	private static function _getUniqueMemberName(o, s:String) : String
  	{
  		var n:Number = -1;
  		var sName:String = s;
  		
  		while (o[sName]) sName = s + String( ++n );
  		return sName;
  	}
  	
  	private static function _getNodeContainer( target, member : String ) : Array
  	{
  		var node = target[ member ];
  		
  		if ( node.__nodeContainer )
  		{
  			return node;
  			
  		} else
  		{
  			var a : Array = new Array();
  			a["__nodeContainer"] = true;
  			_global.ASSetPropFlags( a, "__nodeContainer", 7, 1 );
  			
  			a.push( node );
  			return a;
  		}
  	}
  	
  	private function _getData( node:XMLNode )
	{
		var dataType:String = node.attributes.type;
		
		if (_m.containsKey( dataType ))
		{
			var d = _m.get( dataType );
			d.setArguments( node );
			return d.callFunction();
			

		} else
		{
			PixlibDebug.WARN( dataType + ' type is not supported!' );
			return null;
		}
	}
	
	/**
	 * Add new type to deserializer
	 */
	public function addType( type : String, scopeMethod, parsingMethod : Function ) : Void
	{
		_m.put( type, new Delegate( scopeMethod, parsingMethod ) );
	}
	
	/**
	 * Remove type to deserializer
	 */
	public function removeType( type : String ) : Void
	{
		_m.remove( type );
	}
	
	/**
	 * Deserialize XMLToObject's node.
	 */
	public function deserialize( target, node:XMLNode ) : Void
	{
		var member:String = node.attributes.name;
		if (!member) member = node.nodeName;
		
		if ( target[member] ) 
		{
			if (XMLToObjectDeserializer.DEBUG_IDENTICAL_NODE_NAMES)
			{
				PixlibDebug.WARN( "XMLToObject parsed two nodes with identical names : '" + member + "'." );
			}
			
			if ( pushInArray )
			{
				target[member] = XMLToObjectDeserializer._getNodeContainer( target, member );
				target[member].push(_getData( node ));
				
			} else
			{
				member = XMLToObjectDeserializer._getUniqueMemberName( target, member );
				target[member] = _getData( node );
			}
			
		} else
		{
			target[member] = _getData(node);
		}
	}
	
	/**
	 * Explode string to arguments array.
	 */
	public function getArguments( sE:String ) : Array 
	{
  		var t:Array = XMLToObjectDeserializer.split(sE);
  		
  		var aR:Array = new Array();
  		var l:Number = t.length;
  		for (var y=0; y<l; y++) 
		{
			var s:String = XMLToObjectDeserializer.stripSpaces(t[y]);
			if (s == 'true' || s == 'false')
			{
				aR.push( s == 'true' );
			} else
			{
				if (s.charCodeAt(0) == 34 || s.charCodeAt(0) == 39)
				{
					aR.push( s.substr(1, s.length-2) );
				} else
				{
					aR.push( Number(s) );
				}
			}
		}
 		return aR;
  	}
  	
  	public function get deserializeAttributes () : Boolean
	{
		return _bDeserializeAttributes;
	}
	
	public function set deserializeAttributes ( b : Boolean ) : Void
	{
		if ( b != _bDeserializeAttributes )
		{
			if ( b )
			{
				addType( undefined, this, getObjectWithAttributes );
			} else
			{
				addType( undefined, this, getObject );
			}
		}
	}
  	
  	/*
  	 * setters - parsers's behaviors
  	 */
  	
  	public function getNumber ( node:XMLNode ) : Number
  	{
  		return Number( XMLToObjectDeserializer.stripSpaces( node.firstChild.nodeValue ) );
  	}
  	
  	public function getString ( node:XMLNode ) : String
  	{
  		return node.firstChild.nodeValue;
  	}
  	
  	public function getArray (  node:XMLNode  ) : Array
  	{
  		return getArguments( node.firstChild.nodeValue );
  	}
  	
  	public function getBoolean (  node:XMLNode  ) : Boolean
  	{
  		var s:String = XMLToObjectDeserializer.stripSpaces( node.firstChild.nodeValue );
  		return ( s == "true" || Number( s ) == 1 );
  	}
  	
  	public function getObject ( node:XMLNode ) : Object
	{
  		var data = node.firstChild.nodeValue;
  		return data? data : _owner.deserializeData( node, {} );
	}
	
  	public function getObjectWithAttributes ( node:XMLNode ) : Object
	{
		var data = node.firstChild.nodeValue;
		
		var o : Object = new Object();

		var attribTarget : Object;
		var s : String = XMLToObjectDeserializer.ATTRIBUTE_TARGETED_PROPERTY_NAME;
		if ( s.length > 0 ) attribTarget = o[s] = new Object();
		
    	for ( var p : String in node.attributes ) 
    	{
    		if (!(_m.containsKey(p))) 
    		{
    			if ( attribTarget )
    			{
    				attribTarget[p] = node.attributes[p];
    			
    			} else
    			{
    				o[p] = node.attributes[p];
    			}
    		}
    	}
		
		return data? data : _owner.deserializeData( node, o );
	}
  	
  	public function getInstance(  node:XMLNode  ) : Object
  	{
  		var args : Array = getArguments( node.firstChild.nodeValue );
		var sPackage = args[0]; 
		args.splice(0, 1);
		return  HashCodeFactory.buildInstance( sPackage, args ); 
  	}
  	
	public function getPoint (  node:XMLNode  ) : Point
  	{
  		var args:Array = getArguments( node.firstChild.nodeValue );
		return new Point(args[0], args[1]);
  	}
  	
  	/*
  	 * static methods
  	 */
  	public static function stripSpaces(s:String) : String 
	{
        var i:Number = 0;
		while(i < s.length && s.charCodeAt(i) == 32) i++;
		var j:Number = s.length-1;
		while(j > -1 && s.charCodeAt(j) == 32) j--;
        return s.substr(i, j-i+1);
  	}
  	
  	public static function split(sE:String) : Array
  	{
  		var b:Boolean = true;
  		var a:Array = new Array();
  		var l:Number = sE.length;
  		var n:Number;
  		var s:String = '';
  		
  		for (var i:Number = 0; i<l; i++)
  		{
  			var c:Number = sE.charCodeAt(i);
  			if ( b && (c == 34 || c == 39))
  			{
  				b = false;
  				n = c;
  			} else if (!b && n == c)
  			{
  				b = true;
  				n = undefined;
  			}
  			
  			if (c == 44 && b)
  			{
   				a.push(s);
  				s = '';
  			} else
  			{
  				s += sE.substr(i, 1);	
  			}
  		}
  		a.push(s);
  		return a;
  	}
  	
  	/**
  	 * Returns the string representation of this instance.
  	 * @return the string representation of this instance
  	 */
  	public function toString() : String 
  	{
  		return PixlibStringifier.stringify( this );
  	}
}
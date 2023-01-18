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

import com.bourre.data.libs.AbstractXMLToObjectDeserializer;
import com.bourre.log.PixlibStringifier;

class com.bourre.data.libs.BasicXMLDeserializer 
	extends AbstractXMLToObjectDeserializer
{
	public static var ATTRIBUTE_TARGETED_PROPERTY_NAME : String = "attribute";

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
	
	/**
	 * Deserialize XMLToObject's node.
	 */
	public function deserialize( target, node : XMLNode ) : Void
	{
		var member:String = node.nodeName;

		if ( target[member] ) 
		{
			
			target[member] = BasicXMLDeserializer._getNodeContainer( target, member );
			target[member].push( getObjectWithAttributes( node ) );

			
		} else
		{
			target[member] = getObjectWithAttributes( node );
		}
	}
	
  	public function getObjectWithAttributes ( node : XMLNode ) : Object
	{
		var o : Object = new Object();
		var attribTarget : Object = o[BasicXMLDeserializer.ATTRIBUTE_TARGETED_PROPERTY_NAME] = {};
    	for ( var p : String in node.attributes ) attribTarget[p] = node.attributes[p];
    	
    	var data = node.firstChild.nodeValue;
		return data? data : _owner.deserializeData( node, o );
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
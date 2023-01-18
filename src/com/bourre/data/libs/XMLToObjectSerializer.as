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
 * {@code XMLToObjectSerializer } class defines tools to serialize any instance (of any type) 
 * into an XML structure.
 * 
 * <p>Example
 * <code>
 *   public function test() : Void
 *	 {
 *		  //build an object like we can have after XMLToObjectDeserialiser process
 *		  var config = new Object();
 *		  config.log = new Object();
 *		  config.log.name = "Romain Ecarnot";
 *		  config.log.age = 29;
 *		  config.log.male = true;
 *		  config.log.detail = new Array("detail1", 2,3, false);
 *		  config.log.subObject = new Object();
 *		  config.log.subObject.position = new Point(10,10);
 *		  config.file = "config.xml";
 *		  config.xml = new XML("<article><item>hairbrush</item></article>");
 *		
 *		  var customInstance : TestClass = new TestClass();
 *		  config.custom = customInstance;
 *		
 *		  var serializer : XMLToObjectSerializer = new XMLToObjectSerializer();
 *		  serializer.addType( ClassUtils.getFullyQualifiedClassName( customInstance ), this, _serializeTestClass);
 *		
 *		  var xmlResult : XML = serializer.serialize(config, "myObject");	
 *	 }
 *	
 *	 private function _serializeTestClass(xml : XML, instance : TestClass, name : String) : XMLNode
 *	 {
 *		 var node : XMLNode = xml.createElement( name );
 *		 xml.firstChild.appendChild( node );
 *		 node.attributes["type"] = ClassUtils.getFullyQualifiedClassName( instance );
 *		
 *		 var param : XMLNode = xml.createElement( "name" );
 *		 param.attributes["type"] = "string";
 *		 param.appendChild( xml.createTextNode( instance.getName() ) );
 *		 node.appendChild( param );
 *		
 *		 return node;
 *	  }
 *	
 * </code>
 * 
 * @author Romain Ecarnot
 * @version 1.0
 */
 
import com.bourre.commands.Delegate;
import com.bourre.core.HashCodeFactory;
import com.bourre.data.collections.Map;
import com.bourre.data.libs.IXMLToObjectSerializer;
import com.bourre.log.PixlibDebug;
import com.bourre.log.PixlibStringifier;
import com.bourre.structures.Point;
import com.bourre.utils.ClassUtils;

class com.bourre.data.libs.XMLToObjectSerializer 
	implements IXMLToObjectSerializer
{
	//-------------------------------------------------------------------------
	// Private properties
	//-------------------------------------------------------------------------
	
	private var _m : Map;
	
	
	//-------------------------------------------------------------------------
	// Public API
	//-------------------------------------------------------------------------
	
	/**
	 * Constructs a new {@code XMLToObjectSerializer} instance.
	 */
	public function XMLToObjectSerializer()
	{
		
		_m = new Map();		
		
		addType("com.bourre.structures.Point", this, _parsePoint);
	}
	
	/**
	 * Add custom parsing method for parsing specific instance type.
	 * 
	 * <p>Example
	 * <code>
	 *   var serializer : XMLToObjectSerializer = new XMLToObjectSerializer();
	 *	 serializer.addType( ClassUtils.getFullyQualifiedClassName( test ), this, _serializeTestClass);
	 * </code>
	 * 
	 * <p> Take a look at #_parsePoint method to a custom parsing example.
	 * 
	 * @param classType {@code String} - Instance full qualified type (ie : com.bourre.structures.Point)
	 * @param scope Context where parsing method is defined (or must be called on)
	 * @param parsingMethod Custom parsing {@code Function}
	 */
	public function addType( classType : String, scope, parsingMethod : Function ) : Void
	{
		if( scope && parsingMethod )
		{
			_m.put( classType, new Delegate( scope, parsingMethod ) );
		}
		else
		{
			PixlibDebug.ERROR( "Invalid parsing type definition" );	
		}
	}
	
	/**
	 * Serialzes passed-in {@code instance} into XML structure.
	 * 
	 * <p>Use {@code instanceName} to named your object (optional)
	 * 
	 * @param instance Instance to serialize
	 * @param instanceName (optional) Instance's name (name of first xml node)
	 */
	public function serialize( instance, instanceName : String ) : XML
	{
		if ( !instanceName ) instanceName = "o_" + HashCodeFactory.getKey( instance );
		return _serializeData( instance, instanceName );
	}
	
	/**
	 * Returns the string representation of this instance.
	 * @return the string representation of this instance
	 */
	public function toString() : String 
	{
		return PixlibStringifier.stringify( this );
	}
	
	//-------------------------------------------------------------------------
	// Private implementation
	//-------------------------------------------------------------------------
	
	private function _serializeData( o, xml ) : XML
	{
		xml = new XML("<" + xml + ">");
		
    	var node : XMLNode;
    	
    	for (var s : String in o)
    	{ 
    		var item = o[s];
    		var type = typeof(item);
        	
        	if (type == "function") continue; //functions are not serialized
        	if (type == "object")
        	{
        		var classType : String = ClassUtils.getFullyQualifiedClassName( item );
        		
        		switch(true)
        		{
        			case (classType != undefined) :
        				if(_m.containsKey(classType) )
        				{
        					var command : Delegate = _m.get(classType);
        					command.setArguments(xml, item, s, classType);
        					node = command.callFunction();
        				}
        				else
        				{
        					node = __createNode(xml, s, "class", "\"" + classType + "\"");
        				}
        				break;
        			case (item instanceof Array) :
        				node = __createNode(xml, s, "array", _getArrayArguments(item) );
        				break;
        			case (item instanceof XML) :
        				node = __createNode(xml, s, "xml", escape( item.toString() ) );
        				break;
        			default :
        				xml.firstChild.appendChild( _serializeData(item, s) );
        		}
        	}
        	else
        	{
        		node = __createNode(xml, s, type, item);
        	}
    	}
    	
    	return xml;
	}
	
	private function __createNode( xml : XML, itemName : String, type : String, append : String ) : XMLNode
	{
		var node : XMLNode = xml.createElement( itemName );
		xml.firstChild.appendChild( node );
		node.attributes["type"] = type;
		node.appendChild( xml.createTextNode( append ) );
		return node;
	}
	
	private function _getArrayArguments( a : Array ) : String
	{
		var s : String = "";
		var len : Number = a.length;
    			
		for(var i : Number = 0; i < len; i++)
		{
			switch( typeof(a[i]) )
			{
				case "string" : 
					s += ("\"" + a[i] + "\"");
					break;
				default : 
					s += a[i];
			}
			if(i+1 < len) s += ",";
		}
		return s;
	}
	
	private function _parsePoint( xml : XML, instance : Point, name : String ) : XMLNode
	{
		var node : XMLNode = xml.createElement( name );
		xml.firstChild.appendChild( node );
		node.attributes["type"] = "point";
		node.appendChild( xml.createTextNode( instance.x + "," + instance.y ) );
		return node;
	}
}


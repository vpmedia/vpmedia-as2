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
 * @author Simon Oliver
 * @version 1.0
 */
 
// Classes From PixLib
import com.bourre.events.EventType;
import com.bourre.events.BasicEvent;
import com.bourre.commands.Delegate;
import com.bourre.events.EventBroadcaster;
import com.bourre.log.Logger;

/** 
* Class to convert xml nodes into native as2 objects. Aims to be helpful like E4X. Except it doesnt have any of that pattern matching
* business. Useful for simple xml file loading.
* 
* Returns a native object with all the attributes assigned as properties. Child nodes containing text are also
* set as properties. Subnodes with complexity (ie attributes and child nodes other than text) are created and assigned to
* an array. This gets round the problem of single complex nodes breaking the system when classes expect an array. If complex -
* always an array, even if its only an array with one object.
* 
* */
class wilberforce.dataProviders.XMLtoObject
{
	private var _XML:XML;
	public var nativeDataRoot:Object;
	private var _url:String;
	private var _oEB:EventBroadcaster;
	
	private static var XML_TO_OBJECT_LOAD_EVENT : EventType =  new EventType( "onLoadSuccess" );
	private static var XML_TO_OBJECT_ERROR_EVENT : EventType =  new EventType( "onLoadError" );
	
	/** Constructor. If passed a URL, loads it straight away */
	public function XMLtoObject(url:String)
	{
		var _instance=this;
		_oEB = new EventBroadcaster( this );
		_XML=new XML();
		_XML.ignoreWhite=true;
		_XML.onLoad=Delegate.create(this,xmlLoaded);		
		if (url) load(url);
	}
	
	/** Load an XML */
	public function load(url:String):Void
	{
		_url=url;
		_XML.load(_url);
	}
	
	/** Callback function, depending on load success */	
	public function xmlLoaded(success:Boolean):Void
	{
		if (success)
		{
			Logger.LOG("XML Loaded successfully");
			var tRootNode=_XML.firstChild;
			nativeDataRoot=processNode(tRootNode);
			_oEB.broadcastEvent( new BasicEvent( XML_TO_OBJECT_LOAD_EVENT,nativeDataRoot ) );
			//dispatchEvent("xmlLoadSuccess",nativeDataRoot,this);			
		}
		else {
			Logger.LOG("XML Loading error");
			_oEB.broadcastEvent( new BasicEvent( XML_TO_OBJECT_ERROR_EVENT,nativeDataRoot ) );
			//dispatchEvent("xmlLoadFailure",_url,this);
		}
	}
	
	/**
	* Recursive function to process an XMLNode into a native AS2 object 
	* 
	**/
	private function processNode(tNode:XMLNode):Object
	{
		// Create the empty object
		var tObject:Object=new Object();
						
		// Go through each attribute and assign as a property to the object
		for (var attributeName in tNode.attributes) tObject[attributeName]=tNode.attributes[attributeName];		
				
		// Go through each childNode
		for (var i=0;i<tNode.childNodes.length;i++)
		{
			var isComplex:Boolean=false;
			var tChildNode:XMLNode=tNode.childNodes[i];
						
			var childNodeAttributes:Number=0;
			for (var attributeName in tChildNode.attributes) childNodeAttributes++;
			
			if (childNodeAttributes) isComplex=true;
			if (tChildNode.childNodes.length>1) isComplex=true;
			if (tChildNode.childNodes.length==0)
			{
				// Test for a single text node (considered simple)
				var tChildNodeSubNodeType=tChildNode.childNodes[0].nodeType;
				if (tChildNodeSubNodeType!=3 && tChildNodeSubNodeType!=4) isComplex=true;
									
			}
			if (isComplex)
			{				
				var tChildObject=processNode(tChildNode);
				if (tObject[tChildNode.nodeName]) tObject[tChildNode.nodeName].push(tChildObject)
				else tObject[tChildNode.nodeName]=[tChildObject];
			}
			else {
				var tNodeValue:String=tChildNode.childNodes[0].nodeValue;
				// If two "simple" nodes are declared with the same nodeName, then convert to an array. This should never happen
				// but it could in theory (say a very simple list of words for a dictionary).
				if (tObject[tChildNode.nodeName]) tObject[tChildNode.nodeName]= [tObject[tChildNode.nodeName],tNodeValue];
				// nodeName not used, just assign to the object
				else tObject[tChildNode.nodeName]=tNodeValue;
			}
		}				
		return tObject;
	}
	
	public function addListener(listeningObject)
	{
		_oEB.addListener(listeningObject);
	}
	public function removeListener(listeningObject)
	{
		_oEB.removeListener(listeningObject);
	}
}
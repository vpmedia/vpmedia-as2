import com.bumpslide.util.*;
import com.bumpslide.services.*;
import com.bumpslide.data.*;

/**
 *  Simple Xml Service
 * 
 *  <p>The XmlService class is an abstract service that includes the core functionality
 *  used by all xml services.  An xml service is a service that accepts parameters,
 *  uses these parameters to define a url, load the url, and then parses the result. 
 *  
 *  <p>Some of this functionality could be pulled down in to a UrlService class, but we'll 
 *  get to that when we need to.
 * 
 *  <p>To create a new Xml Service, you would create a class that extends XmlService.  You must 
 *  give your class a unique name if you are using the ServiceLoader.  Then, you must override 
 *  the url getter method to build a valid url based on the parameters stored in _args.  It 
 *  may be good form to create getter methods that point to elements in the _args array.  This 
 *  will make your code a bit cleaner inside the get url method.
 *  
 *  <p>Then, the only other thing to do is to override the onXmlLoaded method.  This will be called 
 *  after the Xml is loaded successfully.  In this method, you should store your service return 
 *  value in _result. The raw xml object can be accessed via the 'xml' getter.  If you don't 
 *  override this onXmlLoaded method, the default implementation will return an object 
 *  representation of the whole XML tree using an XML2AS type method found in the XmlLoader class.
 *  
 *  @author David Knape
 * 
 *  Copyright © 2006 David Knape (http://bumpslide.com)
 *  Released under the open-source MIT license. 
 *  http://www.opensource.org/licenses/mit-license.php
 *  See LICENSE.txt for full license terms. 
 *
 */ 

class com.bumpslide.services.XmlService extends com.bumpslide.services.Service {

	// reference to raw XML object
	private var xml:XML;	
	
	// Bumpslide XmlLoader (not the ASAP Framework one)
	var xmlLoader:XmlLoader = null;
	
	// status indicator
	private var isXmlLoading:Boolean = false;
	
	var mDebug = false;
	
	
	// Methods to override...
	//---------------------------------
	//
	// buildUrl --> returns dynamically generated URL based on args
	//
	// onXmlLoaded --> what to do on successful load 
	//     (optional, defaults to storing result as XML2AS object)
	//---------------------------------	
	
	// url definition
	function buildUrl () {
		notifyError('URL is not defined in XML Service '+this);
		return undefined;
	}
	
	// Service.run implementation
	public function run() {
		doLoadXml();		
	}
	
	
	private function doLoadXml() {
		var url = buildUrl();
		
		if(mDebug) Debug.info('[XmlService] Loading '+url);
		isXmlLoading = true;
		
		busy();
		
		xmlLoader = new XmlLoader();
		xmlLoader.onSuccess = Delegate.create( this, onXmlLoaderSuccess );
		xmlLoader.onError = Delegate.create( this, onXmlLoaderError );
		
		if(!xmlLoader.load(url)) {
			notifyError('Undefined URL '+url);
		} else {
			xml = xmlLoader.xml;	
		}
	}
			
	// note, XmlRecordSetService overrides this method.  If you make a change here
	// you should do it there as well
	private function onXmlLoaderSuccess() {
		
		clearTimer();
		
		if(mDebug) Debug.info('[XmlService] onXmlLoaderSuccess');
		
		isXmlLoading = false;
		// if service was cancelled while we were waiting, don't handle the result
		if(cancelled) {
			xmlLoader.destroy();
		} else {	
			onXmlLoaded( xml );
			handleResult( xml )
			notifyComplete();	
		}		
	}
	
	/**
	* Override to save data to app-wide model locator
	* @param	nXml
	* @deprecated use handleResult instead
	*/
	function onXmlLoaded( nXml:XML) {
		result = xmlLoader.getXmlAsObject();
	}
	
	/**
	* Handles xml loader errors
	* 
	* @param	status
	* @param	message
	* @param	url
	*/
	private function onXmlLoaderError(status, message, url) {
		clearTimer();
		isXmlLoading = false;
		if(mDebug) Debug.error( '[XmlService] ERROR: '+message+', url='+url);
		notifyError( xmlLoader.statusMessage );
		xmlLoader.destroy();
	}
	
	// converts an array of nodes to an array of arrays with key/value pairs 
	// that match the property/values pairs in the node attributes objects
	// this is not the ultimate xml 2 object implementation. it is just one
	// way of doing things.  You may want to customize/override for a given application.
	private function nodesToObjects( nodes:Array ) {
		var aData:Array = [];
		var aNode;
		var numval:Number;
		
		for(var n=0; n<nodes.length; ++n) {								
			
			aNode = {};
			for( var prop in nodes[n].attributes) {
				aNode[prop] = nodes[n].attributes[prop];
				numval = Number(aNode[prop]);
				if(!isNaN(numval)) aNode[prop] = numval;
			}
			if(nodes[n].childNodes) {
				for( var c=0; c<nodes[n].childNodes.length; c++) {						
					var el:XMLNode = nodes[n].childNodes[c];
	
					// if nested more than another layer deep, recurse...
					if(el.firstChild.firstChild!=undefined) {	
						//Debug.warn('[NTO] Recursing in to '+el.nodeName);
						aNode[el.nodeName] = nodesToObjects( el.childNodes );
					}
					// just one child, use that child's nodeValue (cdata comes through here)
					else if(el.firstChild.nodeValue!=undefined) {
						//Debug.warn( '[NTO] storing child value for '+el.nodeName);
						aNode['text'] = StringUtil.removeLinebreaks( el.firstChild.nodeValue );						
					}
					// no children, just use the node value
					else {		
						//Debug.warn( '[NTO] storing element value for '+el.nodeName);
						aNode['text'] = StringUtil.removeLinebreaks( el.nodeValue );																
					}						
					// convert numbers to numbers...
					numval = Number(aNode[el.nodeName]);
					if(!isNaN(numval)) aNode[el.nodeName] = numval;						
				}
			}			
			aData.push( aNode );
		}		
		return aData;
	}

	
}
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

/**
* Utility class providing static methods for searching xml objects
* TODO - Probably not very useful anymore
*/
class wilberforce.util.xml.xmlUtility {
	
	/**
	* Searches a node for a child node with a specific nodeName
	* @param tRootNode The node to search within
	* @param tNodeName The nodeName to search for
	* @return The first matching node
	*/
	static function getChildNode(tRootNode,tNodeName:String) {
		for (var i=0;i<tRootNode.childNodes.length;i++) {
			var tNode=tRootNode.childNodes[i];
			if (tNodeName.toLowerCase()==tNode.nodeName.toLowerCase()) {
				return tNode;
			}
		}
	}
	
	/**
	* Searches a node for a child node with a specific nodeName
	* @param tRootNode The node to search within
	* @param tNodeName The nodeName to search for
	* @param stripTabs The nodeName to search for
	* @return The data of the first matching node
	*/
	static function getChildData(tRootNode,tNodeName,stripInvalid:Boolean) {
		var tChildNode=getChildNode(tRootNode,tNodeName);
		var tText=tChildNode.firstChild.nodeValue;
		if (stripInvalid) {
			tText=onlyValidCharacters(tText);
		}
		return tText;
	}
	/**
	* Filters a string to show only valid charactes (removes tabs etc)
	* @param tString The input string
	* @return The filtered string
	*/
	static function onlyValidCharacters(tString) {
		var newString="";
		for (var i=0;i<tString.length;i++) {
			var tChar=tString.charAt(i);
			var tCharCode=tString.charCodeAt(i);
			if (tCharCode>13) {
				newString+=tChar;
			}
		}
		return newString
	}	
}
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


/** Static class provides functions for processing XML data.
*/
class com.moviemasher.Utility.XMLUtility
{

	static function attributeData(node, data)
	{
		if (node == undefined) return undefined;
		if (data == undefined) data = {xmlNode: node};
		for (var k in node.attributes)
		{
			data[k] = flashValue(node.attributes[k]);
		}
		data.nodeName = node.nodeName;
		return data;
	}
	
	static function childData(node, data : Object)
	{
		if (data == undefined) data = {};
		var name : String;
		
		var z = node.childNodes.length;
		var ob;
		var child_node;
		for (var i = 0; i < z; i++)
		{
			name = node.childNodes[i].nodeName;
			if (name.length)
			{
				if (data[name] == undefined) 
				{
					data[name] = [];
				}
				child_node = node.childNodes[i];
				ob = attributeData(child_node);
				childData(child_node, ob);
				data[name].push(ob);
				
			}
		}
		return data;
	}
	
	static function data(node, ob)
	{
		if (ob == undefined) ob = {};
		attributeData(node, ob);
		childData(node, ob);
		return ob;		
	}
	static function flashValue(val)
	{
		if (val == undefined) val = '';
		else
		{
			var new_val = Number(val);
			if (! isNaN(new_val)) 
			{
				if (val.indexOf('.') > -1)
				{
					new_val = parseFloat(val);	
				}
				val = new_val;
			}
		}
		return val;	
	}

	static function nodeData(node, data : Object)
	{
		if (node == undefined) return undefined;
		if (data == undefined) data = {};
		var child;
		var name;
		for (var i = 0; i < node.childNodes.length; i++)
		{
			child = node.childNodes[i];
			name = child.nodeName;
			if (child.firstChild) child = child.firstChild;
			
			data[name] = flashValue(child.nodeValue);
		}
		return data;
	}
	static function findNode(pNode, tagName)
	{
		var z = pNode.childNodes.length;
		var node;
		for (var i = 0; i < z; i++)
		{
			node = pNode.childNodes[i];
			if (node.nodeName == tagName) return node;
		}
		return undefined;
	}
	static function findNodes(pNode, tagName)
	{
		var z = pNode.childNodes.length;
		var node;
		var nodes : Array = [];
		
		for (var i = 0; i < z; i++)
		{
			node = pNode.childNodes[i];
			if (node.nodeName == tagName) nodes.push(node);
		}
		return nodes;
	}

		
}
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

import pl.milib.util.MILibUtil;

/** @author Marek Brun 'minim' */
class pl.milib.util.MIXMLUtil {
	
	static public function getObj(xml:XML):Object {
		return getObjFromXMLNode(xml);
	}//<<
	
	static public function getObjFromXMLNode(node:XMLNode):Object {
		if(node.attributes.XMLparsing=='array'){
			var arr:Array=[];
			for(var i=1,childNode:XMLNode;i<node.childNodes.length-1;i++){
				childNode=node.childNodes[i];
				arr.push(getObjFromXMLNode(childNode));
			} 
			return arr;
		}
		
		
		var obj:Object={xmlNode:node};
		MILibUtil.hideVariables(obj, ['xmlNode']);
		
		for(var i in node.attributes){
			obj[i]=getStrOrNum(node.attributes[i]);
		}
		if(node.childNodes[0].nodeValue!=null){
			var val=node.childNodes[0].nodeValue;
			val=val.split('\r').join('').split('\n').join('');
			if(val.length>1){ obj.nodeValue=getStrOrNum(node.childNodes[0].nodeValue); }
		}
		
		if(node.hasChildNodes()){
			
			var names:Object={};
			
			//counting names
			for(var i=0,childNode:XMLNode;i<node.childNodes.length;i++){
				childNode=node.childNodes[i];
				if(childNode.nodeName==null){ continue; }
				if(names[childNode.nodeName]){
					names[childNode.nodeName].nodes.push(childNode);
				}else{
					names[childNode.nodeName]={isNode:true, nodes:[childNode]};
				}
			}
			
			for(var i in names){
				if(!names[i].isNode){ continue; }
				if(names[i].nodes.length>1){
					//creating array
					obj[i]=[];
					for(var i2=0,childNode:XMLNode;i2<names[i].nodes.length;i2++){
						childNode=names[i].nodes[i2];
						if(childNode.nodeName==i){
							obj[i].push(getObjFromXMLNode(childNode));
						}
					}
				}else{
					obj[i]=getObjFromXMLNode(names[i].nodes[0]);
				}
			}
		}
		
		return obj;
	}//<<
	
	static private function getStrOrNum(val){
		if(val.length>100){ return val; } 
		if(parseInt(val)==val){ return parseInt(val); }
		else if(parseFloat(val)==val){ return parseFloat(val); }
		return val.split('\r').join('');
	}//<<
	
}
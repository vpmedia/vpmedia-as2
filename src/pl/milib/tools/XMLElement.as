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

import pl.milib.core.supers.MIClass;

/**
 * @often_name xmlEle
 * 
 * @author Marek Brun 'minim'
 */
class pl.milib.tools.XMLElement extends MIClass {

	private var name : String;
	private var tab : Array;	private var CDATAs : Array;

	private var elements : Array;
	
	public function XMLElement(name:String) {
		this.name=name;
		clear();
	}//<>
	
	public function add(name:String, value){
		if(value==null || name==null || name==''){ return; }
		var valueS:String=String(value);
		if(valueS.indexOf('<')>-1 || valueS.indexOf('>')>-1 || valueS.indexOf('&')>-1 || valueS.indexOf("'")>-1 || valueS.indexOf('"')>-1){
			CDATAs.push([name, value]);
		}else{
			tab.push([name, value]);
		}
	}//<<
	
	public function addElement(xmlElement:XMLElement):Void {
		elements.push(xmlElement);
	}//<<
	
	public function toString():String{
		var xmlStr:Array=['<'+name];
		for(var p=0;p<tab.length;p++){
			xmlStr.push(tab[p][0]+"='"+tab[p][1]+"'");
		}
		if(CDATAs.length || elements.length){
			xmlStr.push('>');
			for(var p=0;p<CDATAs.length;p++){
				xmlStr.push('<'+CDATAs[p][0]+'><![CDATA['+CDATAs[p][1]+']]></'+CDATAs[p][0]+'>');
			}
			for(var p=0,xmlElement:XMLElement;xmlElement=elements[p];p++){
				xmlStr.push(xmlElement.toString());
			}
			xmlStr.push('</'+name+'>');
		}else{
			xmlStr.push('/>');
		}
		return xmlStr.join(' ');
	}//<<
	
	public function clear(Void):Void{
		tab=[];
		CDATAs=[];
		elements=[];
	}//<<
	
}
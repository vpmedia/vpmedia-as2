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

import pl.milib.core.MIObjSoul;
import pl.milib.core.supers.MIBroadcastClass;
import pl.milib.managers.ObjectsIdNumbersManager;
import pl.milib.util.MILibUtil;
import pl.milib.util.MIStringUtil;

/**
 * @often_name linksProvider
 * 
 * @author Marek Brun 'minim'
 */
class pl.milib.managers.HTMLASFunctionsManager extends MIBroadcastClass {
	
	//nastąpiło naciśnięcie linka
	//DATA:	id:Object
	//		data:FunctionArguments
	public var event_LinkPress:Object={name:'LinkPress'};
	
	private static var instance : HTMLASFunctionsManager;

	private var storage : Object;
	private var storageCount : Number;	private var outVarName:String='HTMLASFunctionsManager_link';	private var WHEN_UNDEFINED_LINK_TITLE:String='[undefined]';
	
	private function HTMLASFunctionsManager(Void) {
		_global.exeASFunction=function(){
			HTMLASFunctionsManager.getInstance().exeLink(arguments[0]);
		};
		storage={};
		storageCount=0;
	}//<>
	
	//<A HREF="asfunction:some,666" TARGET="">fsdg</A>
	
	public function exeLink(sid:String):Void {
		if(!storage[sid]){ return; }
		var ele=storage[sid];
		if(ele.IINM){
			bev(event_LinkPress, {id:ele.id, data:ele.objSoul.o});
		}else{
			bev(event_LinkPress, {id:ele.id, data:ele.data});
		}
	}//<<
	
	public function delLink(id:String):Void {
		delete storage[id];
	}//<<
	
	public function getLink(id:Object, title:String, data:Object):String {
		var ele:Object;
		var dataMilibObj:Object=MILibUtil.getObjectMILibObject(data);
		if(dataMilibObj[outVarName].id==id && storage[dataMilibObj[outVarName].sid]){
			ele=storage[dataMilibObj[outVarName].sid];
			if(!title.length){ title=WHEN_UNDEFINED_LINK_TITLE; }
			if(ele.title!=title){
				if(ele.title==WHEN_UNDEFINED_LINK_TITLE){
					ele.link=MIStringUtil.replace(ele.link, WHEN_UNDEFINED_LINK_TITLE, title);
				}else if(!ele.title.length){ 
					ele.link=MIStringUtil.replace(ele.link, '></A>', '>'+title+'</A>');
				}else{
					ele.link=MIStringUtil.replace(ele.link, ele.title, title);
				}
				ele.title=title;
			}
			return ele.link;
		}
		var sid:String;
		if(!title.length){ title=WHEN_UNDEFINED_LINK_TITLE; }		ele={id:id};
		var dataType=typeof(data);
		if(dataType=="object" || dataType=="array" || dataType=="movieclip"){
			ele.objSoul=MIObjSoul.forInstance(data);
			ele.IINM=ObjectsIdNumbersManager.getInstance().getObjectIdNumber(data);
			sid='si'+ele.IINM;
		}else{
			storageCount++;
			sid='s'+storageCount;
			ele.data=data;
		}
		storage[sid]=ele;
		var link:String='<U><A HREF="asfunction:exeASFunction,'+sid+'">'+title+'</A></U>';
		dataMilibObj[outVarName]=ele;
		ele.sid=sid;
		ele.link=link;		ele.title=title;
		return link;
	}//<<
	
	/** @return singleton instance of HTMLASFunctionsManager */
	static public function getInstance(Void):HTMLASFunctionsManager {
		if (instance == null)
			instance = new HTMLASFunctionsManager();
		return instance;
	}//<<
}
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
 * zajmuje się przechowywaniem obiektów
 * dany obiekt może występować tylko raz
 * obiekty moga być pobierane wg. podanego klucza (przy dodawaniu)
 * lub z tablicy
 * 
 * dzięki przechowywaniu informacji o pozycji bezpośrednio w obiekcie
 * klasa jest maksymalnie szybka (jeśli chodzi o pobieranie wg. identyfikatora)
 * 
 * uzywana gdy potrzebny jest dostęp poprzez tablicę oraz zachodzi potrzeba iteracji
 * 
 * @author Marek Brun 'minim'
 */
class pl.milib.data.IDObjectsHolder extends MIClass {

	private var arr: Array;
	private var objsByID : Object;
	private var outVarsName : String;
	private var owner : Object;
	
	public function IDObjectsHolder(owner:Object) {
		this.owner=owner;
		arr=[];
		objsByID={};
		if(!this['__constructor__'].count){ this['__constructor__'].count=1; }else{ this['__constructor__'].count++; }
		outVarsName='out_NumIDObjectsHolder'+this['__constructor__'].count;
	}//<>
	
	public function addObject(obj:Object, id:String):Boolean{
		if(isAddedObject(obj)){ return false; }
		if(typeof(id)!='string') {
			return false;
		}
		obj[outVarsName+'_id']=id;
		if(!obj[outVarsName+'_id']){
			return false;
		}
		arr.push(obj);
		objsByID[id]=obj;
		return true;
	}//<<
	
	public function delObject(obj:Object):Boolean{
		for(var i=0;i<arr.length;i++){
			if(arr[i]==obj){
				delete objsByID[obj[outVarsName+'_id']];
				delete obj[outVarsName+'_id'];
				arr.splice(i, 1);
				return true;
				break;
			}
		}
		return false;
	}//<<
	
	public function getObjectByID(id:String){
		return objsByID[id];
	}//<<
	
	public function getIDByObject(obj:Object):String{
		return obj[outVarsName+'_id'];
	}//<<
	
	public function getAllObjects():Array{
		return arr;
	}//<<
	
	public function isAddedObject(obj:Object):Boolean{
		return Boolean(obj[outVarsName+'_id']);
	}//<<
	
	public function isAddedID(id:String):Boolean{
		return Boolean(objsByID[id]);
	}//<<
	
}

/*
PASSED TEST:
idObjs.addObject(obj0, 'obj0')>true
idObjs.addObject(obj1, 'obj1')>true
idObjs.addObject(obj0, 'obj0')>false
idObjs.addObject(obj1, 'obj1')>false
idObjs.addObject(null, 'null')>false
[WARNING] (Owner)>obiekt jest typu prymityenego in method:addObject
idObjs.addObject(obj2, 'obj2')>true
idObjs.getAllObjects().length>3
idObjs.delObject(obj2)>true
idObjs.getAllObjects().length>2
idObjs.addObject(obj2, 'obj2')>true
idObjs.getAllObjects().length>3
idObjs.getIDByObject(obj1)>obj1
idObjs.getObjectByID('obj1').name>obj1
idObjs.delObject(obj1)>true
idObjs.getIDByObject(obj1)>undefined
idObjs.getObjectByID('obj1').name>undefined

code:
var infoArr=[];
infoArr.push("idObjs.addObject(obj0, 'obj0')>"+idObjs.addObject(obj0, 'obj0'));
infoArr.push("idObjs.addObject(obj1, 'obj1')>"+idObjs.addObject(obj1, 'obj1'));
infoArr.push("idObjs.addObject(obj0, 'obj0')>"+idObjs.addObject(obj0, 'obj0'));
infoArr.push("idObjs.addObject(obj1, 'obj1')>"+idObjs.addObject(obj1, 'obj1'));
infoArr.push("idObjs.addObject(null, 'null')>"+idObjs.addObject(null, 'null'));
infoArr.push("idObjs.addObject(obj2, 'obj2')>"+idObjs.addObject(obj2, 'obj2'));
infoArr.push('idObjs.getAllObjects().length>'+idObjs.getAllObjects().length+' //3');
infoArr.push("idObjs.delObject(obj2)>"+idObjs.delObject(obj2));
infoArr.push('idObjs.getAllObjects().length>'+idObjs.getAllObjects().length+' //2');
infoArr.push("idObjs.addObject(obj2, 'obj2')>"+idObjs.addObject(obj2, 'obj2'));
infoArr.push('idObjs.getAllObjects().length>'+idObjs.getAllObjects().length+' //3');
infoArr.push('idObjs.getIDByObject(obj1)>'+idObjs.getIDByObject(obj1)+' //obj1');
infoArr.push("idObjs.getObjectByID('obj1').name>"+idObjs.getObjectByID('obj1').name+' //obj1');
infoArr.push("idObjs.delObject(obj1)>"+idObjs.delObject(obj1));
infoArr.push('idObjs.getIDByObject(obj1)>'+idObjs.getIDByObject(obj1)+' //null');
infoArr.push("idObjs.getObjectByID('obj1').name>"+idObjs.getObjectByID('obj1').name+' //null');
info(infoArr.join('\n'));
*/

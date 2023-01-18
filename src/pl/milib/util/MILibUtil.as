import flash.filters.DropShadowFilter;

import pl.milib.managers.MILibManager;
import pl.milib.managers.ObjectsIdNumbersManager;

/**
 * @author Marek Brun 'minim'
 */
class pl.milib.util.MILibUtil {
	
	static public function initMILIB(Void):Void {
		MILibManager.getInstance();
	}//<<
	
	static public function prepareSWF($isShowMenu:Boolean, $align:String, $scaleMode:String, $useCodepage:Boolean):Void {
		Stage.showMenu=$isShowMenu==null ? true : $isShowMenu;
		Stage.align=$align==null ? "TL": $align;
		Stage.scaleMode=$scaleMode==null ? "noScale" : $scaleMode;
		System.useCodepage=$useCodepage==null ? false : $useCodepage;
	}//<<
	
	static function createDelegate(obj:Object, func:Function):Function {
		var deleateFunc=function() {
			return arguments.callee.func.apply(arguments.callee.target, arguments);
		};
		deleateFunc.target=obj;
		deleateFunc.func=func;
		return deleateFunc;
	}//<<
	
	/** @return zwraca obiekt roboczy stworzony dla biblioteki milib */
	static public function getObjectMILibObject(obj:Object):Object {
		if(!obj.milibObject){
			obj.milibObject={};
			hideVariables(obj, ['milibObject']);
		} 
		return obj.milibObject;
	}//<<
	
	static public function delObjectMILibObject(obj:Object):Void {
		delete obj.milibObject;
	}//<<
	
	/** @return zwraca obiekt roboczy stworzony dla biblioteki milib na potrzeby innego obiektu */
	static public function getObjectMILibObjectForObject(fromObj:Object, forObj:Object):Object {
		if(!fromObj.milibObject){
			fromObj.milibObject={};
			hideVariables(fromObj, ['milibObject']);
		} 
		var idNumber:Number=ObjectsIdNumbersManager.getInstance().getObjectIdNumber(forObj);
		if(!fromObj.milibObject['forId'+idNumber]){ fromObj.milibObject['forId'+idNumber]={}; } 
		return fromObj.milibObject['forId'+idNumber];
	}//<<
	
	static public function getMCMILibMC(mc:MovieClip):MovieClip {
		if(!mc.milibMC){
			mc.createEmptyMovieClip('milibMC', mc.getNextHighestDepth());
		}
		return mc.milibMC;
	}//<<
	
	/** @param variables Array of String */
	static public function hideVariables(obj:Object, variables:Array):Void {
		_global.ASSetPropFlags(obj, variables, 1, true);
	}//<<
	
	static public function getMCMILibMCForObject(mc:MovieClip, forObj:Object):MovieClip {
		var milibMC:MovieClip=getMCMILibMC(mc);
		var idNumber:Number=ObjectsIdNumbersManager.getInstance().getObjectIdNumber(forObj);
		if(!milibMC['mcForId'+idNumber]){
			milibMC.createEmptyMovieClip('mcForId'+idNumber, milibMC.getNextHighestDepth());
		}
		return milibMC['mcForId'+idNumber];
	}//<<
	
	static public var smallDropShadow:DropShadowFilter;
	static public function getSmallDropShadow(Void):DropShadowFilter {
		if(!smallDropShadow){
			var distance:Number = 3;
			var angleInDegrees:Number = 45;
			var color:Number = 0x000000;
			var alpha:Number = .4;
			var blurX:Number = 2;
			var blurY:Number = 2;
			var strength:Number = 1;
			var quality:Number = 3;
			var inner:Boolean = false;
			var knockout:Boolean = false;
			var hideObject:Boolean = false;
			smallDropShadow=new DropShadowFilter(distance,angleInDegrees,color,alpha,blurX,blurY,strength,quality,inner,knockout,hideObject);
		}
		return smallDropShadow;
	}//<<
	
	static public function setRootClass(rootClass:Object):Void {
		MILibUtil.getObjectMILibObject(_root).rootClass=rootClass;
	}//<<
	
	static public function getRootClass(Void):Object {
		return MILibUtil.getObjectMILibObject(_root).rootClass;
	}//<<
	
	static public function preparePackagesBySearch(Void):Void {
		//TODO smart search
		_global.somemc=_root;
		var packagesRoots:Array=[];
		for(var i in _global){
			if(typeof(_global[i])=='object'){
				if(isObjPackage(_global[i])){
					packagesRoots.push(i);
				}
			}
		}
		for(var i=0;i<packagesRoots.length;i++){
			preparePackageRecu(_global[packagesRoots[i]], packagesRoots[i]);
		}
	}//<<
	
	static private function preparePackageRecu(package:Object, name:String):Void {
		if(getObjectMILibObject(package).parent){ return; }
		var objMi:Object;
		for(var i in package){
			switch(typeof(package[i])){
				case 'object':
					preparePackageRecu(package[i], name+'.'+i);
					objMi=getObjectMILibObject(package[i]);
					objMi.parent=package;
					objMi.name=i;
					objMi.fullName=name+'.'+i;
				break;
				case 'function':
					getObjectMILibObject(package[i]).package=package;
					getObjectMILibObject(package[i]).name=i;
				break;
			}
		}
	}//<<
	
	static private function initPackageMethods(package:Object):Void {
		if(getObjectMILibObject(package).isInitMethods){ return; }
		getObjectMILibObject(package).isInitMethods=true;
		var objMi:Object;
		for(var i in package){
			switch(typeof(package[i])){
				case 'object':
					initPackageMethods(package[i]);
				break;
				case 'function':
					initMethods(package[i]);
				break;
			}
		}
	}//<<
	
	static public function isObjPackage(package:Object):Boolean {
		var type:String;
		for(var i in package){
			type=typeof(package[i]);
			if(type=='object'){
				if(!isObjPackage(package[i])){
					return false;
				}
			}else if(type!='function'){
				return false;
			} 
		}
		return true;
	}//<<
	
	static public function getPackageFullNameByInstance(instance:Object):String {
		return getObjectMILibObject(getObjectMILibObject(instance['__constructor__']).package).fullName;
	}//<<
	
	static public function getPackageNameByInstance(instance:Object):String {
		return getObjectMILibObject(getObjectMILibObject(instance['__constructor__']).package).name;
	}//<<
	
	static public function getClassNameByInstance(instance:Object):String {
		return getObjectMILibObject(instance['__constructor__']).name;
	}//<<
	
	static public function getClassSuperNameByInstance(instance:Object):String {
		return getObjectMILibObject(getSuperByInstance(instance)).name;
	}//<<
	
	static public function getSuperByInstance(instance:Object):Object {
		return instance['__constructor__']['prototype']['__constructor__'];
	}//<<
	
	static public function getSuperByConstructor(const:Object):Object {
		return const['prototype']['__constructor__'];
	}//<<
	
	static public function getClassNameByConstructor(const:Object):String {
		return getObjectMILibObject(const).name;
	}//<<
	
	static public function getConstructor(obj:Object):Object {
		return obj['__constructor__'];
	}//<<
	
	static public function initConstructor(constr:Object):Void {
		if(getObjectMILibObject(constr).isIni){ return; }
		
		var constrTmp=constr;
		while(constrTmp){
			_global.ASSetPropFlags(constrTmp['prototype'], null, 0, true);
			_global.ASSetPropFlags(constrTmp['prototype'], ["__proto__", "constructor", "__constructor__", "prototype"], 1, true);
			constrTmp=constrTmp['prototype']['__constructor__'];
		}
		getObjectMILibObject(constr).isIni=true;
	}//<<
	
	static private function initMethods(constr:Object):Void {
		if(getObjectMILibObject(constr).methods){ return; }
		
		initConstructor(constr);
		
		var allMethodsNames:Array=[];
		for(var i in constr['prototype']){				
			if(typeof(constr['prototype'][i])=='function'){
				allMethodsNames.push(i);
				constr['prototype'][i].name=i;
				constr['prototype'][i].constr=constr;
			}
		}
		
		var prentProto;
		var supersNames:Array=[];
		var methodNames:Array;
		var constrTmp=constr;
		while(constrTmp){
			methodNames=[];
			prentProto=constrTmp['prototype']['__constructor__']['prototype'];
			for(var i=0;i<allMethodsNames.length;i++){
				if(!prentProto[allMethodsNames[i]]){
					methodNames.push(allMethodsNames[i]);
					allMethodsNames.splice(i, 1);i--;
				}
			}
			methodNames.sort();
			supersNames.push({className:getObjectMILibObject(constrTmp).name, methods:methodNames});
			constrTmp=constrTmp['prototype']['__constructor__'];
		}
		getObjectMILibObject(constr).methods=supersNames;
	}//<<
	
	/** @return Array of {className:String, methods:Array of String} */
	static public function getClassMetodsNamesByInstance(instance:Object):Array {
		var constr=instance['__constructor__'];
		initMethods(constr);
		return getObjectMILibObject(constr).methods;
	}//<<
	
	static public function getMethodName(obj:Object, method:Function):String {
		initMethods(getConstructor(obj));
		var name:String=method.name;
		if(name){
			if(!obj[name]){ return null; }
			return name;
		}else{
			for(var i in obj){
				if(obj[i]===method){
					return i;
				}
			} 
		}
	}//<<
	
	static public function getMethodNameByMethod(method:Function):String {
		return method.name;
	}//<<
	
	static public function getConstructorByMethod(method:Function):Object {
		return method.constr;
	}//<<
	
	static public function getClassNameByMethod(method:Function):String {
		return getObjectMILibObject(method.constr).name;
	}//<<
	
	static public function openClassDBGWindow(instance:Object):Void {
		_global.pl.minim.dbg.MIDBG.getInstance().openObjectWindow(instance);
	}//<<

}
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

import flash.filters.DropShadowFilter;

import pl.milib.managers.HTMLASFunctionsManager;
import pl.milib.managers.ObjectsIdNumbersManager;
import pl.milib.mc.service.MIMC;
import pl.milib.util.MILibUtil;
import pl.milib.util.MIStringUtil;

/** @author Marek Brun 'minim' */
class pl.milib.dbg.MIDBGUtil {
	
	static public var LINKDBGID_Object:Object={name:'LINKDBG_Object'};
	static public var LINKDBGID_Array:Object={name:'LINKDBG_Array'};
	static public var LINKDBGID_MovieClip:Object={name:'LINKDBG_MovieClip'};	static public var LINKDBGID_String:Object={name:'LINKDBGID_String'};
	
	static public function getArgumentsText(args:FunctionArguments):String{
		return '('+links(args)+')'; 
	}//<<
	
	static public function getValueHTML(value):String{
		if(value==null){
			return '<b>null</b>';
		}else if(value instanceof Object){
			return 'obj|';
		}else{
			return value; 
		}
	}//<< 
	
	static public function link(value):String{
		if(value==null){ return 'null'; }
		if(value instanceof TextField){
			return HTMLASFunctionsManager.getInstance().getLink(LINKDBGID_Object, 'tf|'+value._parent._parent._name+'.'+value._parent._name+'.'+value._name, value);
		}else if(value instanceof Array){
			return HTMLASFunctionsManager.getInstance().getLink(LINKDBGID_Array, 'a|'+value.length, value);
		}else if(value instanceof Date){
			return 'date|'+Date(value).toString();
		}else{
			switch(typeof(value)){
				case "string":
					if(value.length>20){
						return HTMLASFunctionsManager.getInstance().getLink(LINKDBGID_String, 's|'+MIStringUtil.safeHTML(value.substr(0, 20))+' ...('+value.length+')', value);
					}else{
						return 's|'+MIStringUtil.safeHTML(value);
					}
				break;
				case "number":
					return 'n|'+value;
				break;
				case "boolean":
					return 'b|'+value;
				break;
				case "movieclip":
					return HTMLASFunctionsManager.getInstance().getLink(LINKDBGID_MovieClip, 'mc|'+value._parent._parent._name+'.'+value._parent._name+'.'+value._name, value);
				break;
				case "object":
					if(value instanceof Button){
						return HTMLASFunctionsManager.getInstance().getLink(LINKDBGID_MovieClip, 'btn|'+value._parent._parent._name+'.'+value._parent._name+'.'+value._name, value);
					}else{
						var className:String=MILibUtil.getClassNameByInstance(value);
						var title:String;
						if(className){
							title=formatClassNameText(className);
							if(typeof(value.name)=='string' && value.name.length){
								title+='(name:'+value.name+')';
							}
							if(typeof(value.id)=='string' && value.id.length){
								title+='(id:'+value.id+')';
							}
							return HTMLASFunctionsManager.getInstance().getLink(LINKDBGID_Object, title, value);
						}else{
							var valueValues:Array=[];
							var valueValuesCount=4;
							for(var i in value){
								valueValues.push('<b>'+i+'</b>:'+link(value[i]));
								valueValuesCount--;
								if(!valueValuesCount){ valueValues.push('...'); break; }
							}
							title='o|';
							return HTMLASFunctionsManager.getInstance().getLink(LINKDBGID_Object, title, value)+'{'+valueValues.join(', ')+'}';
						}
					}
				break;
				case "function":
					return 'f|'+value;
				break;
			}
		}
		return '?';
	}//<<
	
	static public function links(links:Array):String{
		var tab:Array=[];
		for(var i=0;i<links.length;i++){
			tab.push(link(links[i]));
		}
		return tab.join(', ');
	}//<<
	
	static public function formatASText(asText:String):String {
		return '<FONT FACE="Tahoma" SIZE="10" COLOR="#006699">'+asText+'</FONT>';
	}//<<
	
	static public function formatMethodNameText(methodName:String):String {
		return '<FONT FACE="Georgia" SIZE="10" COLOR="#005980">'+methodName+'</FONT>';
	}//<<
	
	static public function formatClassNameText(className:String):String {
		return '<FONT FACE="Georgia" SIZE="10" COLOR="#7F0055">'+className+'</FONT>';
	}//<<
	
	static public function formatErrorText(errorText:String):String {
		return '<FONT COLOR="#FF0000">'+errorText+'</FONT>';
	}//<<
	
	static public function formatBadArgs(args:FunctionArguments, badArgNum:Number, $argsNames:Array):String {
		var argsStr:Array=[];
		for(var i=0,str:String,valStr:String;i<args.length || i<badArgNum || (i<$argsNames.length && $argsNames.length);i++){
			str=args[i]==null ? 'null' : link(args[i]);
			if($argsNames[i]){
				str=$argsNames[i]+'='+str;
			}
			if(i==badArgNum){
				argsStr.push(formatErrorText(str));
			}else{
				argsStr.push(str);
			}
		}
		return '('+argsStr.join(', ')+')';
	}//<<
	
	static public function formatArgs(args:FunctionArguments, $argsNames:Array):String {
		var argsStr:Array=[];
		for(var i=0,str:String,valStr:String;i<args.length;i++){
			if($argsNames[i]){
				str=$argsNames[i]+'='+link(args[i]);
			}else{
				str=link(args[i]);
			}
			argsStr.push(str);
		}
		return '('+argsStr.join(', ')+')';
	}//<<
	
	static public function stringifyObject(obj):String{
		if(!obj){ return '[undefined]'; }
		var vars:Array=[];
		for(var i in obj){
			vars.push('	<b>'+i+'</b>: '+link(obj[i]));
		}
		return 'Object ID:'+ObjectsIdNumbersManager.getInstance().getObjectIdNumber(obj)+' {\n'+vars.join('\n')+'\n}';
	}//<<
	
	static public function stringifyArray(obj:Array):String{
		if(!obj){ return '[undefined]'; }
		if(!obj.length){ return '[empty]'; }
		var vars:Array=[];
		for(var i=0;i<obj.length;i++){
			vars.push('	['+i+']'+link(obj[i]));
		}
		return 'Array ID:'+ObjectsIdNumbersManager.getInstance().getObjectIdNumber(obj)+'<b>[</b>\n'+vars.join('<b>,\n</b>')+'<b>\n]</b>';
	}//<<
	
	static public function stringifyArrayParams(obj:Array, paramName:String):String{
		if(!obj){ return '[undefined]'; }
		if(!obj.length){ return '[empty]'; }
		var vars:Array=[];
		for(var i=0;i<obj.length;i++){
			vars.push('['+i+']'+link(obj[i][paramName]));
		}
		return 'Array['+paramName+'] ID:'+ObjectsIdNumbersManager.getInstance().getObjectIdNumber(obj)+' <b>[</b>\n	'+vars.join('<b>,\n	</b>')+' <b>\n]</b>';
	}//<<
	
	static public function getObjContextText(obj:Object):String {
		var milibObj:Object=MILibUtil.getObjectMILibObject(obj);
		if(milibObj.contextText){
			return milibObj.contextText;
		}else{
			var className:String=MILibUtil.getClassNameByInstance(obj);
			if(obj.getContextText){
				milibObj.contextText=obj.getContextText();
			}else if(obj.getInstance && className){
				return milibObj.contextText=MILibUtil.getClassNameByInstance(obj);
			}else{
				var mc:MovieClip;
				if(obj.mc){
					mc=obj.mc;
				}else if(obj.mimc){
					mc=obj.mimc.mc;
				}else{
					for(var i in obj){
						if(obj[i] instanceof MovieClip){					
							if(!mc || obj[i]._name.length<mc._name.length){
								mc=obj[i];
							}
						}else if(obj[i] instanceof MIMC){
							if(obj[i].mc._name.length<mc._name.length || !mc){
								mc=obj[i].mc;
							}
						}
					}
				}
				if(mc){
					milibObj.contextText=mc._target.split('/').join('_');
					if(className){
						milibObj.contextText=className+milibObj.contextText;
					}
				}
			}
			return milibObj.contextText;
		}
	}//<<
	
	static private var dropShadow:DropShadowFilter;
	static public function getStandartDropShadow(Void):DropShadowFilter{
		if(!dropShadow){
			var distance:Number = 5;
			var angleInDegrees:Number = 45;
			var color:Number = 0x000000;
			var alpha:Number = .8;
			var blurX:Number = 8;
			var blurY:Number = 8;
			var strength:Number = .5;
			var quality:Number = 3;
			var inner:Boolean = false;
			var knockout:Boolean = false;
			var hideObject:Boolean = false;
			dropShadow=new DropShadowFilter(distance,angleInDegrees,color,alpha,blurX,blurY,strength,quality,inner,knockout,hideObject);
		}
		return dropShadow;
	}//<<
	
	static public function getMCSelectionHolder(mc:MovieClip):MovieClip {
		if(!MILibUtil.getMCMILibMC(mc).dbgSel){
			MILibUtil.getMCMILibMC(mc).dbgSel=MILibUtil.getMCMILibMC(mc).createEmptyMovieClip('dgbSel', MILibUtil.getMCMILibMC(mc).getNextHighestDepth());
		}
		return MILibUtil.getMCMILibMC(mc).dbgSel;
	}//<<
	
	static public function selectMC(mc:MovieClip):Void {
		if(!mc){ return; }
		var sel:MovieClip=getMCSelectionHolder(mc);
		var rect:Object=mc.getRect(mc);
		sel.lineStyle(2, 0xFFFF00, 100, false, 'none', 'square', 'miter', 8);
		sel.moveTo(rect.xMin, rect.yMin);
		sel.lineTo(rect.xMax, rect.yMin);
		sel.lineTo(rect.xMax, rect.yMax);
		sel.lineTo(rect.xMin, rect.yMax);
		sel.lineTo(rect.xMin, rect.yMin);
	}//<<
	
	static public function deselectMC(mc:MovieClip):Void {
		getMCSelectionHolder(mc).clear();
	}//<<
	
	/** @return {localVars:Array of String, protoVars:Array of String} */
	static public function getClassVariablesNamesByInstance(instance:Object):Object {
		
		var constr=instance['__constructor__'];
		MILibUtil.initConstructor(constr);
		
		var protoVarsCheck:Object={};
		var protoVars:Array=[];
		for(var i in constr['prototype']){	
			if(typeof(constr['prototype'][i])!='function'){
				protoVars.push(i);
				protoVarsCheck[i]=true;
			}
		}
		
		var localVars:Array=[];
		for(var i in instance){
			if(!protoVarsCheck[i] && typeof(instance[i])!='function'){
				if(typeof(instance[i])=='object') {
					if(instance[i].constructor){
						localVars.push(i);
					}
				}else{
					localVars.push(i);
				}
			}
		}
		
		return {
			localVars:getSortedVariablesList(instance, localVars),
			protoVars:getSortedVariablesList(instance, protoVars)
		};
	}//<<
	
	static private function getSortedVariablesList(valuesOwner:Object, names:Array):Array{
		names.sort('name', Array.CASEINSENSITIVE);
		var tab:Array=[];
		for(var i=0,vl:Object,name:String;name=names[i];i++){
			vl=valuesOwner[name];
			if(vl==null){ tab.push({power:30, name:name}); }
			if(vl instanceof Array){
				tab.push({power:92, name:name});
			}else{
				switch(typeof(vl)){
					case "object":
						tab.push({power:93, name:name});
					break;
					case "string":
						tab.push({power:90, name:name});
					break;
					case "number":
						tab.push({power:80, name:name});
					break;
					case "boolean":
						tab.push({power:70, name:name});
					break;
					case "movieclip":
						tab.push({power:91, name:name});
					break;
					case "function":
						tab.push({power:40, name:name});
					break;
				}
			}
			
		}
		tab.sortOn('power', Array.NUMERIC);
		tab.reverse();
		var tabR:Array=[];
		for(var i=0,vl;vl=tab[i];i++){
			tabR.push(vl.name);
		}
		return tabR;
	}//<<
	
	static public function logStaticMethodBadArgs(args:FunctionArguments, badArgNum:Number, $argsNames:Array):Void {
		if(args.caller){
			var callerInfo:String;
			if(typeof(args.caller)=='function'){
				callerInfo=MILibUtil.getClassNameByConstructor(args.caller);
			}else{
				callerInfo=link(args.caller);
			}
			_root.log(MILibUtil.getClassNameByMethod(args.callee)+'.'+formatErrorText(MILibUtil.getMethodNameByMethod(args.callee))+formatBadArgs(args, badArgNum, $argsNames)+', caller>'+callerInfo);
		}else{
			_root.log(MILibUtil.getClassNameByMethod(args.callee)+'.'+formatErrorText(MILibUtil.getMethodNameByMethod(args.callee))+formatBadArgs(args, badArgNum, $argsNames));
		}
	}//<<
	
	public static function getFormatedMethodName(obj:Object, method:Function):String {
		if(method==MILibUtil.getConstructor(obj)){ return formatMethodNameText('constructor'); }
		else{ return formatMethodNameText(MILibUtil.getMethodName(obj, method)); }
	}//<<
	
	public static function getErrorFormatedMethodName(obj:Object, method:Function):String {
		if(method==MILibUtil.getConstructor(obj)){ return formatErrorText('constructor'); }
		else{ return formatErrorText(MILibUtil.getMethodName(obj, method)); }
	}//<<

}
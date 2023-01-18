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
import pl.milib.data.TextModel;
import pl.milib.dbg.MIDBG;
import pl.milib.dbg.MIDBGUtil;
import pl.milib.dbg.window.contents.DBGWindowMethodsContent;
import pl.milib.dbg.window.contents.DBGWindowTextContent;
import pl.milib.dbg.window.contents.InstanceInfoTextModel;
import pl.milib.managers.EnterFrameRenderManager;
import pl.milib.util.MILibUtil;

/**
 * @author Marek Brun 'minim'
 */
class pl.milib.dbg.InstanceDebugProvider {
	
	public var logger : TextModel;
	public var info : InstanceInfoTextModel;
	private var obj : Object;
	
	private function InstanceDebugProvider(obj:Object) {
		_global.isCreatingNewInstanceDebugProvider=true;
		this.obj=obj;
		logger=new TextModel(true, 100);
		info=InstanceInfoTextModel.forInstance(obj);
		EnterFrameRenderManager.getInstance().addRenderMethod(this, tryAutoOpen, true);
		tryAutoOpen();
		
		delete _global.isCreatingNewInstanceDebugProvider;
	}//<>
	
	private function tryAutoOpen(Void):Void {
		MIDBG.getInstance().tryAutoOpen(obj);
	}//<<
	
	public function getDebugContentsForMIClass() : Array {
		DBGWindowTextContent.forInstance(logger).setName('log');
		DBGWindowTextContent.forInstance(info).setName('info');
		return [
			DBGWindowMethodsContent.forInstance(obj),
			DBGWindowTextContent.forInstance(logger),
			DBGWindowTextContent.forInstance(info)
		];
	}//<<
	
	public function getDBGInfoforMIClass(Void):String {
		var deletingSubs:Array=obj.getDeleter().deletingSub.concat();
		deletingSubs.shift();
		var infos:Array=[
			'subscriptions: '+MIDBGUtil.stringifyArrayParams(obj.subscriptions, 'o'),
			'deleting subs: '+MIDBGUtil.stringifyArray(deletingSubs),
			'deleting sub of: '+MIDBGUtil.stringifyArrayParams(obj.getDeleter().deleteSubOf, 'o'),
			'finishs when delete: '+MIDBGUtil.stringifyArray(obj.getDeleter().finishWhenDelete)
		];
		return infos.join('\n');
	}//<<
	
	public function log(text:String, $method:Function):Void {
		if(!text){ text=''; }
		logger.addTextNoRepeat(text);
		if($method){
			MIDBG.getInstance().addObjLogText('.'+MIDBGUtil.getFormatedMethodName(obj, $method)+' '+text, obj);
		}else{
			MIDBG.getInstance().addObjLogText(text, obj);
		}
	}//<<
	
	public function logHistory(text:String, $method:Function):Void {
		logger.addTextNoRepeat('Hist: '+text);
		if($method){
			MIDBG.getInstance().addObjHistoryLogText('.'+MIDBGUtil.getFormatedMethodName(obj, $method)+' '+text, obj);
		}else{
			MIDBG.getInstance().addObjHistoryLogText(text, obj);
		}
	}//<<
	
	private function logMethod(args:FunctionArguments, $text:String):Void {
		var logText:String=MIDBGUtil.getFormatedMethodName(obj, args.callee)+MIDBGUtil.getArgumentsText(args)+getCallerText(args);
		if($text==null){
			log(logText);
		}else{
			log(logText+'\n^^^(<i>'+$text+'</i>)');
		}
	}//<<
	
	private function logError_UnexpectedArg(args:FunctionArguments, badArgNum:Number, $argsNames:Array, $errorText:String):Void {
		var logText:String=[
			MIDBGUtil.getErrorFormatedMethodName(obj, args.callee),
			MIDBGUtil.formatBadArgs(args, badArgNum, $argsNames),
			getCallerText(args)
		].join('');
		var con:String=MIDBGUtil.getObjContextText(obj);
		if($errorText==null){
			log(logText+(con==null ? '' : '\n'+con));
		}else{
			log(logText+'\n^^^(<i>'+$errorText+'</i>)'+(con==null ? '' : '\n'+con));
		}
	}//<<
	
	private function logError_UnexpectedSituation(args:FunctionArguments, errorText:String):Void {
		var logText:String=[
			MIDBGUtil.getFormatedMethodName(obj, args.caller),
			MIDBGUtil.formatArgs(args)
		].join('');
		var con:String=MIDBGUtil.getObjContextText(obj);
		log(logText+'\n^^^'+MIDBGUtil.formatErrorText('UnexpectedSituation')+': <b>'+errorText+'</b>'+(con==null ? '' : '\n'+con));
	}//<<
	
	private function getCallerText(args:FunctionArguments):String {
		if(args.caller){
			var callerName:String=MILibUtil.getMethodName(obj, args.caller);
			if(callerName){
				return ' caller:'+MIDBGUtil.formatMethodNameText(callerName);
			}else{
				var callerClassName:String=MILibUtil.getClassNameByMethod(args.caller);
				if(callerClassName){
					return ' caller:'+MIDBGUtil.formatClassNameText(callerClassName)+'.'+MIDBGUtil.formatMethodNameText(MILibUtil.getMethodNameByMethod(args.caller));
				}
			}
		}
		return '';
	}//<<
	
	public function logv(name:String, value):Void {
		MIDBG.getInstance().addValueLog(name, value);
	}//<<
	
	public function link(value):String {
		return MIDBGUtil.link(value);
	}//<<

	public function setCookie(cookieObj:Object):Void {
		DBGWindowMethodsContent.forInstance(obj).setCookie(cookieObj);
	}//<<
	
	static public function forInstance(obj:Object):InstanceDebugProvider {
		if(_global.isCreatingNewInstanceDebugProvider){ return null; } 
		var milibObjObj:Object=MILibUtil.getObjectMILibObject(obj);
		if(!milibObjObj.forInstanceDebugProvider.o){ milibObjObj.forInstanceDebugProvider=MIObjSoul.forInstance(new InstanceDebugProvider(obj)); }
		return milibObjObj.forInstanceDebugProvider.o;
	}//<<
	
	static public function hasInstance(obj:Object):Boolean {
		return MILibUtil.getObjectMILibObject(obj).forInstanceDebugProvider.o!=null;
	}//<<

}
import flash.geom.Point;

import pl.milib.core.supers.MIBroadcastClass;
import pl.milib.managers.EnterFrameBroadcaster;
import pl.milib.managers.EnterFrameReciver;
import pl.milib.mc.service.MIButton;
import pl.milib.mc.service.MITextField;
import pl.milib.mc.service.MXCOwner;
import pl.milib.util.MIArrayUtil;
import pl.milib.util.MILibUtil;
import pl.milib.util.MIMCUtil;

/**
 * var name: mimc*
 * 
 * @author Marek Brun 'minim'
 */
class pl.milib.mc.service.MIMC extends MIBroadcastClass implements EnterFrameReciver {
	
	//nastąpiło wczytanie
	public var event_Load:Object={name:'Load'};
	
	//nastąpiło wejście w pierwszą schwytaną klatkę
	public var event_EnterFirstCatchedFrame:Object={name:'EnterFirstCatchedFrame'};
	
	//nastąpiło wejście w nową klatkę
	public var event_EnterNewFrame:Object={name:'EnterNewFrame'};
	
	//nastąpiło wejście w pierwszą klatkę
	public var event_EnterFirstFrame:Object={name:'EnterFirstFrame'};
	
	//nastąpiło wejście w ostatnią klatkę
	public var event_EnterLastFrame:Object={name:'EnterLastFrame'};
	
	//nastąpiło wejście w docelową klatkę
	//DATA: Object
	public var event_EnterTargetFrame:Object={name:'EnterTargetFrame'};
	
	//nastąpiło wejście w klatkę obserwowanego klpu
	//DATA:	name:String
	//		mc:MovieClip
	public var event_WatchedMCEnterFrame:Object={name:'WatchedMCEnterFrame'};
	
	//nastąpiło wyjście z klatki obserwowanego klpu
	//DATA:	name:String
	public var event_WatchedMCOutFrame:Object={name:'WatchedMCOutFrame'};
	
	//nastąpiło wejście w obserwowaną klatkę
	//DATA:	Number or String//frame
	public var event_WatchedFrameEnter:Object={name:'event_WatchedFrameEnter'};
	
	//nastąpiło wyjście z obserwowanej klatki
	//DATA:	Number//frame
	public var event_WatchedFrameOut:Object={name:'event_WatchedFrameOut'};
	
	public var watchedStatus_Out:Object={name:'Out'};
	public var watchedStatus_In:Object={name:'In'};
	
	public var mc : MovieClip;
	private var inMCs : Array; //of MovieClip
	private var isWatchingEnterFrame : Boolean;
	private var watchedMCSData : Array;
	private var frame : Number;
	private var targetFrame : Object;
	private var mappedMCS : Array;	static private var DBG_WIN_INI : String='info';
	private var isMCSelfUnload : Boolean;
	public var isLoad : Boolean;
	private var mcxOwners : Array;
	private var watchedFramesData : Array;
	private var name : String;
	
	private function MIMC(mc:MovieClip) {
		this.mc=mc;
		name=mc._name;
		inMCs=[];
		frame=-1;
		mc.onLoad=MILibUtil.createDelegate(this, onMCLoad);		mc.onUnload=MILibUtil.createDelegate(this, onMCUnload);
	}//<>
	
	public function addMappedFramesMC(mappedMC:MovieClip):Void {
		if(!mappedMCS){ mappedMCS=[]; }
		setIsWatchingEnterFrame(true);
		mappedMCS.push(mappedMC);
	}//<<
	
	public function getServicedObject(Void):MovieClip {
		return mc;
	}//<<
	
	public function gotoAndPlay(frame:Object){
		delete targetFrame;
		mc.gotoAndPlay(frame);
	}//<<
	
	public function gotoAndStop(frame:Object){
		delete targetFrame;		mc.gotoAndStop(frame);
	}//<<
	
	public function stop(){
		delete targetFrame;
		mc.stop();
	}//<<
	
	public function play(){
		delete targetFrame;
		mc.play();
	}//<<
	
	public function nextFrame(Void):Void {
		delete targetFrame;
		mc.nextFrame();
	}//<<
	
	public function prevFrame(Void):Void {
		delete targetFrame;		mc.prevFrame();
	}//<<
	
	public function getFirstMC(Void):MovieClip {
		for(var i in mc){
			if(mc[i]._parent==mc){
				return mc[i];
			}
		}
	}//<<
	
	public function gotoAndGetFirstMC(frame):MovieClip {
		mc.gotoAndStop(frame);
		return getFirstMC();
	}//<<
	
	public function gotoLastFrame(Void):Void {
		gotoAndStop(mc._totalframes); 
	}//<<
	
	public function setIsWatchingEnterFrame(bool:Boolean){
		if(isWatchingEnterFrame==bool){ return; }
		isWatchingEnterFrame=bool;
		if(isWatchingEnterFrame){
//			mc.onEnterFrame=MILibUtil.createDelegate(this, onEnterFrame);
			EnterFrameBroadcaster.start(this);
		}else{
//			delete mc.onEnterFrame;
			EnterFrameBroadcaster.stop(this);
		}
	}//<<
	
	public function addWatchForMC(name:String):Void{
		if(MIArrayUtil.gotVar(watchedMCSData, 'name', name)){ return/*...alredy*/; }
		setIsWatchingEnterFrame(true);
		if(!watchedMCSData){ watchedMCSData=[]; }
		watchedMCSData.push({name:name, status:watchedStatus_Out});
		checkMCS();
	}//<<
	
	public function addWatchForMCS(names:Array):Void{
		for(var i=0,name:String;i<names.length;i++){
			name=names[i];
			addWatchForMC(name);
		}
	}//<<
	
	public function checkMCS(Void):Void{
		for(var i=0,watchedMCData;watchedMCData=watchedMCSData[i];i++){
			if(mc[watchedMCData.name]){
				if(watchedMCData.status==watchedStatus_Out){
					watchedMCData.status=watchedStatus_In;
					//TODO auto duplicat
					bev(event_WatchedMCEnterFrame, {name:watchedMCData.name, mc:mc[watchedMCData.name]});
				}
			}else{
				if(watchedMCData.status==watchedStatus_In){
					watchedMCData.status=watchedStatus_Out;
					bev(event_WatchedMCOutFrame, {name:watchedMCData.name});
				}
			}
		}
	}//<<
	
	public function addWatchForFrame(frameToWatch/*String or Number*/):Void{
		if(MIArrayUtil.gotVar(watchedFramesData, 'frameOrg', frameToWatch)){ return/*...alredy*/; }
		setIsWatchingEnterFrame(true);
		if(!watchedFramesData){ watchedFramesData=[]; }
		var frameNumber:Number=MIMCUtil.getFrameNumber(mc, frameToWatch);
		watchedFramesData.push({frameNumber:frameNumber, frameOrg:frameToWatch, status:watchedStatus_Out});
		checkWatchedFrames();
	}//<<
	
	public function addWatchForFrames(farmesToWatch:Array):Void{
		for(var i=0;i<farmesToWatch.length;i++){ addWatchForFrame(farmesToWatch[i]); }
	}//<<
	
	public function getIsFrameNow(farmeNow/*String or Number*/):Boolean {
		return mc._currentframe==MIMCUtil.getFrameNumber(mc, farmeNow);
	}//<<
	
	public function checkWatchedFrames(Void):Void{
		for(var i=0,watchedFrameData;watchedFrameData=watchedFramesData[i];i++){
			if(mc._currentframe==watchedFrameData.frameNumber){
				if(watchedFrameData.status==watchedStatus_Out){
					watchedFrameData.status=watchedStatus_In;
					bev(event_WatchedFrameEnter, watchedFrameData.frameOrg);
				}
			}else{
				if(watchedFrameData.status==watchedStatus_In){
					watchedFrameData.status=watchedStatus_Out;
					bev(event_WatchedFrameOut, watchedFrameData.frameOrg);
				}
			}
		}
	}//<<
	
	public function playTo(targetFrameNumber:Number, playID:Object){
		setIsWatchingEnterFrame(true);
		if(!targetFrameNumber){ targetFrameNumber=mc._totalframes; }
		targetFrame={num:targetFrameNumber, id:playID};
		mc.stop();
		if(mc._currentframe==targetFrameNumber){ setPlayToEnd(); }
	}//<<
	public function playToByAnchor(targetAnchorName:String, playID:Object){
		playTo(MIMCUtil.getFrameNumber(mc, targetAnchorName), playID);
	}//<<
	public function playToByTotalframes(targetFramesN01:Number, playID:Object){
		playTo(1+int(targetFramesN01*(mc._totalframes-1)), playID);
	}//<<
	
	private function stepToTargetFrame(){
		var cf:Number=mc._currentframe;
		if(cf<targetFrame.num){
			mc.nextFrame();
		}else if(cf>targetFrame.num){
			mc.prevFrame();
		}else{
			setPlayToEnd();
		}
	}//<<
	
	private function setPlayToEnd(){
		mc.stop();
		if(targetFrame.id){
			var id=targetFrame.id;
			delete targetFrame;
			bev(event_EnterTargetFrame, id);
		}
		delete targetFrame;
	}//<<
	
	public function isInLastFrame(Void):Boolean {
		return mc._currentframe==mc._totalframes;
	}//<<
	
	public function isInFirstFrame(Void):Boolean {
		return mc._currentframe==1;
	}//<<
	
	public function getMCS(instancePrefixName:String):Array {
		var mcs:Array=[];
		for(var i=0,mcIn:MovieClip;mcIn=g(instancePrefixName+i, true);i++){
			mcs.push(mcIn);
		}
		return mcs;
	}//<<
	
	public function g(instanceName:String, $isNoLogNoMC:Boolean):MovieClip {
		if(inMCs[instanceName]){
			return inMCs[instanceName];
		}else{
			var instanceNames:Array=instanceName.split('.');
			var mcIn:MovieClip=mc;
			while(instanceNames.length){ mcIn=mcIn[instanceNames.shift()]; }
			inMCs[instanceName]=mcIn;
			if(!mcIn && !$isNoLogNoMC){ logError_UnexpectedArg(arguments, 0, ['instanceName:String'], 'no MC with name "'+instanceName+'"'); }
			return mcIn;
		}
	}//<<
	
	public function getInstance(instanceName:String, $isNoLogNoMC:Boolean) {
		if(inMCs[instanceName]){
			return inMCs[instanceName];
		}else{
			var instanceNames:Array=instanceName.split('.');
			var mcIn:MovieClip=mc;
			while(instanceNames.length){ mcIn=mcIn[instanceNames.shift()]; }
			inMCs[instanceName]=mcIn;
			if(!mcIn && !$isNoLogNoMC){ logError_UnexpectedArg(arguments, 0, ['instanceName:String'], 'no MC with name "'+instanceName+'"'); }
			return mcIn;
		}
	}//<<
	
	public function getMIMC(instanceName:String, $isNoLogNoMC:Boolean):MIMC {
		return forInstance(g(instanceName, $isNoLogNoMC));
	}//<<
	
	public function getButton(instanceName:String, $isNoLogNoMC:Boolean):Button {
		return Button(g(instanceName, $isNoLogNoMC));
	}//<
	
	public function getTextField(instanceName:String, $isNoLogNoMC:Boolean):TextField {
		return TextField(g(instanceName, $isNoLogNoMC));
	}//<<
	
	public function getMIButton(instanceName:String, $isNoLogNoMC:Boolean):MIButton {
		return MIButton.forInstance(getInstance(instanceName, $isNoLogNoMC));
	}//<<
	
	public function getMITextField(instanceName:String, $isNoLogNoMC:Boolean):MITextField {
		return MITextField.forInstance(getInstance(instanceName, $isNoLogNoMC));
	}//<<
	
	private function doDelete(Void):Void {
		mc.onUnload=null;
		if(!isMCSelfUnload){
			mc.unloadMovie();
		}
		delete mc;
		super.doDelete();
	}//<<
	
	private function getDBGInfo(Void):Array {
		var infoText:Array=[];
		//infoText.push('___ Movieclip Info: '+mc);
		infoText.push('	_parent>'+_global.pl.milib.dbg.MIDBGUtil.link(mc._parent));
		var inMCMCS:Array=[];
		var inMCVARS:Object={};
		for(var i in mc){
			if(mc[i]._parent==mc){
				inMCMCS.push(mc[i]);
			}else{
				inMCVARS[i]=mc[i];
			}
		}
		infoText.push('MCS>'+link(inMCMCS));
		infoText.push('VARS>'+link(inMCVARS));
		infoText.push(mc._currentframe+'/'+mc._totalframes+' v:'+mc._visible+' a:'+mc._alpha+'   '+mc._x+','+mc._y+'    '+mc._width+'<b>:</b>'+mc._height+'    '+mc._xscale+'<b>:</b>'+mc._yscale);
		//infoText.push('^^^ Movieclip Info: '+mc);
		var animations:Array=MILibUtil.getObjectMILibObject(mc).animations;
		if(animations.length){
			infoText.push('Animations>'+_global.pl.milib.dbg.MIDBGUtil.links(animations));
		}
		return ['___ Movieclip Info: <b>'+mc+'</b>\n	'+infoText.join('\n		')+'\n^^^ Movieclip Info: <b>'+mc+'</b>'].concat(super.getDBGInfo());;
	}//<<
	
	static public function forInstance(mc:MovieClip):MIMC {
		if(!mc){
			_global.pl.milib.dbg.MIDBGUtil.logStaticMethodBadArgs(arguments, 0, ['mc:MovieClip']);
			return null;
		}
		var milibObjObj:Object=MILibUtil.getObjectMILibObject(mc);
		if(!milibObjObj.serviceByMIMC){ milibObjObj.serviceByMIMC=new MIMC(mc); }
		return milibObjObj.serviceByMIMC;
	}//<<
	
	private function getDebugContents(Void):Array {
		return super.getDebugContents().concat([_global.pl.milib.dbg.window.contents.DBGWindowMCViewContent.forInstance(this)]);
	}//<<
	
	public function addMXCOwner(mcxOwner:MXCOwner):Void {
		if(frame>-1){ mcxOwner.initMXC(); return; }
		setIsWatchingEnterFrame(true);
		if(!mcxOwners){ mcxOwners=[]; }
		mcxOwners.push(mcxOwner);
	}//<<
	
	private function flushMXC(Void):Void {
		for(var i=0,mcxOwner:MXCOwner;i<mcxOwners.length;i++){
			mcxOwner=mcxOwners[i];
			mcxOwner.initMXC();
		}
		delete mcxOwners;
	}//<<
	
	public function moveToPoint(point:Point):Void { mc.moveTo(point.x, point.y); }//<<
	public function lineToPoint(point:Point):Void { mc.lineTo(point.x, point.y); }//<<
	
//****************************************************************************
// EVENTS for MIMovieClip
//****************************************************************************
	public function onEnterFrame(id):Void {
		if(frame!=mc._currentframe){
			if(frame==-1){
				if(!isLoad){
					bev(event_EnterFirstCatchedFrame);
					flushMXC();
				}
			}
			frame=mc._currentframe;
			bev(event_EnterNewFrame);
			if(frame==1){ bev(event_EnterFirstFrame); }
			else if(frame==mc._totalframes){ bev(event_EnterLastFrame); }
			for(var i=0,toMapMC:MovieClip;toMapMC=mappedMCS[i];i++){
				toMapMC.gotoAndStop(frame);
			}
			checkMCS();
			checkWatchedFrames();
		}
		if(targetFrame){ stepToTargetFrame(); }
	}//<<
	
	private function onMCUnload(Void):Void {
		isMCSelfUnload=true;
		getDeleter().DELETE();
	}//<<
	
	private function onMCLoad(Void):Void {
		isLoad=true;
		bev(event_Load);
		flushMXC();
	}//<<

}
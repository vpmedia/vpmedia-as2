import pl.milib.core.MIObjSoul;
import pl.milib.data.Averager;
import pl.milib.managers.EnterFrameReciver;
import pl.milib.util.MIArrayUtil;
import pl.milib.util.MILibUtil;

/**
 * @author Marek Brun 'minim'
 */
class pl.milib.managers.EnterFrameBroadcaster {
	
	private static var instance : EnterFrameBroadcaster;
	private var efmc : MovieClip;
	private var recivers : Array; //of MIObjSoul
	private var lastFrameTime : Number;	public var enterframe_IDBlankObject : Object={name:'IDBlankObject'};
	private var betweenFramesTimeAverager : Averager;
	private var currentTime : Number;
	private var frameNumber : Number;
	
	private function EnterFrameBroadcaster() {
		frameNumber=0;
		efmc=MILibUtil.getMCMILibMCForObject(_root, this);
		lastFrameTime=getTimer();
		recivers=[];
		betweenFramesTimeAverager=new Averager(31);
		betweenFramesTimeAverager.push(200);		betweenFramesTimeAverager.push(200);
		efmc.onEnterFrame=MILibUtil.createDelegate(this, onMCEnterFrame);
	}//<>
	
	public function start_(obj:EnterFrameReciver, $id):Void {
		if($id==null){ $id=enterframe_IDBlankObject; }
		var miObj:Object=MILibUtil.getObjectMILibObject(obj);
		if(!miObj.EFB_enabledIds){
			miObj.EFB_enabledIds=[];
			MIArrayUtil.addUnique(recivers, MIObjSoul.forInstance(obj));
		}
		var enabledIds:Array=miObj.EFB_enabledIds;
		MIArrayUtil.addUnique(enabledIds, $id);
	}//<<
	
	public function stop_(obj:EnterFrameReciver, $id):Void {
		if($id==null){ $id=enterframe_IDBlankObject; }
		var miObj:Object=MILibUtil.getObjectMILibObject(obj);
		var enabledIds:Array=miObj.EFB_enabledIds;
		MIArrayUtil.remove(enabledIds, $id);
		if(!enabledIds.length){
			delete miObj.EFB_enabledIds;
			MIArrayUtil.remove(recivers, MIObjSoul.forInstance(obj));
		}
	}//<<
	
	public function getLastFrameTime(Void):Number {
		return betweenFramesTimeAverager.getAddedRecently();
	}//<<
	
	public function getLastFrametimeInS01(Void):Number {
		return betweenFramesTimeAverager.getAddedRecently()/1000;
	}//<<
	
	public function getAverageFrameTime(Void):Number {
		return betweenFramesTimeAverager.getAverage();
	}//<<
	
	public function getAverageFrameTimeInS01(Void):Number {
		return betweenFramesTimeAverager.getAverage()/1000;
	}//<<
	
	public function getFPS(Void):Number {
		return 1000/betweenFramesTimeAverager.getAverage();
	}//<<
	
	public function getTime(Void):Number {
		return currentTime;
	}//<<
	
	/** @return singleton instance of EnterFrameBroadcaster */
	public static function getInstance() : EnterFrameBroadcaster {
		if (instance == null)
			instance = new EnterFrameBroadcaster();
		return instance;
	}//<<
	
	public function getFrameNumber(Void):Number {
		return frameNumber;
	}//<<
	
	static public function start(obj:EnterFrameReciver, $id):Void { getInstance().start_(obj, $id); }//<<
	static public function stop(obj:EnterFrameReciver, $id):Void { getInstance().stop_(obj, $id); }//<<
	
//****************************************************************************
// EVENTS for EnterFrameBroadcaster
//****************************************************************************
	private function onMCEnterFrame(Void):Void {
		frameNumber++;
		currentTime=getTimer();
		var recivers_length:Number=recivers.length;
		for(var i=0,pID,reciver:EnterFrameReciver,enabledIds:Array;i<recivers.length;i++){
			reciver=recivers[i].o;
			if(reciver){
				enabledIds=reciver['milibObject'].EFB_enabledIds;
				for(pID=0;pID<enabledIds.length;pID++){
					reciver.onEnterFrame(enabledIds[pID]);
				}
			}else{
				recivers.splice(i, 1);
				i--;
			}
		}
		var time:Number=getTimer();
		betweenFramesTimeAverager.push(time-lastFrameTime);
		lastFrameTime=time;
	}//<<

}
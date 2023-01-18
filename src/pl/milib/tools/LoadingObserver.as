import pl.milib.core.supers.MIRunningClass;
import pl.milib.core.value.MINumberValue;
import pl.milib.managers.EnterFrameBroadcaster;
import pl.milib.managers.EnterFrameReciver;
import pl.milib.tools.LoadedObject;

/**
 * @often_name loading
 * 
 * @author Marek Brun 'minim'
 */
class pl.milib.tools.LoadingObserver extends MIRunningClass implements EnterFrameReciver {
	
	public var event_BytesTotalRecived:Object={name:'BytesTotalRecived'};	public var event_AllBytesLoaded:Object={name:'AllBytesLoaded'};
	
	private var phaseNow : Object;
	private var phase_0_ObserveBytesTotal : Object = {name:'ObserveBytesTotal'};
	private var phase_1_ObserveBytesLoaded : Object = {name:'ObserveBytesLoaded'};	private var phase_2_Finishing: Object = {name:'Finishing'};
	private var loadedObj : LoadedObject;
	public var progressN01 : MINumberValue;
	private var startTime : Number;
	public var countBefore : Number=0;
	public var count : Number=0;
	private var minBytesTotal : Number;
	private var finishTime : Number;
	private var countFrames : Number;
	private var startFrame : Number;	private var finishFrame : Number;
	
	public function LoadingObserver() {
		progressN01=new MINumberValue(0, 0);
	}//<>
	
	private function start(Void):Boolean { return super.start(); }//<<	private function finish(Void):Boolean { return super.finish(); }//<<
	
	public function startObserve(obj, $minBytesTotal):Void {
		if(!obj){ logError_UnexpectedArg(arguments, 0, ['obj', '$minBytesTotal'], '!obj'); }
		minBytesTotal=$minBytesTotal==null ? 1000 : $minBytesTotal;
		count=countBefore;
		loadedObj=obj;
		logHistory('start observe loading, loadedObj>'+link(loadedObj));
		startFrame=EnterFrameBroadcaster.getInstance().getFrameNumber();
		startTime=getTimer();
		start();
	}//<<
	
	private function doStart(Void):Boolean {
		phaseNow=phase_0_ObserveBytesTotal;
		progressN01.v=0;
		EnterFrameBroadcaster.start(this);
		observeBytesTotal();
		return true;
	}//<<
	
	private function doFinish(Void):Boolean {
		progressN01.v=1;
		EnterFrameBroadcaster.stop(this);
		logHistory('finish observe loading, loadedObj>'+link(loadedObj));
		return true;
	}//<<
	
	private function observeBytesTotal(Void):Void {		
		if(loadedObj.getBytesTotal()>minBytesTotal){
			bev(event_BytesTotalRecived);
			phaseNow=phase_1_ObserveBytesLoaded;
			observeBytesLoaded();
		}else if(getTimer()-startTime>5000){
			logError_UnexpectedSituation(arguments, 'timeout on get bytes <b>total</b>; loadedObj.getBytesTotal()>'+loadedObj.getBytesTotal());
			finish();
		}
	}//<<
	
	private function observeBytesLoaded(Void):Void {
		progressN01.v=loadedObj.getBytesLoaded()/loadedObj.getBytesTotal();
		if(progressN01.v>=1){
			count--;
			if(count<0){
				finishTime=getTimer();
				finishFrame=EnterFrameBroadcaster.getInstance().getFrameNumber();
				bev(event_AllBytesLoaded);
				phaseNow=phase_2_Finishing;
			}
		}
	}//<<
	
	public function isLoaded(Void):Boolean {
		return (phaseNow==phase_2_Finishing && !isRunning);
	}//<<
	
	public function getLoadingTime(Void):Number { return finishTime-startTime; }//<<	public function getLoadingTimeInFrames(Void):Number { return finishFrame-startFrame; }//<<
	
//****************************************************************************
// EVENTS for LoadingObserver
//****************************************************************************
	public function onEnterFrame(id):Void {
		switch(phaseNow){
			case phase_0_ObserveBytesTotal:
				observeBytesTotal();
			break;
			case phase_1_ObserveBytesLoaded:
				observeBytesLoaded();
			break;
			case phase_2_Finishing:
				finish();
			break;
		}
	}//<<

}
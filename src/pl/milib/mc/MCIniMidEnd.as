import pl.milib.core.supers.MIRunningClass;
import pl.milib.data.info.MIEventInfo;
import pl.milib.mc.service.MIMC;
import pl.milib.util.MIMCUtil;

/**
 * @often_name mc*IME
 * 
 * @author Marek Brun
 */
class pl.milib.mc.MCIniMidEnd extends MIRunningClass {
	
	public var event_EnterMid:Object={name:'EnterMid'};
	public var event_OutMid:Object={name:'OutMid'};
	
	public var mimc : MIMC;
	private var frameIni;
	private var frameMid;
	private var frameEnd;
	private var frameMidOut;
	
	public function MCIniMidEnd(mc:MovieClip, $frameIni, $frameMid, $frameEnd, $frameMidOut) {
		mimc=MIMC.forInstance(mc);
		
		frameIni=$frameIni==null ? 'ini' : $frameIni;		frameMid=$frameMid==null ? 'mid' : $frameMid;		frameEnd=$frameEnd==null ? 'end' : $frameEnd;		frameMidOut=$frameMidOut;
		
		mimc.gotoAndStop(frameIni);
		mimc.addListener(this);
		mimc.addWatchForFrames([frameMid, frameEnd]);
		mimc.mc[frameMid]=this;
		
		addDeleteWith(mimc);
	}//<>
	
	private function doStart(Void):Boolean {
		if(MIMCUtil.isBetweenFrames(mimc.mc, frameIni, frameEnd)){
			if(!mimc.getIsFrameNow(frameMid)){
				mimc.play();
			}
		}else{
			mimc.gotoAndPlay(frameIni);
		}
		return true;
	}//<<
	
	private function doFinish(Void):Boolean {
		if(mimc.getIsFrameNow(frameIni)){
			mimc.stop();
			return true;
		}else{
			mimc.play();
			if(frameMidOut){
				if(MIMCUtil.isBetweenFrames(mimc.mc, frameMid, frameMidOut)){
					mimc.gotoAndPlay(frameMidOut);
					bev(event_OutMid);
				}
			}else{
				if(mimc.getIsFrameNow(frameMid)){
					bev(event_OutMid);
				}
			}
			return false;
		}
	}//<<
	
	public function getIsInMid(Void):Boolean {
		if(frameMidOut){
			return MIMCUtil.isBetweenFrames(mimc.mc, frameMid, frameMidOut) && isRunningFlag;
		}else{
			return MIMCUtil.isAtFrame(mimc.mc, frameMid) && isRunningFlag;
		}
	}//<<
	
	public function getIsStarting(Void):Boolean {
		return mimc.mc._currentframe<MIMCUtil.getFrameNumber(mimc.mc, frameMid);
	}//<<
	
	public function getIsEnding(Void):Boolean {
		if(frameMidOut){
			return mimc.mc._currentframe>MIMCUtil.getFrameNumber(mimc.mc, frameMidOut);
		}else{
			return mimc.mc._currentframe>MIMCUtil.getFrameNumber(mimc.mc, frameMid);
		}
	}//<<
	
//****************************************************************************
// EVENTS for MCIniMidEnd
//****************************************************************************
	private function onEvent(ev:MIEventInfo) {
		//super.onEvent(ev);
		switch(ev.hero){
			case mimc:
				switch(ev.event){
					case mimc.event_WatchedFrameEnter:				
						switch(ev.data){
							case frameMid:
								if(isRunningFlag){
									mimc.stop();
									bev(event_EnterMid);
								}else if(frameMidOut){
									mimc.gotoAndPlay(frameMidOut);
								}
							break;
							case frameEnd:
								if(isRunningFlag){
									mimc.gotoAndPlay(frameIni);
								}else{
									mimc.gotoAndStop(frameIni);
									finish();
								}
							break;
						}
					break;
				}
			break;
		}
	}//<<Events
	
}
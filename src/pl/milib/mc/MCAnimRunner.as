import pl.milib.core.supers.MIRunningClass;
import pl.milib.data.info.MIEventInfo;
import pl.milib.mc.service.MIMC;
import pl.milib.util.MIMCUtil;

/**
 * @author Marek Brun
 */
class pl.milib.mc.MCAnimRunner extends MIRunningClass {
	
	public var mimc : MIMC;
	private var frameIni : Number;
	private var frameEnd : Number;	public var isSuccess : Boolean;
	
	public function MCAnimRunner(mc:MovieClip, frameIni, frameEnd) {
		mimc=MIMC.forInstance(mc);
		mimc.addListener(this);
		this.frameIni=MIMCUtil.getFrameNumber(mimc.mc, frameIni);
		this.frameEnd=MIMCUtil.getFrameNumber(mimc.mc, frameEnd);
		if(isNaN(this.frameIni)){ logError_UnexpectedArg(arguments, 1, 'mc:MovieClip,frameIni,frameEnd'.split(','), 'isNaN(this.frameIni), this.frameIni>'+this.frameIni); }
		if(isNaN(this.frameEnd)){ logError_UnexpectedArg(arguments, 2, 'mc:MovieClip,frameIni,frameEnd'.split(','), 'isNaN(this.frameEnd), this.frameEnd>'+this.frameEnd); }
		mimc.addWatchForFrame(this.frameEnd);
		
		addDeleteWith(mimc);
	}//<>
	
	private function doStart(Void):Boolean {
		mimc.addListener(this);
		mimc.gotoAndPlay(frameIni);
		return true;
	}//<<
	
	private function doFinish(Void):Boolean {
		if(mimc.getIsFrameNow(frameEnd)){
			mimc.removeListener(this);
			isSuccess=true;
			return true;
		}else if(mimc.mc._currentframe<frameIni || mimc.mc._currentframe>frameEnd){
			isSuccess=false;
			return true;
		}else{
			return false;
		}
	}//<<
	
//****************************************************************************
// EVENTS for MCAnimRunner
//****************************************************************************
	private function onEvent(ev:MIEventInfo) {
		//super.onEvent(ev);
		switch(ev.hero){
			case mimc:
				switch(ev.event){
					case mimc.event_WatchedFrameEnter:
						switch(ev.data){
							case frameEnd:
								mimc.stop();
								finish();
							break;
						}
					break;
					case mimc.event_EnterNewFrame:
						if(mimc.mc._currentframe<frameIni || mimc.mc._currentframe>frameEnd){
							finish();
						}
					break;
				}
			break;
		}
	}//<<Events
	
}
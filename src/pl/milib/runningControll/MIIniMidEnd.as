import pl.milib.core.supers.MIRunningClass;
import pl.milib.data.info.MIEventInfo;

/**
 * @author Marek Brun
 */
class pl.milib.runningControll.MIIniMidEnd extends MIRunningClass {
	
	public var event_IniStart:Object={name:'IniStart'};	public var event_IniFinish:Object={name:'IniFinish'};
	
	public var event_MidEnter:Object={name:'MidEnter'};
		public var event_EndStart:Object={name:'EndStart'};	public var event_EndFinish:Object={name:'EndFinish'};
	
	private var ini : MIRunningClass;
	private var end : MIRunningClass;
	private var parent : MIIniMidEnd;
	private var isInMid : Boolean;
	private var targetSub : MIIniMidEnd;	private var currentSub : MIIniMidEnd;
	
	public function MIIniMidEnd(ini:MIRunningClass, end:MIRunningClass, $parent:MIIniMidEnd) {
		this.ini=ini;
		this.ini.addListener(this);		this.end=end;
		this.end.addListener(this);
		this.parent=$parent;
		this.parent.addListener(this);
		isInMid=false;
		
	}//<>
	
	/*abstract*/ private function doEnterMid(Void):Void {}//<<
	
	private function enterMid(Void):Void {
		doEnterMid();
		bev(event_MidEnter);
	}//<<
	
	public function doStart():Boolean {
		if(parent){
			if(parent.currentSub==this){
				ini.start();
				return true;
			}else{
				parent.startSub(this);
				return false;
			}
		}else{
			ini.start();
			return true;
		}
	}//<<
	
	private function startSub(sub:MIIniMidEnd):Void {
		targetSub=sub;
		isRunningFlag=true;
		if(getIsInMid()){
			if(currentSub.getIsRunning()){
				currentSub.finish();
			}else{
				startTargetSub();
			}
		}else{
			start();
		}
	}//<<
	
	private function startTargetSub(Void):Void {
		currentSub.removeListener(this);
		currentSub=targetSub;
		delete targetSub;
		currentSub.addListener(this);
		currentSub.start();
	}//<<
	
	public function doFinish():Boolean {
		delete targetSub;
		if(getIsInMid()){
			if(currentSub.getIsRunning()){
				currentSub.finish();
			}else{
				end.start();
			}
			return false;
		}else{
			if(ini.getIsRunning()){
				ini.finish();
				return false;
			}else if(end.getIsRunning()){
				end.finish();
				return false;
			}else{
				return true;
			}
		}
	}//<<
	
	public function getIsInMid(Void):Boolean {
		return isInMid;
	}//<<
	
	public function getIni(Void):MIRunningClass { return ini; }//<<	public function getEnd(Void):MIRunningClass { return end; }//<<
	
	public function enable(Void):Void {
		if(getIsRunning()){
			if(currentSub.getIsRunning()){
				currentSub.finish();
			}
		}else{
			start();
		}
	}//<<
	
	public function setupIMEParent(parent:MIIniMidEnd):Void {
		this.parent.removeListener(this);
		this.parent=parent;
		this.parent.addListener(this);
	}//<<
	
//****************************************************************************
// EVENTS for MIIniSubsEnd
//****************************************************************************
	private function onEvent(ev:MIEventInfo) {
		//super.onEvent(ev);
		switch(ev.hero){
			case ini:
				switch(ev.event){
					case ini.event_RunningStart:
						bev(event_IniStart);
					break;
					case ini.event_RunningFinish:
						isInMid=true;
						bev(event_IniFinish);
						if(getIsRunningFlag()){
							if(targetSub){
								startTargetSub();
							}else{
								enterMid();
							}
						}else{
							end.start();
						}
					break;
				}
			break;
			case end:
				switch(ev.event){
					case end.event_RunningStart:
						isInMid=false;
						bev(event_EndStart);
					break;
					case end.event_RunningFinish:
						bev(event_EndFinish);
						if(isRunningFlag){
							ini.start();
						}else{
							finish();
						}
					break;
				}
			break;
			case currentSub:
				switch(ev.event){
					case currentSub.event_RunningFinish:
						delete currentSub;
						if(getIsRunningFlag()){
							if(targetSub){
								startTargetSub();
							}else{
								enterMid();
							}
						}else{
							finish();
						}
					break;
					case currentSub.event_Deleted:
						delete currentSub;
						if(!getIsRunningFlag()){
							finish();
						}
					break;
				}
			break;
		}
	}//<<Events
	
}
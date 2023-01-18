import pl.milib.mc.MCAnimRunner;
import pl.milib.mc.service.MIMC;
import pl.milib.runningControll.MIIniMidEnd;
import pl.milib.util.MIMCUtil;

/**
 * @author Marek Brun
 */
class pl.milib.mc.MCAnimIniMidEnd extends MIIniMidEnd {

	private var mimc : MIMC;
	private var midFrame : Number;
	
	public function MCAnimIniMidEnd(mc, iniFrameStart, iniFrameEnd, endFrameStart, endFrameEnd, parent:MIIniMidEnd, $midFrame) {
		super( 
			new MCAnimRunner(mc, iniFrameStart, iniFrameEnd),
			new MCAnimRunner(mc, endFrameStart, endFrameEnd),
			parent
		);
		mimc=MIMC.forInstance(mc);
		midFrame=$midFrame==null ? MIMCUtil.getFrameNumber(mc, iniFrameEnd) : $midFrame;
		
	}//<>
	
	private function doEnterMid(Void):Void {
		//mimc.gotoAndStop(midFrame);
	}//<<
	
}
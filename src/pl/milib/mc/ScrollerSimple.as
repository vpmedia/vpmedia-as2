import pl.milib.data.info.MIEventInfo;
import pl.milib.data.info.ScrollInfo;
import pl.milib.mc.abstract.MIScroller;
import pl.milib.mc.service.MIButton;
import pl.milib.mc.service.MIMC;
import pl.milib.mc.virtualUI.VirtualDrag;
import pl.milib.util.MIMathUtil;

/** @author Marek Brun 'minim' */
class pl.milib.mc.ScrollerSimple extends MIScroller {

	private var mc_cursor : MovieClip;
	private var cursorLength : Number;
	private var bgLength : Number;
	private var viDrag : VirtualDrag;
	private var mimc : MIMC;
	private var btn : MIButton;
	
	public function ScrollerSimple(mc:MovieClip) {
		mimc=MIMC.forInstance(mc);
		mc_cursor=mimc.g('cursor');
		cursorLength=mimc.g('cursor.settLen')._height;
		mimc.g('cursor.settLen').unloadMovie();
		bgLength=mimc.g('settLen')._height;
		mimc.g('settLen').unloadMovie();
		
		viDrag=new VirtualDrag(mc_cursor);
		viDrag.addListener(this);
		btn=mimc.getMIButton('cursor.btn');
		btn.addListener(this);
	}//<>
	
	public function getIsPressed(Void):Boolean {
		return btn.getIsPressed();
	}//<<
	
	public function applyScrollData(scrollData:ScrollInfo):Void {
		mc_cursor._y=(bgLength-cursorLength)*scrollData.scrollN01;
		//mimc.mc._visible=scrollData.total!=scrollData.visible;
		btn.setIsEnabled(scrollData.total>scrollData.visible);
		mimc.mc._visible=scrollData.total>scrollData.visible;
	}//<<
	
//****************************************************************************
// EVENTS for ScrollerSimple
//****************************************************************************
	private function onEvent(ev:MIEventInfo):Void{
		super.onEvent(ev);
		switch(ev.hero){
			case viDrag:
				switch(ev.event){
					case viDrag.event_Start:
						scrollable.removeListener(this);
					break;
					case viDrag.event_NewDragXY:
						var scroll01:Number=MIMathUtil.b01(viDrag.getY()/(bgLength-cursorLength));
						scrollable.setScrollN01(scroll01);
						var sd:ScrollInfo=scrollable.getScrollData();
						sd.scrollN01=scroll01;
						applyScrollData(sd);
						bev(event_Moved);
					break;
					case viDrag.event_Stop:
						scrollable.addListener(this);
					break;
				}
			break;
			case btn:
				switch(ev.event){
					case btn.event_Press:
						viDrag.start();
					break;
					case btn.event_ReleaseAll:
						viDrag.stop();
					break;
				}
			break;
		}
	}//<<Events
	
}
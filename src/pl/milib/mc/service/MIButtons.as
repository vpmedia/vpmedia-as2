import pl.milib.collection.MIObjects;
import pl.milib.data.info.MIEventInfo;
import pl.milib.mc.abstract.AbstractButton;
import pl.milib.mc.service.MIButton;

/**
 * @author Marek Brun
 */
class pl.milib.mc.service.MIButtons extends AbstractButton {

	public var buttons : MIObjects; //MIButton
	
	public function MIButtons($buttons:MIObjects) {
		buttons=$buttons==null ? new MIObjects() : $buttons;
		buttons.addListener(this);
		isEnabled=true;
	}//<>
	
//****************************************************************************
// EVENTS for MIButtons
//****************************************************************************
	private function onEvent(ev:MIEventInfo) {
		//super.onEvent(ev);
		switch(ev.hero){
			case buttons:
				if(ev.event!=buttons.event_EventReflection){ break; }
				var hero:MIButton=MIButton(ev.data.hero);
				switch(ev.data.event){
					case hero.event_DragOut: setDragOut(); break;
					case hero.event_DragOver: setDragOver(); break;
					case hero.event_Press: setPress(); break;
					case hero.event_Release: setRelease(); break;
					case hero.event_ReleaseOutside: setReleaseOutside(); break;
					case hero.event_RollOut: setRollOut(); log('vievs>'+link(views.getArray())); break;
					case hero.event_RollOver: setRollOver(); break;
				}
			break;
		}
	}//<<Events
	
}
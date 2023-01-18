/**
 * FlashPaperLoader
 *
 * @author: Felix Raab, E-Mail: f.raab@betriebsraum.de, Url: http://www.betriebsraum.de
 * @version: 1.0
 */


import mx.utils.Delegate;
import mx.events.EventDispatcher;


class de.betriebsraum.loading.FlashPaperLoader {
	
	
	private var dispatchEvent:Function;
	public var addEventListener:Function;
	public var removeEventListener:Function;	
	
	private var fpID:Number;
	private var target_mc:MovieClip;
	
	
	public function FlashPaperLoader() {		
	
		EventDispatcher.initialize(this);
		
	}	
	
	
	private function checkLoadStatus():Void {
		
		target_mc._visible = false;
		
		if (target_mc.getIFlashPaper() != undefined) {
			clearInterval(fpID);
			target_mc._visible = true;
			fixFlashPaper2SelectionManagement(target_mc);			
			dispatchEvent({type:"onLoad", target:this, flashPaper:target_mc.getIFlashPaper()});
		}
		
	}
	
	
	// Workaround for FlashPaper 2 Selection Bug:
	// see: http://www.flashcomguru.com/index.cfm/2005/7/20/Workaround-for-Flashpaper2-bug
	private function fixFlashPaper2SelectionManagement(mc:MovieClip):Void {

		if (typeof (mc.gMainView.m_mainMC.onMouseDown) == "function" && mc.gMainView.m_mainMC.hasSafeSelectionManagement === undefined) {
		
			mc.gMainView.m_mainMC.onMouseDown = function() {
		
				var fpfocus:MovieClip = _global.FPUI.Component.focusedComponent;
		
				if (fpfocus != null) {
		
					var hitFocused:Boolean = false;
		
					if (fpfocus._visible) {
						var pt:Object = new Object();
						pt.x = _root._xmouse;
						pt.y = _root._ymouse;
						_root.localToGlobal(pt);
						hitFocused = fpfocus.hitTest(pt.x, pt.y, true);
					}
		
					if (hitFocused == false) {
						if (typeof (fpfocus.onComponentKillFocus) == "function") {
							fpfocus.onComponentKillFocus();
						}
					}
		
				}
				
			}
			
		}
		
	}
	
	
	public function load(url:String, target:MovieClip):Void {
		
		this.target_mc = target;
		target_mc.loadMovie(url);		
		fpID = setInterval(Delegate.create(this, checkLoadStatus), 50);				 
		
	}
	
	
}
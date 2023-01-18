import net.manaca.ui.controls.Selector;
import net.manaca.ui.controls.skin.ISelectorSkin;
import net.manaca.ui.controls.skin.Skin;
import net.manaca.ui.controls.UIComponent;
import net.manaca.ui.controls.themes.Themes;
import net.manaca.ui.awt.SolidBrush;
import net.manaca.ui.awt.Graphics;
import net.manaca.ui.awt.Pen;

/**
 * 
 * @author Wersling
 * @version 1.0, 2006-5-20
 */
class net.manaca.ui.controls.skin.mnc.SelectorSkin extends Skin implements ISelectorSkin {
	private var className : String = "net.manaca.ui.controls.skin.mnc.SelectorSkin";
	private var _w : Number;
	private var _h : Number;
	private var _component:Selector;
	private var _themes : Themes;
	private var _solidBrush : SolidBrush;
	private var _pen : Pen;
	private var _childComponent : Object;
	
	//---------------
	private var _tl_Drag_mc:MovieClip;
	private var _tr_Drag_mc:MovieClip;
	private var _bl_Drag_mc:MovieClip;
	private var _br_Drag_mc:MovieClip;
	public function SelectorSkin() {
		super();
		_solidBrush = new SolidBrush();
		_childComponent = new Object();
		_pen = new Pen();
	}
	public function updateDisplay(name : String) : Void {
		_w = _component.getSize().getWidth();
		_h = _component.getSize().getHeight();
		_themes = _component.getThemes();
		switch (name) {
		case "updateThemes":
	    	updateDisplay();
	    	break;
	    case "updateSize":
	    	updateDisplay();
			UpdateChildComponent(_component);
	    	break;
	    case "UpdateFocus":
			break;
		default:
			drawRectangle(createEmptyMc("ControlBorder"),_themes.ControlBorder,0,0,_w,_h);
			//drawfillRectangle(createEmptyMc("Control"),_themes.Control,1,1,_w-2,_h-2);
			break;
		}
	}
	private function drawCelector(mc:MovieClip,x:Number, y:Number, width:Number, height:Number):Void{
		var _g:Graphics = new Graphics(mc);
		_solidBrush.setColor(_themes.ControlBorder);
		_g.fillRectangle(_solidBrush,0,0,6,6);
		
		_solidBrush.setColor(_themes.Control);
		_g.fillRectangle(_solidBrush,1,1,4,4);
	}
	private function drawRectangle(mc:MovieClip,color:Number, x:Number, y:Number, width:Number, height:Number):Void{
		var _g:Graphics = new Graphics(mc);
		_solidBrush.setColor(color);
		_g.drawRectangle(_pen,x,y,width,height);
		new Color(mc).setRGB(color);
	}
	public function createChildComponent(o : Selector) : Void {
		_tl_Drag_mc = this.createEmptyMcByDepth("_tl_Drag_mc",101);
		drawCelector(_tl_Drag_mc,0,0,6,6);
		_childComponent["_tl_Drag_mc"] = _tl_Drag_mc;
		
		_tr_Drag_mc = this.createEmptyMcByDepth("_tr_Drag_mc",102);
		drawCelector(_tr_Drag_mc,0,0,6,6);
		_childComponent["_tr_Drag_mc"] = _tr_Drag_mc;
		
		_bl_Drag_mc = this.createEmptyMcByDepth("_bl_Drag_mc",103);
		drawCelector(_bl_Drag_mc,0,0,6,6);
		_childComponent["_bl_Drag_mc"] = _bl_Drag_mc;
		
		_br_Drag_mc = this.createEmptyMcByDepth("_br_Drag_mc",104);
		drawCelector(_br_Drag_mc,0,0,6,6);
		_childComponent["_br_Drag_mc"] = _br_Drag_mc;
	}

	public function UpdateChildComponent(o : Selector) : Void {
		_tl_Drag_mc._x = -3;
		_tl_Drag_mc._y = -3;
		_tr_Drag_mc._x = _w-3;
		_tr_Drag_mc._y = -3;
		_bl_Drag_mc._x = -3;
		_bl_Drag_mc._y = _h-3;
		_br_Drag_mc._x = _w-3;
		_br_Drag_mc._y = _h-3;
	}

	public function getChildComponent(name : String) : MovieClip {
		return _childComponent[name];
	}


	public function initialize(c : UIComponent) : Void {
	}

	public function paint() : Void {
	}

	public function paintAll() : Void {
	}

	public function updateSize() : Void {
	}

	public function updateThemes() : Void {
	}

	public function updateTextFormat() : Void {
	}

	public function destroy() : Void {
	}

	public function repaintAll() : Void {
	}

	public function repaint() : Void {
	}

}
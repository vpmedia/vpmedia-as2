import net.manaca.ui.controls.UIComponent;
import net.manaca.ui.controls.skin.ISelectorSkin;
import net.manaca.ui.controls.skin.SkinFactory;
import net.manaca.ui.awt.Dimension;
import net.manaca.util.Delegate;
import net.manaca.lang.event.Event;
import net.manaca.ui.controls.skin.mnc.SelectorSkin;


/**
 * 选择器
 * @author Wersling
 * @version 1.0, 2006-4-21
 */
class net.manaca.ui.controls.Selector extends UIComponent {
	private var className : String = "net.manaca.ui.controls.Selector";
	private var _skin:ISelectorSkin;
	private var _rotation : Number;
	private var _tl_Drag_mc:MovieClip;
	private var _tr_Drag_mc:MovieClip;
	private var _bl_Drag_mc:MovieClip;
	private var _br_Drag_mc:MovieClip;
	
	private var _now_Drag_mc:MovieClip;
	private var _isDrag :Boolean;

	private var _startX : Number;
	private var _startY : Number;
	private var _startW : Number;
	private var _startH : Number;
	private var _seekX : Number;
	private var _seekY : Number;
	public function Selector(target : MovieClip, new_name : String) {
		super(target, new_name);
//		_skin  = SkinFactory.getInstance().getDefault().createSelectorSkin();
		_skin  = new SelectorSkin();
		_preferredSize = new Dimension(22,22);
		this.paint();
		initElement();
		
		_isDrag = false;
	}
	private function initElement() : Void {
		_skin.createChildComponent(this);
		
		_tl_Drag_mc = _skin.getChildComponent("_tl_Drag_mc");
		_tr_Drag_mc = _skin.getChildComponent("_tr_Drag_mc");
		_bl_Drag_mc = _skin.getChildComponent("_bl_Drag_mc");
		_br_Drag_mc = _skin.getChildComponent("_br_Drag_mc");
		
		_tl_Drag_mc.onPress = Delegate.create(this,onStartDrag,_tl_Drag_mc);
		_tl_Drag_mc.onRelease = Delegate.create(this,onStopDrag);
		_tl_Drag_mc.onReleaseOutside = Delegate.create(this,onStopDrag);
		_tr_Drag_mc.onPress = Delegate.create(this,onStartDrag,_tr_Drag_mc);
		_tr_Drag_mc.onRelease = Delegate.create(this,onStopDrag);
		_tr_Drag_mc.onReleaseOutside = Delegate.create(this,onStopDrag);
		_bl_Drag_mc.onPress = Delegate.create(this,onStartDrag,_bl_Drag_mc);
		_bl_Drag_mc.onRelease = Delegate.create(this,onStopDrag);
		_bl_Drag_mc.onReleaseOutside = Delegate.create(this,onStopDrag);
		_br_Drag_mc.onPress = Delegate.create(this,onStartDrag,_br_Drag_mc);
		_br_Drag_mc.onRelease = Delegate.create(this,onStopDrag);
		_br_Drag_mc.onReleaseOutside = Delegate.create(this,onStopDrag);
	}
	private function onStartDrag(_now_mc) : Void {
		if(!_isDrag){
			_now_Drag_mc = _now_mc;
			_startX = _domain._x;
			_startY = _domain._y;
			_startW = this.getSize().getWidth();
			_startH = this.getSize().getHeight();
			_seekX = int(_now_Drag_mc._xmouse);
			_seekY = int(_now_Drag_mc._ymouse);
			switch (_now_Drag_mc) {
			    case _bl_Drag_mc:
			       _now_Drag_mc.startDrag(false);
			        break;
			    case _br_Drag_mc:
			       _now_Drag_mc.startDrag(false);
			        break;
			    default:
			        trace ("no case tested true");
			}
			_now_Drag_mc.onMouseMove = Delegate.create(this,moveChangeSize);
			_isDrag = true;
		}
	}
	private function moveChangeSize():Void{
		if(_isDrag){
			var w:Number = _startW;
			var h:Number = _startH;
			var x:Number = _startX;
			var y:Number = _startY;
            var sx = int(_now_Drag_mc._xmouse);
            var sy = int(_now_Drag_mc._xmouse);
			switch (_now_Drag_mc) {
			    case _bl_Drag_mc:
                    x = _startX + (sx - _seekX);
                    _startX = x;
                    x = x+3;
			        break;
			    case _br_Drag_mc:
			      	w  =_now_Drag_mc._x + 3;
					h  =_now_Drag_mc._y + 3;
			        break;
			    default:
			        trace ("no case tested true");
			}
			if(w != this.getSize().getWidth() || h != this.getSize().getHeight()){
				//this.setSize(w,h);
			}
			//if(x != _startX || y != _startY){
				this.setLocation(x,y);
//				_skin.UpdateChildComponent(this);
			//}
			//this.dispatchEvent(new Event(Event.CHANGE,[x,y,w,h]));
		}
	}
	private function onStopDrag() : Void {
		if(_isDrag){
			_now_Drag_mc.stopDrag();
			moveChangeSize();
			_now_Drag_mc.onMouseMove = null;
			delete _now_Drag_mc.onMouseMove;
			_isDrag = false;
		}
	}
	private function updataLocation():Void{
		//_domain._x = _rectangle.getX();
		//_domain._y = _rectangle.getY();
	}
	/**
	 * 获取和设置
	 * @param  value:Number - 
	 * @return Number 
	 */
	public function set rotation(value:Number) :Void
	{
		this.getDisplayObject()._rotation = value;
	}
	public function get rotation() :Number
	{
		return  this.getDisplayObject()._rotation;
	}
	

}
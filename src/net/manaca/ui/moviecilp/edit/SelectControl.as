import net.manaca.lang.BObject;
import net.manaca.lang.exception.IllegalArgumentException;

/**
 * 选择器，用于在指定对象中通过鼠标来选择元件
 * @author Wersling
 * @version 1.0, 2006-4-19
 */
class net.manaca.ui.moviecilp.edit.SelectControl extends BObject {
	private var className : String = "net.manaca.ui.moviecilp.edit.SelectControl";
	private var _paint_mc : MovieClip;
	private var _mc_list:Array;

	private var hitmc : MovieClip;
	/**
	 * 构造一个选择器
	 * @param mc 提供选择元素的MC
	 */
	public function SelectControl(mc:MovieClip) {
		super();
		if(mc != undefined){
			_paint_mc = mc;
			createHitTest();
		}else{
			throw new IllegalArgumentException("在构造选择器时参数",this,arguments);
		}
	}
	
	/**
	 * 建立可选择元素监听
	 */
	private function createHitTest():Void{
		_mc_list = new Array();
		for(var i in _paint_mc){
			if (typeof _paint_mc[i] == "movieclip") {
				_mc_list.push(_paint_mc[i]);
			}
		}
		
		hitmc = _paint_mc.createEmptyMovieClip("hitmc", _paint_mc.getNextHighestDepth());
		hitmc.beginFill(0xFF0000);
		hitmc.moveTo(-3, -3);
		hitmc.lineTo(3, -3);
		hitmc.lineTo(3, 3);
		hitmc.lineTo(-3, 3);
		hitmc.lineTo(-3, -3);
		hitmc.endFill();
		hitmc._alpha =0;
	}
	
	/**
	 * 获取指定位置的元件
	 * @return MovieClip 指定位置的元件，如果没有则返回null;
	 * @exception 这里可能存在一个问题在于如果元件深度调整，则有可能会返回地层元件
	 */
	public function getSelect(x:Number,y:Number):MovieClip{
		if(x == undefined ) x = _paint_mc._xmouse;
		if(y == undefined ) y = _paint_mc._ymouse;
		hitmc._x =_paint_mc._xmouse;
		hitmc._y =_paint_mc._ymouse;
		for (var i : Number = 0; i < _mc_list.length; i++) {
			if (_mc_list[i].hitTest(hitmc)) {
				return _mc_list[i];
			}
		}
		return null;
	}
}
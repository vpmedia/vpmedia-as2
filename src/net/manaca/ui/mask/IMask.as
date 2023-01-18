/**
 * 所有Mask实现接口
 * @author Wersling
 * @version 1.0, 2005-12-7
 */
interface net.manaca.ui.mask.IMask {
	/**
	 * 建立Mask
	 * @param width	宽度
	 * @param height	高度
	 * @param fun 出现方式（可选）
	 */
	public function crudeMask(width:Number, height:Number,fun:String):Void;
	public function clear():Void;
}
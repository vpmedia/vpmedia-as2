/**
 * IItemRenderer 定义项目显示的方法
 * @author Wersling
 * @version 1.0, 2006-6-4
 */
interface net.manaca.ui.controls.core.IItemRenderer {
	/**
	 * 删除对象
	 */
	public function remove():Void;
	
	/**
	 * 单元格的正确宽度
	 */
	public function getPreferredWidth():Number;
	
	/**
	 * 单元格的正确高度
	 */
	public function getPreferredHeight():Number;
	
	/**
	 * 设置该单元值
	 * @param data:Object - 此项对应的数据值
	 */
	public function setValue(data:Object):Void;
	public function getValue():Object;
	
	/**
	 * 修改位置
	 */
	public function setLocation(x:Number, y:Number):Void;
	/**
	 * 修改单元大小
	 */
	public function setSize(width:Number, height:Number):Void;
}
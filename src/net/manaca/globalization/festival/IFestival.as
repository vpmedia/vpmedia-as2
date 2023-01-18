/**
 * 为节日对象提供基本方法
 * @author Wersling
 * @version 1.0, 2006-1-15
 */
interface net.manaca.globalization.festival.IFestival {
	/**
	 * 获取节日名称
	 * @return 节日名称
	 */
	public function getName():String;
	
	/**
	 * 是否重要的节日
	 * @return Boolean 重要的节日返回 true
	 */
	public function isBasilic():Boolean;
	
	/**
	 * 节日日期编号
	 */
	public function getSn():String;
	public function toString():String;
}
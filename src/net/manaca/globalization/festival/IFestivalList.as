import net.manaca.globalization.festival.IFestival;
/**
 * 提供节日列表的基本方法
 * @author Wersling
 * @version 1.0, 2006-1-16
 */
interface net.manaca.globalization.festival.IFestivalList {
	/**
	 * 获取一个节日
	 * @param sn 节日日期编号
	 * @return IFestival 返回一个节日，如果没有此编号节日则返回 null
	 */
	public function getFestival(sn:String):IFestival;
}
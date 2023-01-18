/**
 * 翻页程序接口
 * 
 * @author Wersling
 * @version 1.0, 2005-9-8
 */
interface net.manaca.ui.core.IPages {
	/** 上一页 */
	public function previousPage():Boolean;
	/** 下一页 */
	public function nextPage():Boolean;
}

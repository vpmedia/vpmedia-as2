import net.manaca.data.list.SearchList;
import net.manaca.lang.BObject;
import net.manaca.data.Search;
/**
 * 历史记录管理，主要是建立一个指针，用于记录但前的操作位置，此外用于撤销和恢复动作
 * @author Wersling
 * @version 1.0, 2006-4-25
 */
class net.manaca.manager.HistoryManager extends SearchList implements Search{
	private var className : String = "net.manaca.manager.HistoryManager";
	/**
	 * 构造函数
	 * @param arr
	 */
	public function HistoryManager(arr:Array) {
		super(arr);
	}
	/**
     * 把项压入栈顶
     * @param o 压入栈的项
     * @return Number 返回总长度
     */
	public function push(o:Object):Number{
		if(finger < _items.length-1) _items.splice(finger+1);
		var _l:Number = _items.push(o); 
		finger = _l-1;
		return _l;
    }
}
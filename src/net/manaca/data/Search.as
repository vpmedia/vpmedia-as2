/**
 * 提供一个基本数据查询的接口
 * @author Wersling
 * @version 1.0, 2006-1-15
 */
interface net.manaca.data.Search {
	/**
     * 如果存在上一个元素，则返回 true。
     */
	public function hasBack():Boolean;
	
  	/**
     * 如果存在下一个元素，则返回 true。
     */
	public function hasNext():Boolean;
	
	/**
	 * 返回所有可用的单元
	 * @return Array
	 */
	public function getAvailableCell():Array;
	
	/**
     * 返回上一个可选择的元素
     * @return Object 上一个可选择的元素
     * @throws NoSuchElementException 找不到数据时抛出
     */
	public function getBack():Object;
	
    /**
     * 返回下一个可选择的元素
     * @return Object 下一个可选择的元素
     * @throws NoSuchElementException 找不到数据时抛出
     */
	public function getNext():Object;
	
	/**
	 * 返回当前位置
	 * @return Number 当前位置
	 */
	public function getFinger():Number;
	
    /**
     * 移动指针
     * @param 要移动的位置
     * @return 移动成功则返回 true
     * @throws NoSuchElementException 无法移动到该位置时抛出
     */
	public function move(n:Number):Object;
	
	/**
	 * 查询元素位置
	 * @param 需要查询的元素
	 * @return Number 元素位置，如果没有此元素则返回－1
	 */
	public function search(o:Object):Number;
	
}
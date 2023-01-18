/**
 * 列表数据提供者，主要针对List查询和修改数据。
 * 在List中如果传递给List.dataProvider一个数据，都必须适配为此接口对象。具体适配方式
 * 由DataFormatter对象完成
 * @author Wersling
 * @version 1.0, 2006-5-22
 */
interface net.manaca.ui.controls.esse.IListDataProvider{
    /**
     * 添加一个元素
     * @param item:Object - 一个元素对象
     * @example
     * 		aIListDataProvider.addItem({label:"Label1",data:1});
     */
     public function addItem(item:Object):Void;
    
    /**
     * 添加一个元素到指定位置
     * @param  item:Object - 一个元素对象
     * @param index:Number - 添加元素位置，如果为负，则添加位置从最后算起
     * @example
     * 		aIListDataProvider.addItemAt({label:"Label1",data:1},2);
     */
    public function addItemAt(item:Object, index:Number):Void;
    
    /**
     * 获取指定位置的元素
     * @param index:Number - 元素位置
     * @return Object 返回指定位置的元素
     * @throws 在 index < 0 or index >= length 抛出
     */
    public function getItemAt(index:Number):Object;
    
    /**
     * 获取指定元素的位置
     * @param item:Object - 指定元素
     * @return Number 返回指定位置的元素，如果找不到元素则返回 -1
     */
    public function getItemIndex(item:Object):Number;
    
    /** 
     *  删除所有元素
     */
    public function removeAll():Void;
    
    /** 
     * 删除指定位置的元素
     * @param index:Number - 要删除元素的位置
     * @return Object 被删除元素
     * @throws 在 index < 0 or index >= length 抛出
     */
    public function removeAt(index:Number):Boolean;
    
    /**
     * 删除指定元素
     * @param item:Object 要删除的元素
     * @return Boolean 是否删除元素
     */
    public function removeItem(item:Object):Boolean;
	    
    /**
     * 将指定元素移动到指定位置
     * @param item:Object - 要移动的元素
     * @param index:Number - 要移动到的位置
     * @return Object 返回原来此位置的元素
     *	@throws 在 index < 0 or index >= length 抛出
     */
    public function setItemAt(item:Object, index:Number):Object;
    
    
    /**
     * 获取大小
     */
    public function size():Number;
    
    /**
     * 返回元素的数组
     */ 
    public function toArray():Array;
}
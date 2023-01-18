import net.manaca.data.list.Vector;
import net.manaca.lang.exception.NoSuchElementException;
import net.manaca.data.list.EmptyStackException;

/**
 * Stack 类表示后进先出（LIFO）的对象堆栈。它通过五个操作对类 Vector 进行了扩展 ，
 * 允许将向量视为堆栈。它提供了通常的 push 和 pop 操作，以及取栈顶点的 peek 方法、
 * 测试堆栈是否为空的 empty 方法、在堆栈中查找项并确定到栈顶距离的 search 方法。
 * 
 * @author Wersling
 * @version 1.0, 2006-1-11
 */
class net.manaca.data.list.Stack extends Vector {
	private var className : String = "net.manaca.data.list.Stack";
	
	private var pin:Number;
	
	/**
	 * 构造函数
	 * @param arr 将一个数组传人（可选）
	 */
	public function Stack(arr:Array) {
		super();
		if (arr) { 
		   _items = arr.slice(); 
		   pin = arr.length-1; 
		   return;
		} 
	}
	
	/**
	 * 查看栈顶对象而不移除它。
	 * @return  Object 栈顶对象
	 * @throws {@link EmptyStackException} - 如果堆栈是空的。
	 */
	public function peek():Object
    {
        var i:Number = size();
        if(i == 0){
            throw new EmptyStackException("堆栈为空",this,arguments);
        }else{
            return _items[i - 1];
        }
    }
    
    /**
     * 移除栈顶对象并作为此函数的值返回该对象
     * @return Object 栈顶对象
     * @throws NoSuchElementException 如果栈为空时将抛出此错误
     */
	public function pop():Object
    {
		if (!isEmpty()) { 
			pin--; 
			return (_items[pin]); 
		}else{
			throw new NoSuchElementException("不存在数据", this, arguments);
		}
    }
    
    /**
     * 把项压入栈顶
     * @param o 压入栈的项
     */
	public function push(o:Object):Void
    {
		_items.push(o); 
  		pin ++;
    }
    
    /**
     * 返回对象在栈中的位置，以 1 为基数。如果对象 o 是栈中的一个项，
     * 该方法返回距栈顶最近的出现位置到栈顶的距离；栈中最上端项的距离为 1。
     * 使用 equals 方法比较 o 与堆栈中的项
     * 
     * @param o 目标对象
     * @return Number 对象到栈顶的位置
     */
	public function search(o:Object):Number
    {
		var i:Number = lastIndexOf(o);
		if(i >= 0)
			return size() - i;
		else
			return -1;
    }
}
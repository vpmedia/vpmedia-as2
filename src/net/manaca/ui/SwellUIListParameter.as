import net.manaca.lang.BObject;
import net.manaca.lang.exception.IllegalArgumentException;
import net.manaca.data.Cloneable;
import net.manaca.lang.IObject;

/**
 * 增强的列表的参数容器
 * @author Wersling
 * @version 1.0, 2006-1-15
 */
class net.manaca.ui.SwellUIListParameter extends BObject implements Cloneable{
	private var className : String = "net.manaca.ui.SwellUIListParameter";
	private var _cellName : String;
	private var _height : Number;
	private var _width : Number;
	private var _lineTotal : Number;
	private var _train : Boolean;

	private var _space : Number;
	/**
	 * 构造函数
	 * @param cellName 必须，需要加载的单元容器名称
	 * @param width 必须，单元之间的宽度
	 * @param height 必须，单元之间的高度
	 * @param train 排列方式，true 为横向排列,false 为纵向排列 ，默认为 true
	 * @param lineTotal 每行\列最多排列数，默认为 1s
	 * @param space 列表头空格数，必须非负，默认为 0
	 */
	public function SwellUIListParameter(cellName:String,width:Number,height:Number,train:Boolean,lineTotal:Number,space:Number) {
		super();
		if(cellName	== undefined)	throw new IllegalArgumentException("缺少必要的参数:"+cellName,this,arguments);
		if(width		== undefined)	throw new IllegalArgumentException("缺少必要的参数:"+width,this,arguments);
		if(height	== undefined)	throw new IllegalArgumentException("缺少必要的参数:"+height,this,arguments);
		this.cellName	= cellName;
		this.width		= width;
		this.height		= height;
		this.train		= true;
		this.lineTotal	= 1;
		this.space	= 0;
		if(train	!= undefined) this.train	= train;
		if(lineTotal	!= undefined) this.lineTotal	= lineTotal;
		if(space >0) this.space	= int(space);
	}
	
	public function clone() : IObject{
		return new SwellUIListParameter(cellName,width,height,train,lineTotal,space);
	}
	
	/**
	 * 每行\列最多排列数
	 * @param  value  参数类型：Number 
	 * @return 返回值类型：Number 
	 */
	public function set lineTotal(value:Number) :Void
	{
		_lineTotal = value;
	}
	public function get lineTotal() :Number
	{
		return _lineTotal;
	}
	
	/**
	 * 单元之间的宽度
	 * @param  value  参数类型：Number 
	 * @return 返回值类型：Number 
	 */
	public function set width(value:Number) :Void
	{
		_width = value;
	}
	public function get width() :Number
	{
		return _width;
	}
	
	/**
	 * 单元之间的高度
	 * @param  value  参数类型：Number 
	 * @return 返回值类型：Number 
	 */
	public function set height(value:Number) :Void
	{
		_height = value;
	}
	public function get height() :Number
	{
		return _height;
	}
	/**
	 * 排列方式，true 为横向排列,false 为纵向排列
	 * @param  value  参数类型：Boolean 
	 * @return 返回值类型：Boolean 
	 */
	public function set train(value:Boolean) :Void
	{
		_train = value;
	}
	public function get train() :Boolean
	{
		return _train;
	}
	/**
	 * 需要加载的单元容器名称
	 * @param  value  参数类型：String 
	 * @return 返回值类型：String 
	 */
	public function set cellName(value:String) :Void
	{
		_cellName = value;
	}
	public function get cellName() :String
	{
		return _cellName;
	}
	
	/**
	 * 列表头空格数
	 * @param  value  参数类型：Number 
	 * @return 返回值类型：Number 
	 */
	public function set space(value:Number) :Void
	{
		_space = value;
	}
	public function get space() :Number
	{
		return _space;
	}
}
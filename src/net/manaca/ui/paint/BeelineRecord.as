import net.manaca.ui.paint.Record;

/**
 * 绘制直线记录对象
 * @author Wersling
 * @version 1.0, 2006-4-23
 */
class net.manaca.ui.paint.BeelineRecord extends Record {
	private var className : String = "net.manaca.ui.paint.BeelineRecord";
	private var _mcName : String;
	private var _size : Number;
	private var _color : Number;
	private var _alpha : Number;
	private var _line_record:Array;
	private var _commands:Array;
	public function BeelineRecord(mcName:String,size:Number,color:Number,alpha:Number) {
		super();
		_mcName	=	mcName;
		_size	=	size;
		_color	=	color;
		_alpha	=	alpha;
		_line_record = new Array();
		_commands = new Array();
	}

	/**
	 * 添加笔画位置
	 * @param x
	 * @param y
	 * @return Array 返回此操作的Commands
	 */
	public function pushLine(x:Number,y:Number):Array{
		x = int(x*10)/10;
		y = int(y*10)/10;
		_line_record.push({x:x,y:y});
		//"Draw_Beeline@init,_size,_color,_alpha";
		var _comm1:String  = "Draw_Beeline@init,"+_size+","+_color+","+_alpha;
		//"Draw_Beeline@start,x,y,name";
		var _comm2:String  = "Draw_Beeline@start,"+x+","+y+","+_mcName;
		_commands.push(_comm1);
		_commands.push(_comm2);
		return [_comm1,_comm2];
	}
	
	/**
	 * 结束记录
	 * @return Array 返回此操作的Commands: Draw_Beeline@end,x,y
	 */
	public function endRecord(x:Number,y:Number):Array{
		x = int(x*10)/10;
		y = int(y*10)/10;
		_line_record.push({x:x,y:y});
		//"Draw_Beeline@end,x,y";
		var _comm:String  = "Draw_Beeline@end,"+x+","+y;
		_commands.push(_comm);
		return [_comm];
	}
	
	/**
	 * 返回笔画记录
	 */
	public function getRecord():Array{
		return _line_record;
	}
	
	/**
	 * 返回所有的命令集
	 * @return Array
	 */
	public function getCommands():Array{
		return _commands;
	}

	/**
	 * 获取名称
	 * @return 返回值类型：String 
	 */
	public function getName() :String
	{
		return _mcName;
	}
	
	/**
	 * 获取笔画大小
	 * @return 返回值类型：Number
	 */
	public function getSize() :Number
	{
		return _size;
	}
	
	/**
	 * 获取名称
	 * @return 返回值类型：Number 
	 */
	public function getColor() :Number
	{
		return _color;
	}
	
	/**
	 * 获取透明度
	 * @return 返回值类型：Number 
	 */
	public function getAlpha() :Number
	{
		return _alpha;
	}
	/**
	 * 压缩
	 */
	static public function Pack(pr:BeelineRecord):String{
		var _str:String = "Draw_Beeline@" + pr.getName();
		_str = _str + "|" + pr.getSize();
		_str = _str + "|" + pr.getColor();
		_str = _str + "|" + pr.getAlpha();
		for (var i : Number = 0; i < pr.getRecord().length; i++) {
			_str = _str + "|" + pr.getRecord()[i].x + "," + pr.getRecord()[i].y;
		}
		return _str;
	}
	
	/**
	 * 通过toString()方法获取的字符 转为一个 PancilRecord 对象
	 * @param record_str 通过toString()方法获取的字符
	 * @return PancilRecord
	 */
	static public function unPack(record_str:String):BeelineRecord{
		record_str = record_str.slice(12);
		var _v_arr:Array = record_str.split("|");
		var pr:BeelineRecord = new BeelineRecord(_v_arr[0],Number(_v_arr[1]),Number(_v_arr[2]),Number(_v_arr[3]));
		for (var i : Number = 4; i < _v_arr.length; i++) {
			var l:Array = _v_arr[i].split(",");
			pr.pushLine(Number(l[0]),Number(l[1]));
		}
		pr.endRecord();
		return pr;
	}
}
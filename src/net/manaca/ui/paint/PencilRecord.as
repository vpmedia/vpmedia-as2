import net.manaca.ui.paint.Record;

/**
 * 铅笔记录
 * @author Wersling
 * @version 1.0, 2006-4-18
 */
class net.manaca.ui.paint.PencilRecord extends Record{
	private var className : String = "net.manaca.ui.paint.PancilRecord";
	private var _mcName : String;
	private var _size : Number;
	private var _color : Number;
	private var _alpha : Number;
	private var _line_record:Array;
	private var _commands:Array;
	public function PencilRecord(mcName:String,size:Number,color:Number,alpha:Number) {
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
		if(_line_record.length == 1){
			//"Draw_Pancil@init,_size,_color,_alpha";
			var _comm1:String  = "Draw_Pancil@init,"+_size+","+_color+","+_alpha;
			//"Draw_Pancil@start,x,y,name";
			var _comm2:String  = "Draw_Pancil@start,"+x+","+y+","+_mcName;
			_commands.push(_comm1);
			_commands.push(_comm2);
			return [_comm1,_comm2];
		}else{
			//"Draw_Pancil@draw,x,y";
			var _comm:String  = "Draw_Pancil@draw,"+x+","+y;
			_commands.push(_comm);
			return [_comm];
		}
	}
	
	/**
	 * 结束记录
	 * @return Array 返回此操作的Commands
	 */
	public function endRecord():Array{
		//"Draw_Pancil@end";
		var _comm:String  = "Draw_Pancil@end";
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

//	/**
//	 * 通过toString()方法获取的字符 转为一个 PancilRecord 对象
//	 * @param record_str 通过toString()方法获取的字符
//	 * @return PancilRecord
//	 */
//	static public function createPancilRecord(record_str:String):PancilRecord{
//		var _v_arr:Array = record_str.split("|");
//		var pr:PancilRecord = new PancilRecord(_v_arr[0],Number(_v_arr[1]),Number(_v_arr[2]),Number(_v_arr[3]));
//		for (var i : Number = 4; i < _v_arr.length; i++) {
//			var l:Array = _v_arr[i].split(",");
//			pr.pushLine(Number(l[0]),Number(l[1]));
//		}
//		return pr;
//	}
	
//	/**
//	 * 指定toString()方法获取的字符获取命令行代码
//	 * @param record toString()方法获得的字符串
//	 * @see Type,action,parameter
//	 */
//	static public function createCommandLineForString(record_str:String):Array{
//		var _Type = "Pancil";
//		var _outArr:Array = new Array();
//		var _v_arr:Array = record_str.split("|");
//		for (var i : Number = 4; i < _v_arr.length; i++) {
//			if(i == 4){
//				//"Pancil,init,s,c,a";
//				_outArr.push("Pancil,init,"+_v_arr[1]+","+_v_arr[2]+","+_v_arr[3]);
//				//"Pancil,start,x,y,n";
//				_outArr.push("Pancil,start,"+_v_arr[4].split(",")[0]+","+_v_arr[4].split(",")[1]+","+_v_arr[0]);
//			}else{
//				//"Pancil,draw,x,y";
//				var __a:Array = _v_arr[i].split(",");
//				_outArr.push("Pancil,draw,"+__a[0]+","+__a[1]);
//			}
//		}
//		return _outArr;
//	}
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
	static public function Pack(pr:PencilRecord):String{
		var _str:String = "Draw_Pancil@" + pr.getName();
		_str = _str + "|" + pr.getSize();
		_str = _str + "|" + pr.getColor();
		_str = _str + "|" + pr.getAlpha();
		for (var i : Number = 0; i < pr.getRecord().length; i++) {
			_str = _str + "|" + pr.getRecord()[i].x + "," + pr.getRecord()[i].y;
		}
		return _str;
	}
	
	/**
	 * 反压缩
	 */
	static public function unPack(record_str:String):PencilRecord{
		record_str = record_str.slice(12);
		var _v_arr:Array = record_str.split("|");
		var pr:PencilRecord = new PencilRecord(_v_arr[0],Number(_v_arr[1]),Number(_v_arr[2]),Number(_v_arr[3]));
		for (var i : Number = 4; i < _v_arr.length; i++) {
			var l:Array = _v_arr[i].split(",");
			pr.pushLine(Number(l[0]),Number(l[1]));
		}
		pr.endRecord();
		return pr;
	}
}
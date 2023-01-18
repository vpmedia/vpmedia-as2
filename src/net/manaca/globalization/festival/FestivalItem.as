import net.manaca.lang.BObject;

/**
 * 一条节日信息
 * @author Wersling
 * @version 1.0, 2006-4-29
 */
class net.manaca.globalization.festival.FestivalItem extends BObject {
	private var className : String = "net.manaca.globalization.festival.FestivalItem";
	private var _fname : String;
	private var _code : String;
	private var _basilic : Boolean;
	private var _type : String;
	
	/**
	 * 构作一条节日信息
	 * @param code 一个用于记录日期的编号，编号为4位，具体表示：
	 * 		0415
	 * 		一般性节日：04 表示月，15 表示日
	 * 		星期性节日：04 表示月，1  表示第一个星期，5 表示星期几
	 * 		特殊记录的：*415只表示一个编号，用于查询。
	 * @param name 节日名称
	 * @param basilic 节日是否重要
	 * @param type 一个字符串，用于定义节日的表示类型
	 */
	public function FestivalItem(code:String,name:String,basilic:Boolean,type:String) {
		super();
		_fname = name;
		_code = code;
		_basilic = basilic;
		_type = type;
	}
	
	/**
	 * 一个用于记录日期的编号
	 * @param  value  参数类型：String 
	 * @return 返回值类型：String 
	 */
	public function set code(value:String) :Void
	{
		_code = value;
	}
	public function get code() :String
	{
		return _code;
	}
	
	/**
	 * 节日名称
	 * @param  value  参数类型：String 
	 * @return 返回值类型：String 
	 */
	public function set name(value:String) :Void
	{
		_fname = value;
	}
	public function get name() :String
	{
		return _fname;
	}

	/**
	 * 节日是否重要
	 * @param  value  参数类型：Boolean 
	 * @return 返回值类型：Boolean 
	 */
	public function set basilic(value:Boolean) :Void
	{
		_basilic = value;
	}
	public function get basilic() :Boolean
	{
		return _basilic;
	}
	
	/**
	 * 节日类型
	 * @param  value  参数类型：String 
	 * @return 返回值类型：String 
	 */
	public function set type(value:String) :Void
	{
		_type = value;
	}
	public function get type() :String
	{
		return _type;
	}
	
	public function toString():String{
		return ("["+code+","+basilic+","+name+","+type+"]");
	}
	
	/** 国际日期为依据节日类型 */
	static public var INTER : String = "inter";
	
	/** 国际性以星期为依据的类型节日类型 */
	static public var INTER_WEEK : String = "inter_week";
	
	/** 以中国农历为依据节日类型 */
	static public var CHINA : String = "china";
	
}
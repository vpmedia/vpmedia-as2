/**
 * 英文的节日信息
 * @author Wersling
 * @version 1.0, 2006-1-15
 */
class net.manaca.globalization.festival.FestivalInfoForEn {
	/**
	 * 获取英文的所有节日列表
	 */
	public static function getList():Array{
		var a:Array = new Array();
		a.push({Name:"Idian Festival",Data:INDIAN_FTV});
		//a.push({Name:"所有国际性节日",Data:ESP_FTV,Week:WEEK_FTV});
		//a.push({Name:"中国农历节日",Data:CHINA_FTV_FOR_CHINA_FESTIVAL});
		//a.push({Name:"中国公历节日",Data:CHINA_FTV_All});
		return a;
	}
	/** 印度节日 */
	public static var INDIAN_FTV:Array = new Array(
											["0113",false,"Lohri"],
											["0104",false,"Makar-Sankranti & Po"],
											["0121",false,"Guru Gobind Singh"],
											["0217",false,"Vasant Panchami"],
											["0224",false,"Id-Ul_Zuha"],
											["0227",false,"Ravidass Jayanti"],
											["0312",false,"Shiv Ratri"],
											["0325",false,"Moharram"],
											["0328",false,"Holi"],
											["0329",false,"Dhulendi,Good Friday"],
											["0413",false,"Baisakhi & Ugadi"],
											["0421",false,"Ram Navmi"],
											["0425",false,"Mahavir Jayanti"],
											["0526",false,"Budh Purnima"],
											["0525",false,"Milad-Ul-Nabi"],
											["0815",false,"Independence Day"],
											["0822",false,"Raksha Bandhan"],
											["0831",false,"Sri Krishna Janmasht"],
											["0910",false,"Ganesh Chaturthi"],
											["0920",false,"Anant Chaudas"]	,
											["1002",false,"Gandhi Jayanti"],
											["1015",false,"Dusehra"],
											["1021",false,"Balmiki Jayanti"],
											["1104",false,"Deepavali"],
											["1105",false,"Goverdhan Pooja"],
											["1106",false,"Bhaiyya Dooj"],
											["1120",false,"Guru Nanak Birthday"],
											["1207",false,"Id-Ul-Fitr"]
											);
	/** 常见的国际性节日 */
	public static var INT_FTV_FAR:Array = new Array(
											["1225",false,"圣诞节"],
											["1031",false,"万圣节"],
											["0812",false,"国际青年节"],
											["0601",false,"国际儿童节"],
											["0501",false,"国际劳动节"],
											["0401",false,"愚人节"],
											["0315",false,"世界消费者权益日"],
											["0308",false,"国际妇女节"],
											["0214",false,"情人节"],
											["0101",true,"元旦"]
											);
	
	/** 所有的国际性节日 */
	public static var ESP_FTV:Array = new Array(
											
											["1229",false,"国际生物多样性日"],
											["1209",false,"世界足球日"],
											["1203",false,"世界残疾人日"],
											["1201",false,"世界艾滋病日"],
											["1128",false,"感恩节"],
											["1125",false,"国际消除对妇女的暴力日"],
											["1117",false,"国际大学生节"],
											["1114",false,"世界糖尿病日"],
											["1111",false,"光棍节"],
											["1109",false,"消防宣传日"],
											["1029",false,"国际生物多样性日"],
											["1024",false,"联合国日,世界发展新闻日"],
											["1022",false,"世界传统医药日"],
											["1017",false,"世界消除贫困日"],
											["1016",false,"世界粮食节"],
											["1015",false,"国际盲人节,世界农村妇女日"],
											["1014",false,"世界标准日"],
											["1010",false,"世界精神卫生日"],
											["1009",false,"世界邮政日"],
											["1008",false,"世界视觉日"],
											//["1007",false,"国际住房日"],
											["1006",false,"国际老人节"],
											["1005",false,"世界教师日"],
											["1004",false,"世界动物日"],
											["1002",false,"国际减轻自然灾害日"],
											["1001",false,"国际音乐节,国际老年人日"],
											["0927",false,"世界旅游日"],
											//["0922",false,"国际聋人节"],
											["0921",false,"世界停火日"],
											["0920",false,"国际爱牙日"],
											//["0917",false,"国际和平日"],
											["0916",false,"国际臭氧层保护日"],
											["0808",false,"国际扫盲日"],
											["0711",false,"世界人口日"],
											["0701",false,"国际建筑日"],
											["0626",false,"国际反毒品日"],
											["0623",false,"国际奥林匹克日"],
											["0617",false,"防治荒漠化和干旱日"],
											["0605",false,"世界环境日"],
											["0531",false,"世界无烟日"],
											["0523",false,"国际牛奶日"],
											["0522",false,"国际生物多样性日"],
											["0518",false,"国际博物馆日"],
											["0517",false,"世界电信日"],
											["0515",false,"国际家庭日"],
											["0512",false,"国际护士节"],
											["0508",false,"世界红十字日"],
											["0505",false,"全国碘缺乏病日"],
											["0503",false,"世界哮喘日"],
											["0426",false,"世界知识产权日"],
											["0422",false,"世界地球日"],
											["0407",false,"世界卫生日"],
											["0324",false,"世界防治结核病日"],
											["0323",false,"世界气象日"],
											["0322",false,"世界水日"],
											["0321",false,"世界森林日,世界睡眠日"],
											["0314",false,"国际警察日,白色情人节"],
											["0305",false,"青年志愿者服务日"],
											["0210",false,"国际气象节"],
											["0202",false,"世界湿地日"]
											);
	/** 中国农历节日 */
	public static var CHINA_FTV_FOR_CHINA_FESTIVAL:Array  = new Array(
											["0100",true,"除夕"],
											["0101",true,"农历春节"],
											["0115",false,"元宵节"],
											["0505",false,"端午节"],
											["0707",false,"七夕情人节"],
											["0815",false,"中秋节"],
											["0909",false,"重阳节"],
											["1208",false,"腊八节"],
											["1224",false,"小年"]
											);
	/** 中国公历节日 */
	public static var CHINA_FTV_All:Array  = new Array(
											["1226",false,"毛泽东诞辰"],
											["1204",false,"中国法制宣传日"],
											["1112",false,"孙中山诞辰"],
											["1108",false,"中国记者日"],
											["1028",false,"中国男性健康日"],
											["1008",false,"中国高血压日"],	
											["1001",false,"中国国庆节"],	
											["0928",false,"孔子诞辰"],
											["0916",false,"中国脑健康日"],
											["0910",false,"中国教师节"],
											["0909",false,"毛泽东逝世纪念"],
											["0801",false,"中国人民解放军建军节"],
											["0707",false,"中国人民抗日战争纪念日"],
											["0701",false,"中国共产党诞生日"],
											["0625",false,"中国土地日"],
											["0520",false,"中国学生营养日"],
											["0519",false,"中国助残日"],
											["0504",false,"中国青年节"],
											["0312",false,"中国植树节"],
											["0309",false,"保护母亲河日"],
											["0303",false,"中国爱耳日"]
											);
	
	/** 某月的第几个星期几的节日 */
	public static var WEEK_FTV:Array  = new Array(
											["1024",false,"世界爱眼日"],
											["1023",false,"国际减轻自然灾害日"],
											["1011",false,"世界住房日"],
											["0920",false,"国际聋人节"],
											["0932",false,"国际和平日"],
											["0630",false,"父亲节"],
											["0520",false,"母亲节"]
											);
}
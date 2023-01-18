import net.manaca.data.HashTable;
//Source file: D:\\Wersling WAS Framework\\javacode\\net\\manaca\\util\\Properties.java

//package net.manaca.data;


/**
 * Properties 类表示了一个持久的属性集。Properties 可保存在流中或从流中加载。属性列表中每个键及其对应值都是一个字符串。 
 * 
 * 一个属性列表可包含另一个属性列表作为它的“默认值”；如果未能在原有的属性列表中搜索到属性键，则搜索第二个属性列表。 
 * 
 * 因为 Properties 继承于 Hashtable，所以可对 Properties 对象应用 put 和 putAll 方法。但强烈反对使用这两个方法，因为它们允许调用方插入其键或值不是 Strings 的项。相反，应该使用 setProperty 方法。如果在“有危险”的 Properties 对象（即包含非 String 的键或值）上调用 store 或 save 方法，则该调用将失败。 
 * 
 * 
 * load 和 store 方法按下面所指定的、简单的面向行的格式加载和存储属性。此格式使用 ISO 8859-1 字符编码。可以使用 Unicode 转义符来编写此编码中无法直接表示的字符；转义序列中只允许单个 'u' 字符。可使用 native2ascii 工具对属性文件和其他字符编码进行相互转换。 
 * 
 * @author Wersling
 * @version 1.0
 */
class net.manaca.data.Properties extends HashTable 
{
	
	/**
	 * @roseuid 4386B021030A
	 */
	public function Properties() 
	{
		
	}
}

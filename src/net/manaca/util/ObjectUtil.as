import net.manaca.util.ClassUtil;
import net.manaca.lang.Throwable;
//Source file: D:\\Wersling WAS Framework\\javacode\\was\\util\\concurrent\\ObjectUtil.java

//package was.util.concurrent;


/**
 * 类功能简要说明，静态类
 * @author Wersling
 * @version 1.0
 */
class net.manaca.util.ObjectUtil 
{
	
	/**
	 * @roseuid 4382F3350157
	 */
	/* 定义className */
	private var className : String = "net.manaca.util.ObjectUtil";
	
	/* 申明string串对象的类型 */
	public static var TYPE_STRING:String = "string";
	
	/* 申明number对象的类型 */
	public static var TYPE_NUMBER:String = "number";
	
	/* 申明object对象的类型 */
	public static var TYPE_OBJECT:String = "object";
	
	/* 申明boolean对象的类型 */
	public static var TYPE_BOOLEAN:String = "boolean";
	
	/* 申明movieclip对象的类型 */
	public static var TYPE_MOVIECLIP:String = "movieclip";
	
	/* 申明function对象的类型 */
	public static var TYPE_FUNCTION:String = "function";
	
	/* 申明undefined对象的类型 */
	public static var TYPE_UNDEFINED:String = "undefined";
	
	/* 申明null对象的类型 */
	public static var TYPE_NULL:String = "null";
	
	/* 申明Array对象的类型 */
	public static var TYPE_ARRAY:String = "array";
	
	/* 申明Button对象的类型 */
	public static var TYPE_BUTTON:String = "button";
	
	/* 申明Date对象的类型 */
	public static var TYPE_DATE:String = "date";
	
	/* 申明Color对象的类型 */
	public static var TYPE_COLOR:String = "color";
	
	/* 申明XML对象的类型 */
	public static var TYPE_XML:String = "xml";
	
	/* 申明XMLNode对象的类型 */
	public static var TYPE_XMLNODE:String = "xmlnode";
	
	/* 申明Sound对象的类型 */
	public static var TYPE_SOUND:String = "sound";
	
	/* 申明TextField对象的类型 */
	public static var TYPE_TEXTFIELD:String = "textfield";
	
	/* 申明Error对象的类型 */
	public static var TYPE_ERROR:String = "error";
	
	/* 私有构造函数，不可实例化 */
	private function ObjectUtil(Void) 
	{
		
	}
	
	/**
	 * 判断object数据对象 {@code object} 是否符合type类型 {@code type}
	 * 
	 * <p>每种类型数据 (即使是 {@code null} 和 {@code undefined}) 都符合 {@code Object} 类型
	 *
	 * <p>Flash内置类实例如11,"123",false符合 {@code String}, {@code Number} 或者 {@code Boolean} 类型
	 * 
	 * @param object 与 {@code type} 类型进行比较的数据对象

	 * @param type 用于比较的类型

	 * @return {@code true} 如果 {@code object} 的数据类型是 {@code type} 否则
	 * {@code false}
	 */
	public static function typesMatch(object:Object, type:Function):Boolean 
	{
		if (type === Object) {
			return true;
		}
		if (isPrimitiveType(object)) {
			var t:String = typeof(object);
			// Workaround for former used: typesMatch(type(object), object);
			// Casting is not a good solution, it will break if the Constructor throws a error!
			// This solution is not the fastest but will not break by any exception.
			if((type === String || ClassUtil.isSubClassOf(type, String)) && t == TYPE_STRING) {
				return true;
			}
			if((type === Boolean || ClassUtil.isSubClassOf(type, Boolean)) && t == TYPE_BOOLEAN) {
				return true;
			}
			if((type === Number || ClassUtil.isSubClassOf(type, Number)) && t == TYPE_NUMBER) {
				return true;
			}
			return false;
		} else {
			return (isInstanceOf(object, type));
		}
	}
	
	/**
	 * 比较两个数据对象的类型是否相同

	 * 
	 * @param firstObject 用于比较的第一个数据对象

	 * @param secondObject 用于比较的第二个数据对象
	 * @return {@code true} 如果两个数据对象的类型相同，否则
	 * {@code false}
	 */
	public static function compareTypeOf(firstObject:Object, secondObject:Object):Boolean
	{
		return (typeof(firstObject) == typeof(secondObject));
	}
	
	/**
	 * 检查某数据对象 {@code object} 是否是Flash内置的类型

	 *
	 * <p>Flash内置数据类型：string, number 及 boolean，这三种类型可以不通过new 运算符创建。 
	 * 例如 {@code "myString"}, {@code 3} 及 {@code true} 是内置数据类型, 
	 * 而 {@code new String("myString")}, {@code new Number(3)} 和

	 * {@code new Boolean(true)} 则不是。

	 * 
	 * @param object the object to check whether it is a prmitive type
	 * @return {@code true} if {@code object} is a primitive type else {@code false}
	 */
	public static function isPrimitiveType(object:Object):Boolean
	{
		var t:String = typeof(object);
		return (t == TYPE_STRING || t == TYPE_NUMBER || t == TYPE_BOOLEAN);
	}
	
	/**
	 * 判断 object 数据对象是否是 type 数据类型
	 * 
	 * <p>type数据类型只支持已定义的类型，即

	 * TYPE_STRING,TYPE_NUMBER,TYPE_OBJECT,TYPE_BOOLEAN,TYPE_MOVIECLIP,TYPE_FUNCTION,TYPE_NULL,TYPE_UNDEFINED
	 *
	 * @param object 需要检查类型的数据对象
	 * @param type 类型名称，字符串表示
	 * @return {@code true} 如果object符合 {@code type} 类型
	 */
	public static function isTypeOf(object:Object, type:String):Boolean
	{
		return (typeof(object) == type);
	}
	
	/**
	 * 获取 object 数据对象的 type 数据类型
	 * 
	 * <p>type数据类型只支持已定义的类型，即

	 * TYPE_STRING,TYPE_NUMBER,TYPE_OBJECT,TYPE_BOOLEAN,TYPE_MOVIECLIP,TYPE_FUNCTION,TYPE_NULL,TYPE_UNDEFINED
	 *
	 * @param object 需要检查类型的数据对象
	 * @return 返回 object的 {@code type} 类型
	 */
	public static function getTypeOf(object:Object):String
	{
		return typeof(object);
	}
	
	/**
	 * 判断 {@code object} 数据对象是否是 {@code type} 类型的实例

	 * 
	 * <p>如果 {@code type} 类型是 {@code Object}, 那么将一直返回 {@code true}, 
	 * 因为每个数据对象都是 {@code Object} 的实例, 包括 {@code null} 和 {@code undefined}.
	 * 
	 * @param object 需要检查的object
	 * @param type 需要检查 {@code object} 的类型

	 * @return {@code true} 如果 {@code object} 是 {@code type} 的一个实例，否则
	 * {@code false}
	 */
	public static function isInstanceOf(object:Object, type:Function):Boolean
	{
		if (type === Object) {
			return true;
		}
		return (object instanceof type);
	}
	
	/**
	 * 判断 {@code object} 是否是 {@code clazz} 的继承实例

	 * 
	 * <p>只有所给的对象 {@code object} 是从 {@code clazz} 直接实例化才会返回 {@code true}
	 * 
	 * @param object 用于检测是否是 {@code clazz} 的直接实例

	 * @param clazz 用于判断的基础类

	 * @return {@code true} 如果object是 {@code clazz} 的直接实例，否则
	 * {@code false}
	 */
	public static function isExplicitInstanceOf(object:Object, clazz:Function):Boolean
	{
		if (isPrimitiveType(object)) {
			if (clazz == String) {
				return (typeof(object) == TYPE_STRING);
			}
			if (clazz == Number) {
				return (typeof(object) == TYPE_NUMBER);
			}
			if (clazz == Boolean) {
				return (typeof(object) == TYPE_BOOLEAN);
			}
		}
		return (object instanceof clazz	&& !(object.__proto__ instanceof clazz));
	}
	
	/**
	 * 解析object对象
	 */
	public static function analyzeObj(object:Object):String
	{
		var obj_str:String = "";
		var type:String = getTypeOf(object);
		if(type == TYPE_STRING) {
			obj_str += "\"" + object.toString() + "\"";
		} else if((type == TYPE_NUMBER) || (type == TYPE_BOOLEAN)) {
			obj_str += object.toString();
		} else if((type == TYPE_NULL) || (type == TYPE_UNDEFINED)) {
			obj_str += "(" + type + ")";
		} else {
			if(isInstanceOf(object,String)) {
				obj_str += "("+ TYPE_STRING +")\""+ object.toString() +"\"";
			} else if(isInstanceOf(object,Number)) {
				obj_str += "("+ TYPE_NUMBER +")"+ object.toString();
			} else if(isInstanceOf(object,Boolean)) {
				obj_str += "("+ TYPE_BOOLEAN +")"+ object.toString();
			} else if(isInstanceOf(object,Array))	{
				obj_str += "("+ TYPE_ARRAY +")"+ object;	
			} else if(ObjectUtil.isInstanceOf(object,Button))	{
				obj_str += "("+ TYPE_BUTTON +")"+ object;
			} else if(ObjectUtil.isInstanceOf(object,Error)) {
				obj_str += "("+ TYPE_ERROR +")错误信息："+ Throwable(object).getMessage()+"错误原因："+Throwable(object).getCause();
			} else if(ObjectUtil.isInstanceOf(object,Date)) {
				obj_str += "("+ TYPE_DATE +")"+ object;
			} else if(ObjectUtil.isInstanceOf(object,Color)) {
				obj_str += "("+ TYPE_COLOR +")"+ Color(object).getRGB().toString(16);
			} else if(ObjectUtil.isInstanceOf(object,MovieClip)) {
				obj_str += "("+ TYPE_MOVIECLIP +")"+ object;
			} else if(ObjectUtil.isInstanceOf(object,XML)) {
				obj_str += "("+ TYPE_XML +")"+ object.toString();
			} else if(ObjectUtil.isInstanceOf(object,XMLNode)) {
				obj_str += "("+ TYPE_XMLNODE +")"+ object.toString();
			} else if(ObjectUtil.isInstanceOf(object,Sound)) {
				obj_str += "("+ TYPE_SOUND +")"+ object;
			} else if(ObjectUtil.isInstanceOf(object,TextField)) {
				obj_str += "("+ TYPE_TEXTFIELD +")"+ object +"[text:\"" +TextField(object).text+ "\"]";
			} else if(ObjectUtil.isInstanceOf(object,Function)) {
				obj_str += "("+ TYPE_FUNCTION +")"+ Function(object);
			} else {
				obj_str += "(Unknown Type)"+object.toString();
			}
		}
		return obj_str;
	}
	/**
	 * 解析object对象
	 */
	public static function analyze(object:Object):String
	{
		var obj_str:String = "";
		var type:String = getTypeOf(object);
		if(type == TYPE_STRING) {
			obj_str += TYPE_STRING;
		} else if((type == TYPE_NUMBER) || (type == TYPE_BOOLEAN)) {
			obj_str += TYPE_NUMBER;
		} else if((type == TYPE_NULL) || (type == TYPE_UNDEFINED)) {
			obj_str += TYPE_NULL;
		} else {
			if(isInstanceOf(object,String)) {
				obj_str += TYPE_STRING;
			} else if(isInstanceOf(object,Number)) {
				obj_str += TYPE_NUMBER;
			} else if(isInstanceOf(object,Boolean)) {
				obj_str += TYPE_BOOLEAN;
			} else if(isInstanceOf(object,Array))	{
				obj_str += TYPE_ARRAY;	
			} else if(ObjectUtil.isInstanceOf(object,Button))	{
				obj_str += TYPE_BUTTON;
			} else if(ObjectUtil.isInstanceOf(object,Error)) {
				obj_str += TYPE_ERROR;
			} else if(ObjectUtil.isInstanceOf(object,Date)) {
				obj_str += TYPE_DATE;
			} else if(ObjectUtil.isInstanceOf(object,Color)) {
				obj_str += TYPE_COLOR;
			} else if(ObjectUtil.isInstanceOf(object,MovieClip)) {
				obj_str += TYPE_MOVIECLIP;
			} else if(ObjectUtil.isInstanceOf(object,XML)) {
				obj_str += TYPE_XML;
			} else if(ObjectUtil.isInstanceOf(object,XMLNode)) {
				obj_str += TYPE_XMLNODE;
			} else if(ObjectUtil.isInstanceOf(object,Sound)) {
				obj_str += TYPE_SOUND;
			} else if(ObjectUtil.isInstanceOf(object,TextField)) {
				obj_str += TYPE_TEXTFIELD;
			} else if(ObjectUtil.isInstanceOf(object,Function)) {
				obj_str += TYPE_FUNCTION;
			} else if(ObjectUtil.isInstanceOf(object,Object)) {
				obj_str += TYPE_OBJECT;
			} else {
				obj_str += "null";
			}
		}
		return obj_str;
	}
	
	 /**
     *  This method returns <code>true</code> if the object reference specified
     *  is one of the following simple types:
     *  <ul>
     *    <li><code>String</code></li>
     *    <li><code>Number</code></li>
     *    <li><code>uint</code></li>
     *    <li><code>int</code></li>
     *    <li><code>Boolean</code></li>
     *    <li><code>Date</code></li>
     *    <li><code>Array</code></li>
     *  </ul>
     *
     *  @param value The object that should be inspected.
     *
     *  @return <code>true</code> if the object specified
     *  is one of the types above; <code>false</code> otherwise.
     */
    public static function isSimple(value:Object):Boolean
    {
        var type:String = typeof(value);
        switch (type)
        {
            case "number":
            case "string":
            case "boolean":
            {
                return true;
            }

            case "object":
            {
                return (typeof(value) == TYPE_DATE) || (typeof(value) == TYPE_DATE);
            }
        }

        return false;
    }
    

}

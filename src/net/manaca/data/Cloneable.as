//Source file: D:\\Wersling WAS Framework\\javacode\\was\\util\\Cloneable.java

//package was.util;


/**
 * 此类实现了 Cloneable 接口，以指示 Object.clone() 方法可以合法地对该类实例进行按字段复制。 
 * 
 * 如果在没有实现 Cloneable 接口的实例上调用 Object 的 clone 方法，则会导致抛出 CloneNotSupportedException 异常。 
 * 
 * 按照惯例，实现此接口的类应该使用公共方法重写 Object.clone（它是受保护的）。请参阅 Object.clone()，以获得有关重写此方法的详细信息。 
 * 
 * 注意，此接口不 包含 clone 方法。因此，因为某个对象实现了此接口就克隆它是不可能的。即使 clone 方法是反射性调用的，也无法保证它将获得成功。
 * @author Wersling
 * @version 1.0
 */
interface net.manaca.data.Cloneable 
{
}

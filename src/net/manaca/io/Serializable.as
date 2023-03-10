/**
 * 类通过实现 net.manaca.io.Serializable 接口以启用其序列化功能。未实现此接口的类将无法使其任
 * 何状态序列化或反序列化。可序列化类的所有子类型本身都是可序列化的。序列化接口没有方法或字段，
 * 仅用于标识可序列化的语义。
 * 
 * 要允许不可序列化类的子类型序列化，可以假定该子类型负责保存和还原超类型的公用 (public)、
 * 受保护的 (protected) 和（如果可访问）包 (package) 字段的状态。仅在子类型扩展的类有一个可访问的无
 * 参数构造方法来初始化该类的状态时，才可以假定子类型有此责任。如果不是这种情况，则声明一个类为可序
 * 列化类是错误的。该错误将在运行时检测到。
 * 
 * @author Wersling
 * @version 1.0, 2006-1-16
 */
interface net.manaca.io.Serializable {
}
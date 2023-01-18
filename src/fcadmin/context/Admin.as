/******************************************************************************* 
 * Contributors: 
 *        pawaca(pawaca@mess-up.com) - initial API and implementation 
 * Last modified:
 *        2004-12-14
 ******************************************************************************/


import fcadmin.AdminConnection;
import fcadmin.context.AbstractContext;
import fcadmin.context.CommandResult;
import fcadmin.utils.ResultProxy;

/**
 * Admin wraps some of Server Management ActionScript API to provide a high 
 * level abstraction for the admin management.
 */
class fcadmin.context.Admin extends AbstractContext
{
	
	
	private var __name:String;
	private var __scope:String;
	
	
	/**
	 * Return the name of this admin.
	 * @readable true
	 * @writable false
	 */
	function get name():String
	{
		return __name;
	}


	/**
	 * Return the scope of this admin.
	 * @readable true
	 * @writable false
	 */
	function get scope():String
	{
		return __scope;
	}


	/**
	 * Constructor, usually you can get the specified admin context
	 * instance from AdminConnection.admin after it connected
	 * successfully.
	 *
	 * @param name name of this admin.
	 * @param scope scope of this admin.
	 * @param adminConnection the host AdminConnection instance for this 
	 *				admin context.
	 * @see fcadmin.AdminConnection.admin
	 */
	function Admin(name:String,scope:String,adminConnection:AdminConnection)
	{
		super(adminConnection);

		__name=name;
		__scope=scope;

	}

	/**
	 * Changes the password for the specified administrator.
	 * The password is encoded before it is written to the 
	 * Server.xml configuration file.
	 * Virtual host administrators can change only their 
	 * own password. 
	 *
	 * @param pswd String that contains that administrator's new password.
	 * @param result
	 * @throw fcadmin.context.PermissionError
	 */
	function changePswd(pswd:String,result:CommandResult):Void
	{
		checkPermission(scope);

		var resultProxy:ResultProxy=new ResultProxy(result,"success","failed");
		callService("changePswd",resultProxy,name,pswd,scope);
	}



	/**
	 * Removes an administrator from the system. Depending on the parameters 
	 * you specify, you can remove server administrators or virtual host 
	 * dministrators.
	 * You must be a server administrator to remove an administrator from 
	 * the system.
	 *
	 * @return result
	 * @throw fcadmin.context.PermissionError
	 */
	function remove(result:CommandResult):Void
	{
		checkPermission("server");
		
		var resultProxy:ResultProxy=new ResultProxy(result,"success","failed");		
		callService("removeAdmin",resultProxy,name,scope);

	}

	
	function getPath():String
	{
		if(scope=="server")
		{
			return getHostString() + "/admins/" + name;
		}
		else
		{
			return getHostString() + "/" + scope + "/admins/" + name;
		}
	}

	function toString():String
	{
		return "[Admin] name = " + name + ", scope = " + scope;
	}
	
}


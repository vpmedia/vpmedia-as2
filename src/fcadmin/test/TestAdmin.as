/******************************************************************************* 
 * Contributors: 
 *        pawaca(pawaca@mess-up.com) - initial API and implementation 
 * Last modified:
 *        2004-12-14
 ******************************************************************************/

import logging.Logger;

import as2unit.framework.TestCase;
import as2unit.framework.TestSuite;
import as2unit.framework.Test;

import fcadmin.context.Admin;
import fcadmin.context.CommandResult;

class fcadmin.test.TestAdmin extends TestCase
{

	private static var logger:Logger = Logger.getLogger("fcadmin.test.TestAdmin");

	
	public function TestAdmin( methodName:String )
	{
		super( methodName );
		setClassName("fcadmin.test.TestAdmin");
	}

//------------------------------------------------------------------------------

	public function testChangePswd():Void
	{
		var result:CommandResult=new CommandResult();
		result.success=function()
		{
			TestAdmin["logger"].info("testChangePswd result OK.");
		}
		admin.changePswd("000000",result);
	}

//------------------------------------------------------------------------------
/*
	public function testRemove():Void
	{
		var result:CommandResult=new CommandResult();
		result.success=function()
		{
			TestAdmin["logger"].info("testRemove result OK.");
		}
		admin.remove(result);
	}
*/
//------------------------------------------------------------------------------


	public static function suite():Test
	{
		return new TestSuite(fcadmin.test.TestAdmin);
	}

	/**
	 * Runs the test case.
	 */
	public static function main(adm:Admin):Void
	{
		
		admin=adm;
		as2unit.textui.TestRunner.run(suite());
	}


	private static var admin:Admin=null;


	private static var AdminDependency:Admin=fcadmin.context.Admin;

	private static var TestSuiteDependency:TestSuite=as2unit.framework.TestSuite;
	private static var TestDependency:Test=as2unit.framework.Test;	

}


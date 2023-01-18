/******************************************************************************* 
 * Contributors: 
 *        pawaca(pawaca@mess-up.com) - initial API and implementation 
 * Last modified:
 *        12/12/2004
 ******************************************************************************/


import mx.utils.Delegate;

import logging.Logger;
import logging.Level;

import fcadmin.AdminConnection;
import fcadmin.context.AppsResult;
import fcadmin.context.App;
import fcadmin.context.ActiveInstance;
import fcadmin.context.ActiveInstancesResult;
import fcadmin.context.User;
import fcadmin.context.UsersResult;
import fcadmin.context.SharedObjectsResult;
import fcadmin.context.SharedObjectContext;
import fcadmin.context.StreamContext;
import fcadmin.context.StreamsResult;
import fcadmin.context.AdminsResult;
import fcadmin.context.Admin;
import fcadmin.test.TestAdaptor;
import fcadmin.test.TestVHost;
import fcadmin.test.TestServer;
import fcadmin.test.TestApp;
import fcadmin.test.TestActiveInstance;
import fcadmin.test.TestUser;
import fcadmin.test.TestSharedObject;
import fcadmin.test.TestStream;
import fcadmin.test.TestAdmin;
import fcadmin.utils.ClassUtil;



class fcadmin.test.TestApi
{

	private static var logger:Logger = Logger.getLogger("fcadmin.test.TestApi");

	private static var adminConnection:AdminConnection=null;
	private static var adminPath:String="rtmp://localhost:1111/admin";
	private static var adminUsername:String="pawaca";
	private static var adminPswd:String="888888";


	private static var TestAdaptorDependency:TestAdaptor=fcadmin.test.TestAdaptor;
	private static var TestVHostDependency:TestVHost=fcadmin.test.TestVHost;
	private static var TestServerDependency:TestServer=fcadmin.test.TestServer;
	private static var TestAppDependency:TestApp=fcadmin.test.TestApp;
	private static var TestActiveInstanceDependency:TestActiveInstance=fcadmin.test.TestActiveInstance;
	private static var TestUserInstanceDependency:TestUser=fcadmin.test.TestUser;
	private static var TestSharedObjectDependency:TestSharedObject=fcadmin.test.TestSharedObject;
	private static var TestStreamDependency:TestStream=fcadmin.test.TestStream;
	private static var TestAdminDependency:TestAdmin=fcadmin.test.TestAdmin;
	


	/**
	 * Runs the test case.
	 */
	public static function main(args:Array):Void
	{				
		logger.info("Start TestApi");
		//testAdaptor();
		//testVHost();
		//testServer();
		//prepareTestApp();
		//prepareTestActiveInstance();
		//prepareTestUser();
		//prepareTestSharedObject();
		//prepareTestStream();
		//prepareTestAdmin();
	}



//------------------------------------------------------------------------------

	private static function testAdaptor():Void
	{
		logger.info("Unit Test fcadmin.test.TestAdaptor");
		fcadmin.test.TestAdaptor.main(adminConnection.adaptor);
	}

//------------------------------------------------------------------------------

	private static function testVHost():Void
	{
		logger.info("Unit Test fcadmin.test.TestVHost");
		fcadmin.test.TestVHost.main(adminConnection.vhost);
	}

//------------------------------------------------------------------------------
	
	private static function testServer():Void
	{
		logger.info("Unit Test fcadmin.test.TestServer");
		fcadmin.test.TestServer.main(adminConnection.server);
	}

//------------------------------------------------------------------------------

	private static function prepareTestApp():Void
	{
		logger.info("Prepare Test fcadmin.test.TestApp");
		var result:AppsResult=new AppsResult();
		result.getAppsSuccess=function(apps:Array)
		{
			TestApi.testApp(TestApi.findApp("test_fcadmin",apps)); //select test_fcadmin
		}
		adminConnection.server.getApps(result);
	}

//------------------------------------------------------------------------------

	private static function testApp(app:App):Void
	{
		logger.info("Unit Test fcadmin.test.TestApp");
		fcadmin.test.TestApp.main(app);		
	}

//------------------------------------------------------------------------------

	private static function prepareTestActiveInstance():Void
	{
		logger.info("Prepare Test fcadmin.test.ActiveInstance");
		var result:AppsResult=new AppsResult();
		result.getAppsSuccess=function(apps:Array)
		{
			var result:ActiveInstancesResult=new ActiveInstancesResult();
			result.getActiveInstancesSuccess=function(instances:Array)
			{
				TestApi.testActiveInstance(instances[random(instances.length)]); //select a instances
			}
			TestApi.findApp("test_fcadmin",apps).getActiveInstances(result); //select test_fcadmin
		}
		adminConnection.server.getApps(result);
	}

	private static function testActiveInstance(instance:ActiveInstance):Void
	{
		logger.info("Unit Test fcadmin.test.TestActiveInstance");
		if(instance==null)
		{
			logger.warning("[TestApi.testActiveInstance] IllegalArgument: ActiveInstance undefined");
			return;
		}
		fcadmin.test.TestActiveInstance.main(instance);	
	}

//------------------------------------------------------------------------------

	private static function prepareTestUser():Void
	{
		logger.info("Prepare Test fcadmin.test.TestUser");
		var result:AppsResult=new AppsResult();
		result.getAppsSuccess=function(apps:Array)
		{
			var result:ActiveInstancesResult=new ActiveInstancesResult();
			result.getActiveInstancesSuccess=function(instances:Array)
			{				
				var result:UsersResult=new UsersResult();
				result.getUsersSuccess=function(users:Array)
				{
					TestApi.testUser(users[random(users.length)]); //select a users
				}
				instances[random(instances.length)].getUsers(result);
			}
			TestApi.findApp("test_fcadmin",apps).getActiveInstances(result); //select test_fcadmin
		}
		adminConnection.server.getApps(result);
	}

	private static function testUser(user:User)
	{
		logger.info("Unit Test fcadmin.test.TestUser");
		if(user==null)
		{
			logger.warning("[TestApi.testUser] IllegalArgument: User undefined");
			return;
		}
		fcadmin.test.TestUser.main(user);	
	}

//------------------------------------------------------------------------------

	private static function prepareTestSharedObject():Void
	{
		logger.info("Prepare Test fcadmin.test.TestSharedObject");
		var result:AppsResult=new AppsResult();
		result.getAppsSuccess=function(apps:Array)
		{
			var result:ActiveInstancesResult=new ActiveInstancesResult();
			result.getActiveInstancesSuccess=function(instances:Array)
			{				
				var result:SharedObjectsResult=new SharedObjectsResult();
				result.getSharedObjectsSuccess=function(socs:Array)
				{
					TestApi.testSharedObject(socs[random(socs.length)]); //select a sharedobject
				}
				instances[random(instances.length)].getSharedObjects(result);
			}
			TestApi.findApp("test_fcadmin",apps).getActiveInstances(result); //select test_fcadmin
		}
		adminConnection.server.getApps(result);
	}

	private static function testSharedObject(soc:SharedObjectContext)
	{
		logger.info("Unit Test fcadmin.test.TestSharedObject");
		if(soc==null)
		{
			logger.warning("[TestApi.testSharedObject] IllegalArgument: SharedObjectContext undefined");
			return;
		}
		fcadmin.test.TestSharedObject.main(soc);	
	}

//------------------------------------------------------------------------------
	private static function prepareTestStream():Void
	{
		logger.info("Prepare Test fcadmin.test.TestStream");
		var result:AppsResult=new AppsResult();
		result.getAppsSuccess=function(apps:Array)
		{
			var result:ActiveInstancesResult=new ActiveInstancesResult();
			result.getActiveInstancesSuccess=function(instances:Array)
			{				
				var result:StreamsResult=new StreamsResult();
				result.getStreamsSuccess=function(streams:Array)
				{
					TestApi.testStream(streams[random(streams.length)]); //select a streams
				}
				instances[random(instances.length)].getStreams(result);
			}
			TestApi.findApp("test_fcadmin",apps).getActiveInstances(result); //select test_fcadmin
		}
		adminConnection.server.getApps(result);
	}

	private static function testStream(stream:StreamContext)
	{
		logger.info("Unit Test fcadmin.test.TestStream");
		if(stream==null)
		{
			logger.warning("[TestApi.testStream] IllegalArgument: StreamContext undefined");
			return;
		}
		fcadmin.test.TestStream.main(stream);	
	}

//------------------------------------------------------------------------------

	private static function prepareTestAdmin():Void
	{
		logger.info("Prepare Test fcadmin.test.TestAdmin");
		var result:AdminsResult=new AdminsResult();
		result.getAdminsSuccess=function(admins:Array)
		{
			TestApi.testAdmin(TestApi.findAdmin("testAdmin",admins)); //select testAdmin
		}
		adminConnection.server.getAdmins(result);
	}

	private static function testAdmin(admin:Admin)
	{
		logger.info("Unit Test fcadmin.test.TestAdmin");
		if(admin==null)
		{
			logger.warning("[TestApi.testAdmin] IllegalArgument: Admin undefined");
			return;
		}
		fcadmin.test.TestAdmin.main(admin);	
	}

//------------------------------------------------------------------------------




	private static function findApp(name:String,apps:Array):App
	{
		for(var i:Number=0;i<apps.length;i++)
		{
			if(apps[i].name==name)
			{
				return apps[i];
			}
		}
	}



	private static function findAdmin(name:String,admins:Array):Admin
	{
		for(var i:Number=0;i<admins.length;i++)
		{
			if(admins[i].name==name)
			{
				return admins[i];
			}
		}
	}


	



	private function TestApi()
	{
	}


	// workaround a bug in AS2Unit
	// see http://www.mess-up.com/blogs/pawastation.php/2004/11/17/as2unit_af_a_uc_bug
	private static function configStaticField():Void
	{
		ClassUtil.hideStatic(TestApi);
		ClassUtil.hideStatic(TestAdaptor);
		ClassUtil.hideStatic(TestVHost);
		ClassUtil.hideStatic(TestServer);
		ClassUtil.hideStatic(TestApp);
		ClassUtil.hideStatic(TestActiveInstance);
		ClassUtil.hideStatic(TestSharedObject);
		ClassUtil.hideStatic(TestStream);
		ClassUtil.hideStatic(TestAdmin);
	}

	private static function configLogging():Void
	{
		Logger.getLogger("fcadmin.context.AbstractContext").setLevel((Level.INFO));
	}


	private static function classConstruct():Boolean
	{
		if(classConstructed==undefined)
		{
			configStaticField();
			configLogging();

			adminConnection=new AdminConnection(adminPath,adminUsername,adminPswd);
			adminConnection.addEventListener("connectSuccess",Delegate.create(TestApi,TestApi.main));
			adminConnection.connect();
			classConstructed=true;
		}
		return classConstructed;
	}


	private static var DelegateDependency:Delegate=mx.utils.Delegate;
	private static var AdminConnectionDependency:AdminConnection=fcadmin.AdminConnection;
	private static var ClassUtilDependency:ClassUtil=fcadmin.utils.ClassUtil;

	private static var classConstructed:Boolean=classConstruct();

}


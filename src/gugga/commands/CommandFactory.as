import gugga.collections.HashTable;
import gugga.common.ICommand;
import gugga.common.UIComponentEx;
import gugga.debug.Assertion;

/**
 * @author Krasimir
 */
class gugga.commands.CommandFactory extends UIComponentEx {
	
	private static var mInstance:CommandFactory = undefined;

	public static function get Instance():CommandFactory
	{
		if (mInstance == undefined)
		{
			mInstance = new CommandFactory();
		}
		return mInstance;
	}
	private function CommandFactory() {
		super();
		mCommandCatalog = new HashTable();
	}
	
	private var mCommandCatalog:HashTable;
	
	public function create(aCommandType:String,aParams:HashTable):ICommand
	{
		
		if (!mCommandCatalog.containsKey(aCommandType) || mCommandCatalog[aCommandType] == undefined)
		{
			Assertion.warning("Command " + aCommandType + " is not defined.", this, arguments);
//			throw new Error("Command " + aCommandType + " does not defined." );
			return undefined;
		}
		
		var cmd:ICommand = ICommand(mCommandCatalog[aCommandType]).clone();
		
		// fill in params
		for(var key:String in aParams) 
		{
			cmd[key] = aParams[key];
		}
		return cmd;
	}
	
	//
	
	public function createFromArgumnets(aCommandType:String,aArguments:String)
	{
		var argumentsArray:Array = aArguments.split("&");
		var paramsHash:HashTable = new HashTable();

		for (var i = 0 ; i <   argumentsArray.length ; i++)
		{
			var argNameValue:Array = argumentsArray[0].split("&",2);;
			if (argNameValue.length = 2)
				paramsHash[argNameValue[0]] = argNameValue[1];
			else 
			  paramsHash[argNameValue[0]]  = true;
		}
		
		return create(aCommandType,paramsHash);
		
	}
	
	public function add(aCommandType:String,aCommand:ICommand)
	{
		if (mCommandCatalog.containsKey(aCommandType) && mCommandCatalog[aCommandType] != undefined)
		{
			Assertion.warning("Command " + aCommandType + " already added. To replace it use replace instead", this, arguments);
			return;
		}
		mCommandCatalog[aCommandType] = aCommand;
	}

	
	public function replace(aCommandType:String,aCommandPrototype:ICommand)
	{
		mCommandCatalog[aCommandType] = aCommandType;
	}
	public function remove(aCommandType:String)
	{
		mCommandCatalog[aCommandType] = undefined;
	}
	
}
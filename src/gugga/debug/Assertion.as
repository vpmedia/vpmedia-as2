import gugga.collections.ArrayList;
import gugga.collections.CheckList;
import gugga.collections.HashTable;
import gugga.collections.LinkedList;
import gugga.collections.ObjectHashTable;
import gugga.logging.Level;
import gugga.logging.Logger;
import gugga.utils.DebugUtils;

/**
 * @author Todor Kolev
 */
dynamic class gugga.debug.Assertion 
{
	private static function logAssertion(aLogLevel : Level, aMessage:String, aContextObject:Object, aContextMethodArguments:Array)
	{
		var logger : Logger = Logger.getLoggerFor(aContextObject);		
		var contextString : String = DebugUtils.getCallContextString(aContextObject, aContextMethodArguments);
	
		var logString : String = aMessage + " [" + contextString + "]";
		
		logger.log(aLogLevel, logString);
	}
	
	private static function evaluateMethod(aScope:Object, aMethod:Function, aArguments:Array) : Object
	{
		if(aArguments == null || aArguments == undefined)
		{
			aArguments = new Array();
		}
		
		return aMethod.apply(aScope, aArguments);
	}
	
	private static function containsValue(aCollection:Object, aValue:Object) : Boolean
	{
		if(aCollection instanceof LinkedList)
		{
			return LinkedList(aCollection).contains(aValue);
		}
		else if(aCollection instanceof HashTable)
		{
			return HashTable(aCollection).containsValue(aValue);
		}
		else if(aCollection instanceof ObjectHashTable)
		{
			return ObjectHashTable(aCollection).containsValue(aValue);
		}
		else if(aCollection instanceof ArrayList)
		{
			return ArrayList(aCollection).containsItem(aValue);
		}
		else if(aCollection instanceof CheckList)
		{
			return CheckList(aCollection).isObjectRegistered(aValue);
		}
		else
		{
			for (var key:String in aCollection)
			{
				if(aCollection[key] === aValue)
				{
					return true;
				}
			}
			
			return false;
		}
	}
	
	private static function containsKey(aCollection:Object, aKey:Object) : Boolean
	{
		if(aCollection instanceof HashTable)
		{
			return HashTable(aCollection).containsKey(aKey);
		}
		else if(aCollection instanceof ObjectHashTable)
		{
			return ObjectHashTable(aCollection).containsKey(aKey);
		}
		else
		{
			for (var key:String in aCollection)
			{
				if(key === aKey)
				{
					return true;
				}
			}
			
			return false;
		}
	}
	
	//------------ FAIL
	
	public static function fail(aMessage:String, aContextObject:Object, aContextMethodArguments:Array) : Void
	{
		logAssertion(Level.SEVERE, aMessage, aContextObject, aContextMethodArguments);
		throw new Error(aMessage);
	}
	
	public static function failIfTrue(aVar:Boolean, aMessage:String, aContextObject:Object, aContextMethodArguments:Array):Void
	{
		if(aVar)
		{
			fail(aMessage, aContextObject, aContextMethodArguments);
		}
	}
	
	public static function failIfFalse(aVar:Boolean, aMessage:String, aContextObject:Object, aContextMethodArguments:Array):Void
	{
		if(!aVar)
		{
			fail(aMessage, aContextObject, aContextMethodArguments);
		}
	}
	
	public static function failIfNotNull(aVar:Object, aMessage:String, aContextObject:Object, aContextMethodArguments:Array):Void
	{
		if(aVar != null && aVar != undefined)
		{
			fail(aMessage, aContextObject, aContextMethodArguments);
		}
	}
	
	public static function failIfNull(aVar:Object, aMessage:String, aContextObject:Object, aContextMethodArguments:Array):Void
	{
		if(aVar == null || aVar == undefined)
		{
			fail(aMessage, aContextObject, aContextMethodArguments);
		}
	}
	
	public static function failIfEmpty(aVar:Object, aMessage:String, aContextObject:Object, aContextMethodArguments:Array):Void
	{
		if(aVar == null || aVar == undefined || aVar == "")
		{
			fail(aMessage, aContextObject, aContextMethodArguments);
		}
	}
	
	public static function failIfNotEqual(aVar1:Object, aVar2:Object, aMessage:String, aContextObject:Object, aContextMethodArguments:Array):Void
	{
		if(aVar1 != aVar2)
		{
			fail(aMessage + "(" + aVar1 + " != " + aVar2 + ")", aContextObject, aContextMethodArguments);
		}
	}
	
	public static function failIfNotSame(aVar1:Object, aVar2:Object, aMessage:String, aContextObject:Object, aContextMethodArguments:Array):Void
	{
		if(aVar1 !== aVar2)
		{
			fail(aMessage + "(" + aVar1 + " !== " + aVar2 + ")", aContextObject, aContextMethodArguments);
		}
	}

	public static function failIfNotInstanceOf(aVar:Object, aType:Function, aMessage:String, aContextObject:Object, aContextMethodArguments:Array):Void
	{
		if(!(aVar instanceof aType))
		{
			fail(aMessage, aContextObject, aContextMethodArguments);
		}
	}
	
	public static function failIfReturns(aScope:Object, aMethod:Function, aArguments:Array, aReturnValue:Object, aMessage:String, aContextObject:Object, aContextMethodArguments:Array):Void
	{
		if(evaluateMethod(aScope, aMethod, aArguments) === aReturnValue)
		{
			fail(aMessage, aContextObject, aContextMethodArguments);
		}
	}

	public static function failIfReturnsTrue(aScope:Object, aMethod:Function, aArguments:Array, aMessage:String, aContextObject:Object, aContextMethodArguments:Array):Void
	{
		failIfReturns(aScope, aMethod, aArguments, true, aMessage, aContextObject, aContextMethodArguments);
	}

	public static function failIfReturnsFalse(aScope:Object, aMethod:Function, aArguments:Array, aMessage:String, aContextObject:Object, aContextMethodArguments:Array):Void
	{
		failIfReturns(aScope, aMethod, aArguments, false, aMessage, aContextObject, aContextMethodArguments);
	}
	
	public static function failIfReturnsNull(aScope:Object, aMethod:Function, aArguments:Array, aMessage:String, aContextObject:Object, aContextMethodArguments:Array):Void
	{
		var methodResult = evaluateMethod(aScope, aMethod, aArguments);
		if(methodResult === null || methodResult === undefined)
		{
			fail(aMessage, aContextObject, aContextMethodArguments);
		}
	}
	
	public static function failIfReturnsNotNull(aScope:Object, aMethod:Function, aArguments:Array, aMessage:String, aContextObject:Object, aContextMethodArguments:Array):Void
	{
		var methodResult = evaluateMethod(aScope, aMethod, aArguments);
		if(methodResult !== null && methodResult !== undefined)
		{
			fail(aMessage, aContextObject, aContextMethodArguments);
		}
	}
	
	public static function failIfContainsValue(aCollection:Object, aValue:Object, aMessage:String, aContextObject:Object, aContextMethodArguments:Array):Void
	{
		if(containsValue(aCollection, aValue))
		{
			fail(aMessage, aContextObject, aContextMethodArguments);
		}
	}

	public static function failIfContainsKey(aCollection:Object, aKey:Object, aMessage:String, aContextObject:Object, aContextMethodArguments:Array):Void
	{
		if(containsValue(aCollection, aKey))
		{
			fail(aMessage, aContextObject, aContextMethodArguments);
		}
	}
	
	public static function failIfNotContainsValue(aCollection:Object, aValue:Object, aMessage:String, aContextObject:Object, aContextMethodArguments:Array):Void
	{
		if(!containsValue(aCollection, aValue))
		{
			fail(aMessage, aContextObject, aContextMethodArguments);
		}
	}

	public static function failIfNotContainsKey(aCollection:Object, aKey:Object, aMessage:String, aContextObject:Object, aContextMethodArguments:Array):Void
	{
		if(!containsValue(aCollection, aKey))
		{
			fail(aMessage, aContextObject, aContextMethodArguments);
		}
	}
	
	//------------ WARNING
	
	public static function warning(aMessage:String, aContextObject:Object, aContextMethodArguments:Array) : Void
	{
		logAssertion(Level.WARNING, aMessage, aContextObject, aContextMethodArguments);
	}
	
	public static function warningIfTrue(aVar:Boolean, aMessage:String, aContextObject:Object, aContextMethodArguments:Array):Void
	{
		if(aVar)
		{
			warning(aMessage, aContextObject, aContextMethodArguments);
		}
	}
	
	public static function warningIfFalse(aVar:Boolean, aMessage:String, aContextObject:Object, aContextMethodArguments:Array):Void
	{
		if(!aVar)
		{
			warning(aMessage, aContextObject, aContextMethodArguments);
		}
	}
	
	public static function warningIfNotNull(aVar:Object, aMessage:String, aContextObject:Object, aContextMethodArguments:Array):Void
	{
		if(aVar != null && aVar != undefined)
		{
			warning(aMessage, aContextObject, aContextMethodArguments);
		}
	}
	
	public static function warningIfNull(aVar:Object, aMessage:String, aContextObject:Object, aContextMethodArguments:Array):Void
	{
		if(aVar == null || aVar == undefined)
		{
			warning(aMessage, aContextObject, aContextMethodArguments);
		}
	}
	
	public static function warningIfEmpty(aVar:Object, aMessage:String, aContextObject:Object, aContextMethodArguments:Array):Void
	{
		if(aVar == null || aVar == undefined || aVar == "")
		{
			warning(aMessage, aContextObject, aContextMethodArguments);
		}
	}
	
	public static function warningIfNotEqual(aVar1:Object, aVar2:Object, aMessage:String, aContextObject:Object, aContextMethodArguments:Array):Void
	{
		if(aVar1 != aVar2)
		{
			warning(aMessage + "(" + aVar1 + " != " + aVar2 + ")", aContextObject, aContextMethodArguments);
		}
	}
	
	public static function warningIfNotSame(aVar1:Object, aVar2:Object, aMessage:String, aContextObject:Object, aContextMethodArguments:Array):Void
	{
		if(aVar1 !== aVar2)
		{
			warning(aMessage + "(" + aVar1 + " !== " + aVar2 + ")", aContextObject, aContextMethodArguments);
		}
	}
	
	public static function warningIfNotInstanceOf(aVar:Object, aType:Function, aMessage:String, aContextObject:Object, aContextMethodArguments:Array):Void
	{
		if(!(aVar instanceof aType))
		{
			warning(aMessage, aContextObject, aContextMethodArguments);
		}
	}
	
	public static function warningIfReturns(aScope:Object, aMethod:Function, aArguments:Array, aReturnValue:Object, aMessage:String, aContextObject:Object, aContextMethodArguments:Array):Void
	{
		if(evaluateMethod(aScope, aMethod, aArguments) === aReturnValue)
		{
			warning(aMessage, aContextObject, aContextMethodArguments);
		}
	}

	public static function warningIfReturnsTrue(aScope:Object, aMethod:Function, aArguments:Array, aMessage:String, aContextObject:Object, aContextMethodArguments:Array):Void
	{
		warningIfReturns(aScope, aMethod, aArguments, true, aMessage, aContextObject, aContextMethodArguments);
	}

	public static function warningIfReturnsFalse(aScope:Object, aMethod:Function, aArguments:Array, aMessage:String, aContextObject:Object, aContextMethodArguments:Array):Void
	{
		warningIfReturns(aScope, aMethod, aArguments, false, aMessage, aContextObject, aContextMethodArguments);
	}
	
	public static function warningIfReturnsNull(aScope:Object, aMethod:Function, aArguments:Array, aMessage:String, aContextObject:Object, aContextMethodArguments:Array):Void
	{
		var methodResult = evaluateMethod(aScope, aMethod, aArguments);
		if(methodResult === null || methodResult === undefined)
		{
			warning(aMessage, aContextObject, aContextMethodArguments);
		}
	}
	
	public static function warningIfReturnsNotNull(aScope:Object, aMethod:Function, aArguments:Array, aMessage:String, aContextObject:Object, aContextMethodArguments:Array):Void
	{
		var methodResult = evaluateMethod(aScope, aMethod, aArguments);
		if(methodResult !== null && methodResult !== undefined)
		{
			warning(aMessage, aContextObject, aContextMethodArguments);
		}
	}
	
	public static function warningIfContainsValue(aCollection:Object, aValue:Object, aMessage:String, aContextObject:Object, aContextMethodArguments:Array):Void
	{
		if(containsValue(aCollection, aValue))
		{
			warning(aMessage, aContextObject, aContextMethodArguments);
		}
	}

	public static function warningIfContainsKey(aCollection:Object, aKey:Object, aMessage:String, aContextObject:Object, aContextMethodArguments:Array):Void
	{
		if(containsValue(aCollection, aKey))
		{
			warning(aMessage, aContextObject, aContextMethodArguments);
		}
	}
	
	public static function warningIfNotContainsValue(aCollection:Object, aValue:Object, aMessage:String, aContextObject:Object, aContextMethodArguments:Array):Void
	{
		if(!containsValue(aCollection, aValue))
		{
			warning(aMessage, aContextObject, aContextMethodArguments);
		}
	}

	public static function warningIfNotContainsKey(aCollection:Object, aKey:Object, aMessage:String, aContextObject:Object, aContextMethodArguments:Array):Void
	{
		if(!containsValue(aCollection, aKey))
		{
			warning(aMessage, aContextObject, aContextMethodArguments);
		}
	}
	
	//------------------------------------------------------------------
	
	public static function disableLogging()
	{
		Assertion.fail = null;
		Assertion.failIfEmpty = null;
		Assertion.failIfFalse = null;
		Assertion.failIfNotEqual = null;
		Assertion.failIfNotNull = null;
		Assertion.failIfNotSame = null;
		Assertion.failIfNull = null;
		Assertion.failIfTrue = null;
		Assertion.failIfNotInstanceOf = null;
		Assertion.failIfReturns = null;
		Assertion.warningIfReturnsFalse = null;
		Assertion.failIfReturnsTrue = null;
		Assertion.failIfReturnsNull = null;
		Assertion.failIfReturnsNotNull = null;
		Assertion.failIfContainsKey = null;
		Assertion.failIfContainsValue = null;
		Assertion.failIfNotContainsKey = null;
		Assertion.failIfNotContainsValue = null;

		Assertion.warning = null;
		Assertion.warningIfEmpty = null;
		Assertion.warningIfFalse = null;
		Assertion.warningIfNotEqual = null;
		Assertion.warningIfNotNull = null;
		Assertion.warningIfNotSame = null;
		Assertion.warningIfNull = null;
		Assertion.warningIfTrue = null;
		Assertion.failIfNotInstanceOf = null;
		Assertion.failIfReturns = null;
		Assertion.warningIfReturnsFalse = null;
		Assertion.warningIfReturnsTrue = null;
		Assertion.warningIfReturnsNull = null;
		Assertion.warningIfReturnsNotNull = null;
		Assertion.warningIfContainsKey = null;
		Assertion.warningIfContainsValue = null;
		Assertion.warningIfNotContainsKey = null;
		Assertion.warningIfNotContainsValue = null;
	}
}
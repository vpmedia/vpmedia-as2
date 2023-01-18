/*
Copyright (c) 2005 John Grden | BLITZ

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
documentation files (the "Software"), to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and
to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions
of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO
THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/
import com.blitzagency.xray.Xray;
/**
 * Commander is a script interpreter that allows you to execute actionscript commands at runtime.  It's responsible for nearly
 * all other functionality in controling objects from the interface as well as allowing the user to execute commands
 * from the command panel.
 *
 * @author John Grden :: john@blitzagency.com
 */
class com.blitzagency.xray.Commander
{
	/**
     * @summary exec receives a string of ";" separated commands, splits them up and passes them on to the script method
	 * to be parsed and executed
	 *
	 * @param str:String semi-colon separated list of commands to execute
	 *
	 * @return Object
	 */
	public static function exec(str:String):Object
	{
		/*
		exec's job is to split out the commands into an array, then split out each command in a hash manner for reconstructing in the script method
		*/
		// split into commands
		var cmds = str.split(";");
		//_global.tt("exec", cmds);

		for(var h:Number=0;h<cmds.length;h++)
		{
			// take the value and retain it.  Basically, if there are "."'s, replace with "(dot)"
			cmds[h] = retainValue(cmds[h]);

			// now we can safely split on the "."'s
			cmds[h] = cmds[h].split(".");

			// put the value back together
			cmds[h][cmds[h].length-1] = restoreValue(cmds[h][cmds[h].length-1]);

			var hash:Object = cmds[h];
			var len = hash.length;

			for(var i:Number=0;i<len;i++)
			{
				if(hash[i].indexOf("[") > -1)
				{
					var d = hash[i].split("[");

					hash[i] = d[0];
					for(var j:Number=1;j<d.length;j++)
					{
						var val = replace(d[j], "\"", "");
						val = replace(val, "]", "");
						hash.splice(i+1, 0, val);
					}
				}
			}
		}

		var r = script(cmds);
		return r;
	}
	/**
     * @summary recieves an array of commands that it has to send off to getArguments to resolve the true
	 * method/value or propertychange/value.  Once it has a returned object, it executes the command or propertychange
	 *
	 * @param cmds:Array array of commands to execute
	 *
	 * @return Object it can actually return a variety of types of objects
	 */
	private static function script(cmds:Array):Object
	{
		// find command, separate it out
		for(var c:Number=0;c<cmds.length;c++)
		{
			// cmd is always that last index of the array
			// ie: tt("good job", _level0, "ding", parseInt("34"))
			var cmd = cmds[c][cmds[c].length-1];
			cmd = getArguments(cmd);

			var d:Number = cmds[c].length > 1 ? 1 : 0;
			var r;

			if(d>0)
			{
				// build actual object to run the cmd against
				var exec:Object = eval(cmds[c][0]);

				// -1 becuase we don't want to include the cmd
				for(d;d<cmds[c].length-1;d++)
				{
					exec = exec[cmds[c][d]];
				}

				if(cmd.method)
				{
					// method call
					r = exec[cmd.method].apply(exec, cmd.args);
					if(r != undefined) return r;
				}else
				{
					// property change
					exec[cmd.prop] = cmd.val;
				}
			}else
			{
				// at this point, it's a single method call, so, try it against _global
				//r = _global[cmd.method].apply(_global, cmd.args);
				r = _global[cmd.method](cmd.args);
				if(r != undefined) return r;
			}
		}
	}
	/**
     * @summary replaces any "."'s with "(dot)" before exec does it's split at "."'s.  It has too look for
	 * parens and equality operators to figure out where the retainable values are.
	 *
	 * @param str:String command to execute IE: _level0.mc._x = 30.5
	 *
	 * @return Object
	 */
	private static function retainValue(str:String):String
	{
		var e = str.indexOf("=");
		var p = str.indexOf("(");

		if(e > -1)
		{
			var a:Array = str.split("=");
			a[1] = replace(a[1], ".", "(dot)");
			return a.join("=");
		}

		if(p > -1)
		{
			var lp:Number = str.indexOf(")", p);
			var st:String = str.slice(0, p);
			var ed:String = str.slice(lp+2);
			var ns:String = replace(str.substr(p, lp), ".", "(dot)");
			return st + ns + ed;
		}

		return str;
	}
	/**
     * @summary restores the value back with the original "."'s
	 *
	 * @param str:String command to be restored
	 *
	 * @return String
	 */
	private static function restoreValue(str):String
	{
		return replace(str, "(dot)", ".");
	}
	/**
     * @summary replaces items in strings
	 *
	 * @param str:String string to be searched
	 * @param search:String what is being replaced
	 * @param use:String what to use in it's place
	 *
	 * @return String
	 */
	private static function replace(str:String, search:String, use:String):String
	{
		return str.split(search).join(use);
	}
	/**
     * @summary getArguments locates the arguments of method calls or values of property assignments.
	 *
	 * @param str:String command IE: _level0.mc._x = 30.5;
	 *
	 * @return Object
	 */
	private static function getArguments(str:String):Object
	{
		var fp:Number = str.indexOf("(");
		var lp:Number = str.lastIndexOf(")");
		var method:String;
		var args:Array;
		var prop:String;
		var val:Object;

		// find out if this is a property change or method call
		if(fp > -1)
		{
			// this is a method call
			method = str.substr(0, fp);
			args = str.substring(fp+1, lp).split(",");

			// before we pass back, we have to check for strings and literals
			for(var i:Number=0;i<args.length;i++)
			{

				var q:Number = args[i].indexOf("\"");  // llok for quotes
				var p:Number = args[i].indexOf("("); // look for parens
				if(p > -1)
				{
					// we have another method to execute
					args[i] = String(replace(args[i], " ", ""));
					// send off to be executed and return the value to continue on
					args[i] = exec(args[i]);
				}else if(q > -1 && p == -1)
				{
					args[i] = String(replace(args[i], "\"", ""));
					args[i] = String(replace(args[i], "'", ""));
				}else
				{
					if(!isNaN(parseInt(args[i])))
					{
						args[i]= parseInt(args[i]);
					}
				}
			}
		}else
		{
			// this is a property change
			prop = replace(str.split("=")[0]," ", "");
			var valString:String = replace(str.split("=")[1], " ", "");
			var valBoolean:Boolean;
			var valNumber:Number;

			switch(valString)
			{
				case "true":
					valBoolean = true;
					val = valBoolean;
				break;
				case "false":
					valBoolean = false;
					val = valBoolean;
				break;
				default:
					if(!isNaN(parseInt(valString)))
					{
						// it's Number
						valNumber = parseInt(valString);
						val = valNumber;
					}else
					{
						// it's a string
						valString = String(replace(valString, "\"", ""));
						valString = String(replace(valString, "'", ""));
						val = valString;
					}
			}
		}

		var obj:Object = new Object();
		// args goes with method, val goes with property
		obj.method = method;
		obj.args = args;
		obj.prop = prop;
		obj.val = val;
		return obj;
	}
}
/*
	CASA Framework for ActionScript 2.0
	Copyright (C) 2007  CASA Framework
	http://casaframework.org
	
	This library is free software; you can redistribute it and/or
	modify it under the terms of the GNU Lesser General Public
	License as published by the Free Software Foundation; either
	version 2.1 of the License, or (at your option) any later version.
	
	This library is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
	Lesser General Public License for more details.
	
	You should have received a copy of the GNU Lesser General Public
	License along with this library; if not, write to the Free Software
	Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
*/

import org.casaframework.load.base.DataLoad;

/**
	Creates an easy way to load or send and load variables.
	
	@author Aaron Clinger
	@version 03/18/07
	@since Flash Player 7
	@example
		To load data:
		<code>
			function onDataLoad(sender:VarsLoad):Void {
				trace(this.myVarsLoad.getValue("name"));
			}
			
			var myVarsLoad:VarsLoad = new VarsLoad("http://example.com/getData.php");
			this.myVarsLoad.addEventObserver(this, VarsLoad.EVENT_LOAD_COMPLETE, "onDataLoad");
			this.myVarsLoad.start();
		</code>
		
		To send and load data:
		<code>
			function onDataLoad(sender:VarsLoad):Void {
				trace(this.myVarsLoad.getValue("city"));
			}
			
			var myVarsLoad:VarsLoad = new VarsLoad("http://example.com/getData.php");
			this.myVarsLoad.addEventObserver(this, VarsLoad.EVENT_LOAD_COMPLETE, "onDataLoad");
			this.myVarsLoad.setValue("zip", "94109");
			this.myVarsLoad.setValue("state", "CA");
			this.myVarsLoad.start();
		</code>
*/

class org.casaframework.load.data.VarsLoad extends DataLoad {
	private var $target:LoadVars;
	private var $receive:LoadVars;
	
	
	/**
		Defines file and location of load triggered by {@link Load#start start}.
		
		@param path: The absolute or relative URL of the variables to be loaded.
		@param method: <strong>[optional]</strong> Defines the method of the HTTP protocol, either <code>"GET"</code> of <code>"POST"</code>; defaults to <code>"POST"</code>.
	*/
	public function VarsLoad(path:String, method:String) {
		super(path, method);
		
		this.$target  = new LoadVars();
		this.$receive = new LoadVars();
		
		this.$setClassDescription('org.casaframework.load.data.VarsLoad');
	}
	
	/**
		Sets a name-value pair to send to the server side script.
		
		@param name: The name of the variable.
		@param value: The value of the variable.
	*/
	public function setValue(name:String, value:String):Void {
		this.$target[name]  = value;
		this.$passingValues = true;
	}
	
	/**
		Gets the value of a name-value pair set either by {@link #setValue} or defined by loaded variables.
		
		@param name: The name of the variable.
		@return The value of the variable.
	*/
	public function getValue(name:String):String {
		return (this.$receive[name] != undefined) ? this.$receive[name] : this.$target[name];
	}
}
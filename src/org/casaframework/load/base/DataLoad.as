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

import org.casaframework.load.base.BytesLoad;

/**
	Data load class for items that have the methods <code>load</code> and <code>sendAndLoad</code>. Class needs to be extended further to function properly.
	
	@author Aaron Clinger
	@version 01/26/07
	@since Flash Player 7
*/

class org.casaframework.load.base.DataLoad extends BytesLoad {
	private var $method:String;
	private var $target:Object;
	private var $receive:Object;
	private var $isUnloading:Boolean;
	private var $passingValues:Boolean;
	
	
	/**
		@param path: The absolute or relative URL of the variables to be loaded.
		@param method: <strong>[optional]</strong> Defines the method of the HTTP protocol, either <code>"GET"</code> of <code>"POST"</code>; defaults to <code>"POST"</code>.
	*/
	private function DataLoad(path:String, method:String) {
		super(null, path);
		
		this.$method = method;
		
		this.$setClassDescription('org.casaframework.load.base.DataLoad');
	}
	
	/**
		Adds or changes HTTP request headers.
		
		@param header: A string that represents an HTTP request header name.
		@param headerValue: A string that represents the value associated with header.
	*/
	public function addRequestHeader(header:Object, headerValue:String):Void {
		this.$target.addRequestHeader(header, headerValue);
		this.$passingValues = true;
	}
	
	public function getBytesLoaded():Number {
		return (this.$receive.getBytesLoaded() != undefined) ? this.$receive.getBytesLoaded() : super.getBytesLoaded();
	}
	
	public function getBytesTotal():Number {
		return (this.$receive.getBytesTotal() != undefined) ? this.$receive.getBytesTotal() : super.getBytesTotal();
	}
	
	public function hasLoaded():Boolean {
		return (this.$receive.loaded != undefined) ? this.$receive.loaded : (this.$target.loaded != undefined) ? this.$target.loaded : false;
	}
	
	public function destroy():Void {
		delete this.$target;
		delete this.$receive;
		delete this.$isUnloading;
		delete this.$passingValues;
		
		super.destroy();
	}
	
	private function $startLoad():Void {
		super.$startLoad();
		
		if (this.$passingValues) {
			this.$remapOnLoadHandler(this.$receive);
			this.$target.sendAndLoad(this.getFilePath(), this.$receive, this.$method);
		} else {
			this.$remapOnLoadHandler();
			this.$target.load(this.getFilePath());
		}
	}
	
	private function $stopLoad():Void {
		super.$stopLoad();
		
		this.$isUnloading = true;
		if (this.$passingValues)
			this.$target.sendAndLoad('', this.$receive, this.$method); // Cancels the current load.
		else
			this.$target.load(''); // Cancels the current load.
	}
	
	private function $onLoad(success:Boolean):Void {
		if (!this.$isUnloading)
			super.$onLoad(success);
		else
			delete this.$isUnloading;
	}
	
	private function $checkForLoadComplete():Void {}
}
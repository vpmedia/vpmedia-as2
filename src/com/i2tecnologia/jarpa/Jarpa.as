/**
	Jarpa - Jarpa Framework
	Copyright (C) 2008 i2tecnologia
*/

import mx.utils.Delegate;
import mx.events.EventDispatcher;

/**
  Jarpa
  @version 1.05
  @author: Felipe Andrade
*/
class com.i2tecnologia.jarpa.Jarpa extends EventDispatcher {	
	private var host_str:String;
	private var port_num:Number;
	private var jarpa_xmls:XMLSocket;
	private var isConnected_bool:Boolean = false;
	
	/**
	  	Jarpa(host_str:String, port_num:Number)
	  	@host_str: server host
		@port_num: port number ( > 1024 )
		
		Constructor
	*/
	public function Jarpa(host_str:String, port_num:Number) {
		this.host_str = host_str;
		this.port_num = port_num;
		
		this.jarpa_xmls = new XMLSocket();
	}
	
	/**
	  	connect():Void
		
		Connect to local server
	*/
	public function connect():Void {		
		this.jarpa_xmls.connect(this.host_str, this.port_num);
		this.jarpa_xmls.onConnect = Delegate.create(this, onConnect);
		this.jarpa_xmls.onClose = Delegate.create(this, onClose);
	}
	
	/**
	  	onConnect(success_bool:Boolean)
	  	@success_bool: connected or not
		
		Connection handler
	*/
	public function onConnect(success_bool:Boolean):Void {
		setStatus(true);
		dispatchEvent({type: "onJarpaConnect", 
					    status:success_bool});
		stateReading();
	}
	
	/**
	  	write(data_str:String)
	  	@data_str: write a message to socket
		
		Write a message to socket
	*/
	public function write(data_str:String):Void {
		this.jarpa_xmls.send(data_str);
	}
	
	/**
	  	onReadData(data_str:Boolean)
	  	@data_str: receive a message from socket
		
		Asynchronous handler
	*/
	public function onReadData(data_str:String):Void {
		dispatchEvent({type: "onReadData", 
					   data:data_str});
	}
	
	/**
	  	onClose():Void
		
	  	Invoked when the server is closed
	*/
	public function onClose():Void {
		setStatus(false);
		dispatchEvent({type: "onJarpaClose"})
	}
	
	/**
	  	stateReading():Void
		
		Start handling messages	  
	*/
	public function stateReading():Void {
		this.jarpa_xmls.onData = Delegate.create(this, onReadData);		
	}
	
	/**
	  	setStatus(status_bool:Boolean):Void
		@status: boolean value that indicates the status of application
		
		Set status of application	  
	*/
	public function setStatus(status_bool:Boolean):Void {
		this.isConnected_bool = status_bool;
	}
	
	/**
	  	getStatus():Boolean		
		
		Get status of application	  
	*/
	public function getStatus():Boolean {
		return this.isConnected_bool;
	}	
}
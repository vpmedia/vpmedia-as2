﻿/**
/**
	private static var _instance:Out;
	/**
	/**
	/**
	/**
	// Core controllers
	/**
	/**
	/**
	// Level Handlers
	/**
	/**
	// Object Filters
	/**
	/**
	private function filter(origin:Object):Void {
	private function unfilter(origin:Object):Void {
	public function isFiltered(origin:Object):Boolean {
	// currently unused - as3 has getNameSpace - for now maybe better to keep filtering on object/string rather than class?
	// Output methods
	// __resolve catches all wrapper & invented levels and processes them thru the proxy to _output: cool!
	private function __proxy(name:String):Void {
	/**
	/**
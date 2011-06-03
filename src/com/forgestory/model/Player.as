package com.forgestory.model
{
	import flash.net.registerClassAlias;

	[RemoteClass(alias="model.Player")]
	public class Player{
		public var uid:String;
		public var username:String;
		public var coins:int;
		public var head:String;
		public var body:String;
		public var wins:int;
		public var loses:int;
		public var isNew:Boolean;
		public var armor:String;
		public var weapon:String;
		
		public function Player(){
			registerClassAlias("Player", Player);
		}
		
		public function toString():String{
			return username;
		}
	}
}
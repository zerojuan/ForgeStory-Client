package com.forgestory.rpg
{
	public class PlayerDataObject{
		public var uid:String;
		public var username:String;
		public var loses:int;
		public var wins:int;
		public var isNew:Boolean;
		public var coins:int;
		public var body:String;
		public var head:String;
		public var armor:String;
		public var weapon:String;
		
		
		public function PlayerDataObject(){
		}
		
		public function populate(obj:Object):void{
			uid = obj.uid;
			username = obj.username;
			loses = obj.loses;
			wins = obj.wins;
			isNew = !(obj.isNew == "0");
			coins = obj.coins;
			body = obj.body;
			head = obj.head;
			armor = obj.armor;
			weapon = obj.weapon;
		}
		
		public function toString():String{
			return username;
		}
	}
}
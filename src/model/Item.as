package model
{
	import flash.net.registerClassAlias;

	[RemoteClass(alias="Item")]
	public class Item{
		public static const BODY:int = 1;
		public static const HEAD:int = 0;
		public static const MONSTER:int = 2;
		public static const WEAPON:int = 3;
		public static const ARMOR:int = 4;
		
		public var id:String;
		public var name:String;
		public var forgerId:String;
		public var price:int;
		public var type:int;
		public var taken:int;
		public var description:String;
		
		public function Item(){
			registerClassAlias("Item", Item); 
		}
		
		public function toString():String{
			return name;
		}
	}
}
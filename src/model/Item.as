package model
{
	import flash.net.registerClassAlias;

	[RemoteClass(alias="Item")]
	public class Item{
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
	}
}
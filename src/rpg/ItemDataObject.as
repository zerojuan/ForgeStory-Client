package rpg
{
	public class ItemDataObject{
		public static const BODY:int = 1;
		public static const HEAD:int = 0;
		public static const MONSTER:int = 2;
		public static const WEAPON:int = 3;
		public static const ARMOR:int = 4;
		
		public var name:String;
		public var forger_id:String;
		public var price:int;
		public var type:int;
		public var taken:int;
		public var description:String;
		
		public var id:String;
		
		public function populate(obj:Object):void{
			id = obj.id;
			name = obj.name;
			forger_id = obj.forger_id;
			price = obj.price;
			type = obj.type;
			taken = obj.taken;
			description = obj.description;
		}
		
		public function toString():String{
			return name;
		}
	}
}
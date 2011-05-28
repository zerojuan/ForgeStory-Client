package rpg
{
	import com.facebook.graph.Facebook;
	
	import model.Item;

	public class FacebookShower{
		private static var _instance:FacebookShower;
		private static var _allowInstantation:Boolean;
		
		public static function get instance():FacebookShower{
			if(!_instance){
				_allowInstantation = true;
				_instance = new FacebookShower();
				_allowInstantation = false;
			}
			return _instance;
		}
		
		public function FacebookShower(){
			if(!_allowInstantation){
				throw new Error("PlayerData is a singleton!");
			}
		}
		
		public function showUI(item:Item):void{
			var obj:Object = 
				{
					method: 'stream.publish',
					name: "It's dangerous to go alone, here take this " + item.name,
					link: "http://apps.facebook.com/forgestory/launch.php?itemId="+item.id, // canvas page ng game.					
					picture: "http://codeanginamo.com/testbed/items/"+item.id+".png",
					description: item.description
				}
			Facebook.ui("feed",obj,null);	
		}
		
		public function showUISimple(itemId:String, desc:String, itemName:String):void{
			var obj:Object = 
				{
					method: 'stream.publish',
					name: "It's dangerous to go alone, here take this " + itemName,
						link: "http://apps.facebook.com/forgestory/launch.php?itemId="+itemId, // canvas page ng game.					
						picture: "http://codeanginamo.com/testbed/items/"+itemId+".png",
						description: desc
				}
			Facebook.ui("feed",obj,null);	
		}
	}
}
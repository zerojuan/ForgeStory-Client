package rpg
{
	import com.facebook.graph.data.FacebookSession;

	public class PlayerData{
		private static var _instance:PlayerData;
		private static var _allowInstantation:Boolean;
		
		private var _avatar:Avatar;
		
		public var linkedUID:String;
		
		public var session:FacebookSession;
		
		public var isNew:Boolean = true;
		public var coins:int = 90000;
		public var loses:int = 0;
		public var wins:int = 0;
		public var username:String = "no name";
		public var uid:String = "752846809";
		public var head:String = "";
		public var body:String = "";
		public var armor:String = "";
		public var weapon:String = "";
		
		public static function get instance():PlayerData{
			if(!_instance){
				_allowInstantation = true;
				_instance = new PlayerData();
				_allowInstantation = false;
			}
			return _instance;
		}
		
		public function PlayerData(){
			if(!_allowInstantation){
				throw new Error("PlayerData is a singleton!");
			}
			
			_avatar = new Avatar();
		}
		
		public function get avatar():Avatar{
			return _avatar;
		}
		
		public function set avatar(val:Avatar):void{
			_avatar = val;
		}
	}
}
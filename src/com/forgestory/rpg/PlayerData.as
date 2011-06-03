package com.forgestory.rpg
{
	import com.facebook.graph.data.FacebookSession;
	
	import com.forgestory.model.Player;

	public class PlayerData{
		private static var _instance:PlayerData;
		private static var _allowInstantation:Boolean;
		
		private var _avatar:Avatar;
		
		public var linkedUID:String;
		
		public var session:FacebookSession;
		
		public var player:Player;
		
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
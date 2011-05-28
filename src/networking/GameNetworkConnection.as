package networking
{
	import com.pblabs.engine.debug.Logger;
	
	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	import flash.net.Responder;
	import flash.utils.ByteArray;
	
	import model.Item;
	import model.Player;

	public class GameNetworkConnection{
		private static var _instance:GameNetworkConnection;
		private static var _allowInstantiation:Boolean;
		
		public var gateway:String = "http://bytehalacollective.org/flashservices/gateway.php";
		
		private var connection:NetConnection;
		
		public static function get instance():GameNetworkConnection{
			if(!_instance){
				_allowInstantiation = true;
				_instance = new GameNetworkConnection();
				_allowInstantiation = false;
			}
			return _instance;
		}
		
		public function GameNetworkConnection(){
			if(!_allowInstantiation){
				throw new Error("Cannot have multiple instances of GameNetworkConnection");
			}
			
			connection = new NetConnection();
			connection.addEventListener(NetStatusEvent.NET_STATUS, onNetStatusEvent);
			
			connection.connect(gateway);
		}
		
		public function buyItem(handler:Function, item:Item, player:Player, isFree:Boolean):void{
			var responder:Responder = new Responder(handler);
			connection.call("ShopActionService.buyItem", responder, item, player, isFree);
		}
		
		public function savePlayer(handler:Function, player:Player):void{
			var responder:Responder = new Responder(handler);
			connection.call("PlayerActionService.update", responder, player);
		}
		
		public function getPlayer(handler:Function, player:Player):void{
			var responder:Responder = new Responder(handler);
			connection.call("PlayerActionService.get", responder, player);
		}
		
		public function getPlayerBuddies(handler:Function, player:Player):void{
			Logger.print(this, "Getting buddies");
			var responder:Responder = new Responder(handler);
			connection.call("PlayerActionService.getPlayerBuddies", responder, player);
		}
		
		public function createItem(handler:Function, item:Item, imageData:ByteArray):void{
			var responder:Responder = new Responder(handler);
			connection.call("ForgingActionService.createItem", responder, item, imageData, false);
		}
		
		public function getItem(handler:Function, item:Item):void{
			var responder:Responder = new Responder(handler);
			connection.call("ShopActionService.getItem", responder, item);
		}
		
		public function getInventory(handler:Function, uid:String, item:Item):void{
			Logger.print(this, "Getting inventory");
			var responder:Responder = new Responder(handler);
			connection.call("ShopActionService.getShopInventory", responder, uid, item);
		}
		
		public function getMyInventory(handler:Function, player:Player, item:Item):void{
			Logger.print(this, "Getting my inventory");
			var responder:Responder = new Responder(handler);
			connection.call("PlayerActionService.getMyInventory", responder, player, item);
		}
								   
		private function onNetStatusEvent(evt:NetStatusEvent):void{
			Logger.print(this, "NetStatus: " + evt.info.code);
		}
	}
}
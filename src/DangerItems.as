package
{
	import com.adobe.serialization.json.JSON;
	import com.facebook.graph.Facebook;
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.screens.PlaceholderScreen;
	import com.pblabs.screens.ScreenManager;
	
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import rpg.ItemDataObject;
	import rpg.PlayerData;
	
	[SWF(width="760", height="520", backgroundColor="0x000000")]
	public class DangerItems extends Sprite
	{
		public static const WELCOME:String = "Welcome";
		public static const ADVENTURE:String = "Adventure";
		public static const FORGE:String = "Forge";
		public static const SHOP:String = "Shop";
		public static const EDIT_AVATAR:String = "EditAvatar";
		
		public static var monster:ItemDataObject;
		
		public function DangerItems(){
			if(stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(evt:Event = null):void{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			Facebook.init("201688753206706");
			
			PlayerData.instance.session = Facebook.getSession();
			
			
			
			PlayerData.instance.linkedUID = (getFlashVars().linkUID) || "NONE";
			
			PBE.startup(this);
			
			Logger.print(this, "LINKED UID? " + PlayerData.instance.linkedUID + ":" + getFlashVars().isNew);
			
			
			loadPlayerData();
		}
		
		private function loadPlayerData():void{
			var urlVariables:URLVariables = new URLVariables();
			urlVariables.uid = PlayerData.instance.session.uid;
			
			var urlRequest:URLRequest = new URLRequest("loadPlayerData.php");
			urlRequest.method = URLRequestMethod.POST;
			urlRequest.data = urlVariables;
			
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			urlLoader.addEventListener(Event.COMPLETE, onPlayerDataLoaded);
			urlLoader.load(urlRequest);
		}
		
		private function onPlayerDataLoaded(evt:Event):void{
			var obj:Object = JSON.decode(evt.target.data);
			
			with(PlayerData.instance){
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
			
			ScreenManager.instance.registerScreen(FORGE, new ForgeScreen());
			ScreenManager.instance.registerScreen(WELCOME, new WelcomeScreen());
			ScreenManager.instance.registerScreen(ADVENTURE, new AdventureScreen());
			ScreenManager.instance.registerScreen(SHOP, new ShopScreen());
			ScreenManager.instance.registerScreen(EDIT_AVATAR, new EditAvatarScreen());
			
			ScreenManager.instance.goto(WELCOME);
		}
		
		private function getFlashVars():Object {
			return Object( LoaderInfo( this.loaderInfo ).parameters );
		}
	}
}
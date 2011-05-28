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
	
	import model.Player;
	
	import networking.GameNetworkConnection;
	
	import org.flexunit.runner.Result;
	
	import rpg.ItemDataObject;
	import rpg.PlayerData;
	
	import tests.GameConnectionTester;
	
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
			
			var player:Player = new Player();
			player.uid = PlayerData.instance.session.uid;
			GameNetworkConnection.instance.getPlayer(onGottenPlayer, player);
		}
		
		private function onGottenPlayer(result:Object):void{
			if(result is Player){
				var res:Player = result as Player;
				Logger.print(this, "Success! " + res.uid + " Second: " + res.username);
				
				PlayerData.instance.player = res;
				
				ScreenManager.instance.registerScreen(FORGE, new ForgeScreen());
				ScreenManager.instance.registerScreen(WELCOME, new WelcomeScreen());
				ScreenManager.instance.registerScreen(ADVENTURE, new AdventureScreen());
				ScreenManager.instance.registerScreen(SHOP, new ShopScreen());
				ScreenManager.instance.registerScreen(EDIT_AVATAR, new EditAvatarScreen());
				
				ScreenManager.instance.goto(WELCOME);
				
			}else{
				Logger.print(this, "Problemo");
			}
		}
		
		private function getFlashVars():Object {
			return Object( LoaderInfo( this.loaderInfo ).parameters );
		}
	}
}
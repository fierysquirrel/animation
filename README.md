# Animation for OpenFL

A simple group of classes to display 2D animation from Sprite Sheets in OpenFL.

# Functionality:
- Basic sprite animation
- Play, Pause, Stop, etc

# Example:

```haxe
var inited:Bool;

var tilesheet : SparrowTileset;

var animation : Animation;

var tilemap : Tilemap;
  
function init() 
{
  if (inited) return;
    inited = true;

  var xml : String;
  var spritesheet : BitmapData;
  var frames : Array<Tile>;
  var ani : Tile;
  var fps : Int;

  fps = 4; //A test FPS, controls the speed of the animation
  spritesheet = Assets.getBitmapData("pathToSpriteSheet.png");
  xml = Assets.getText("pathToSpriteSheetXML.xml");

  tilesheet = new SparrowTileset(spritesheet, xml);
  frames = [new Tile(tilesheet.getImageID("frame1")), 
        new Tile(tilesheet.getImageID("frame2")), 
        new Tile(tilesheet.getImageID("frame3"))];

  tilemap = new Tilemap(stage.stageWidth, stage.stageHeight,tilesheet);
  animation = new Animation(t, frames,fps);

  animation.SetPosition(0, 0); //This is optional, just to show you can modify the position of the sprite
  animation.Play(); //Plays the animation
  animation.On(); //This makes it appear on the screen, could be made invisible too
  
  addChild(tilemap);

  //Main loop
  Lib.current.stage.addEventListener(Event.ENTER_FRAME, MainLoop);
}

function MainLoop(event : Event)
{
  var time : Float = Lib.getTimer();
  var deltaTime : Float = time - lastTime;
  lastTime = time;

  animation.Update(deltaTime);
}
 
```


This is still in development, I have to fix bugs and keep improving it but the basic functionality is there.

Feel free to contact me: henry@fierysquirrel.com
http://fierysquirrel.com/

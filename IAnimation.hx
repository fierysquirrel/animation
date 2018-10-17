package;

/**
 * Interface to represent graphic animation: Spritesheet, models, 2D, 3D, etc.
 * 
 * @author Fiery Squirrel
 * @link http://www.fierysquirrel.com
 * @version 1.0
 */

interface IAnimation 
{
	/*
	 * Play the animation.
	 */
	function Play() : Void;
	
	/*
	 * Pause the animation.
	 */
	function Pause() : Void;
	
	/*
	 * Resume the animation.
	 */
	function Resume() : Void;
    
    /*
	 * Stop the animation.
	 */
	function Stop() : Void;
	
	/*
	 * Updates the logic to reproduce the animation.
	 * 
	 * @param gameTime Current game time
	 */
	function Update(gameTime:Float) : Void;
}
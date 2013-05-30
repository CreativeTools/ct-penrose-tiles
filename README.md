Penrose Tiling for 3ds Max
================

> MAXScript for generating (P2) Penrose Tilings

#[Download MAXScript File](http://bit.ly/18xMNEt)
#[Download Scene File](http://bit.ly/149I58S)

![L-System screenshot](https://raw.github.com/CreativeTools/ct-penrose-tiles/master/screenshot.png)
###[Video](https://vimeo.com/66795871)

##Usage
You will need to download both the script and the scene file. Open the scene file in 3ds Max, click *MAXScript* -> *Run Script*.
Navigate to the folder where you saved the .ms file, select it and press *Open*  

Pressing *Generate* will deflate the selected kites and darts into penrose tiles.

The script uses *Half Tiles* to be able to match the original shape perfectly. If you want to change the look of the tiles they are found
on a separate layer called *HalfTiles*.

##Settings
* Side Length
  * The length of the sides in the dart and kite shapes. There is no need to change this unless you create your own tiles.
* Iterations
  * The number of recursive deflation passes to run. Each pass subdivides the existing into smaller ones.
* Generate
  * Deflates the selected shapes into penrose tiles
* Clear Tiles
  * Removes all generated tiles

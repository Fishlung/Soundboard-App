A simple soundboard app I made in Godot for use in discord VCs, but should work for almost any app that takes audio inputs. Was Godot the best tool to use for making this? Probably not, but at the moment this is all I know, I don't feel like learning anything else, and every problem looks like a nail. 

Requires a Virtual Audio Cable application to work.

# Controls
Left click on a button to play sounds. Left click again to stop. 

Right click the button to edit the sound. Right click again to exit the sound editor menu.

# How to use
First you'll need to connect your Virtual Audio Cables. I'm using [VB-CABLE][vb-cable-url], which supports Windows and Mac. Download your VAC of choice, then run the installer.

Once you have your VAC set up, connect them to the software. Click the Options menu in the top right to open the settings. You'll see two dropdown boxes, one labeled "Speaker Output" and the other labeled "VAC Output." Set your Speaker Output to whatever output device you'd like to hear your own sounds from, and set your VAC Output to your VAC Input. It should look something like this.

<img width="486" height="169" alt="image" src="https://github.com/user-attachments/assets/d86fda56-5775-46ff-ac34-aba9d55d3d34" />

Please note that currently, the application cannot split audio to multiple devices, so while the soundboard is actively outputting sounds to the VAC, you will not be able to hear anything in your device's speakers. Unfortunately, this seems to be just a limitation of Godot's Audio Server class. I'll eventually try to figure out a workaround, but for now, if you'd like your sounds to both play to your speakers and output to the microphone, you'll need to enable Listening in the device's properties. A quick tutorial on how to do this can be found [here][enable-listening-url].

The Soundboard is now ready to add sounds! Click Import Sound in the top left to open your file system. Simply select the file you'd like to add, and customize its name and volume by right clicking it.

[vb-cable-url]: https://vb-audio.com/Cable/
[enable-listening-url]: https://www.cyberacoustics.com/cyber-acoustics-blog/how-to-hear-your-headset-mic-windows11

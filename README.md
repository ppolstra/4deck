The 4deck will install udev rules which will turn a USB hub
into a magic hub.  Every block device connected to the magic hub
will be automatically mounted under the /media directory as read only.
While this was designed to work with "The Deck" it will most likely
work with most modern Linux distros.  This software is provided as is
without warranty of any kind, express or implied.  Use at your own
risk.  The author is not responsible for anything that happens as 
a result of using this software.

Initial version created August 2012 by Dr. Phil Polstra, Sr.
Version 1.1 created March 2015
     new versions adds support for a second PID which is required
     when using USB 3.0 hubs as they actually present as two hubs
 

 Author may be contacted at @ppolstra or DrPhil@polstra.org
 Author's site that may have updates http://philpolstra.com


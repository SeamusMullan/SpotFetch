# Copyright
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

import ctypes
import objc
from PySide6.QtCore import QObject

# Load required Objective-C frameworks
appkit = ctypes.cdll.LoadLibrary('/System/Library/Frameworks/AppKit.framework/AppKit')
foundation = ctypes.cdll.LoadLibrary('/System/Library/Frameworks/Foundation.framework/Foundation')

# Import Foundation and AppKit directly for proper type handling
from Foundation import NSObject, NSNotificationCenter
from AppKit import NSWindowDidExitFullScreenNotification, NSWindow

class ExitFullScreenObserver(NSObject):
    """Observer that gets notified when the window exits fullscreen mode"""
    
    def initWithWindow_andCallback_(self, nswindow, callback):
        self = objc.super(ExitFullScreenObserver, self).init()
        if self is None: return None
        
        self.window = nswindow
        self.callback = callback
        
        NSNotificationCenter.defaultCenter().addObserver_selector_name_object_(
            self,
            "handleExitFullScreen:",
            NSWindowDidExitFullScreenNotification,
            self.window
        )
        return self
        
    def handleExitFullScreen_(self, notification):
        self.callback(self.window)
        
    def dealloc(self):
        NSNotificationCenter.defaultCenter().removeObserver_(self)
        super(ExitFullScreenObserver, self).dealloc()

class MacOSEventFilter(QObject):
    def __init__(self, parent=None):
        super().__init__(parent)
        self._window = None
        self._ns_window = None
        self._exit_observer = None
        
    def set_window(self, window):
        """Set the window to be styled"""
        self._window = window
        # Get native window handle
        if self._window:
            window_id = int(self._window.winId())
            # Configure the window for custom titlebar appearance
            self._configure_titleless_window(window_id)
    
    def _configure_titleless_window(self, window_id):
        """Configure the window to use a custom titlebar on macOS"""
        try:
            # Get the NSView from the window ID using correct ctypes pointer
            view = objc.objc_object(ptr=window_id)
            
            # Get the NSWindow from the view
            ns_window = view.window()
            self._ns_window = ns_window
            
            # Create an observer for fullscreen exit events
            self._exit_observer = ExitFullScreenObserver.alloc().initWithWindow_andCallback_(
                ns_window, 
                self._restore_window_style
            )
            
            # Apply window style
            self._restore_window_style(ns_window)
            
        except Exception as e:
            print(f"Error configuring macOS window: {e}")
    
    def _restore_window_style(self, window):
        """Apply window styling, called initially and when exiting fullscreen"""
        try:
            if not window:
                return
                
            # Make the window's title bar transparent
            window.setTitlebarAppearsTransparent_(True)
            
            # Configure title bar style to be hidden but preserve window controls
            window.setStyleMask_(
                window.styleMask() | 
                (1 << 15)  # NSWindowStyleMaskFullSizeContentView - content extends under title bar
            )
            
            # Hide the title text
            window.setTitle_("")
            window.setTitleVisibility_(1)  # NSWindowTitleHidden
            
            # Allow the entire window background to be draggable
            window.setMovableByWindowBackground_(True)
            
            # Eliminate the gap by ensuring content extends to window edges
            # Set the title bar to zero height
            window.setContentLayoutRect_(window.contentLayoutRect())
            
            # Adjust the layout guides to eliminate the gap
            if hasattr(window, 'standardWindowButton_'):
                for btn_type in range(3):  # NSWindowCloseButton, NSWindowMiniaturizeButton, NSWindowZoomButton
                    if btn := window.standardWindowButton_(btn_type):
                        btn.setFrameOrigin_((btn.frame().origin.x, 8.0))
                        
        except Exception as e:
            print(f"Error restoring window style: {e}")
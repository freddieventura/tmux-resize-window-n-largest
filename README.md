# Tmux Resize Window N Largest

This plugin will let you set the window size automatic , with aggressive resizing to Largest connected client or second largest or third largest, ... or n largest

## Tmux behaviour

Understanding the different options to be setted up that alter Window Size behaviour on tmux is key to understand its current limitations and what this plugin does.

In a nutshell according to `man tmux` this is the first option that determines that

```
     Available window options are: 
     window-size largest | smallest | manual | latest  
     aggressive-resize [on | off] 
```

By default you can check the values by

```
display -p "#{window-size}"
# By default latest
display -p "#{aggressive-resize}"
# By default 1
```

This basically let tmux resize automaticaly the Window Size, anytime you focus on a different window, so it will check all the already connected clients to that Window, and it will resize its Width and Height to the latest Active client.

This is quite a desirable option, knowing that you may have 2 or more clients connected to the same session, or 2 or more Windows Linked ,(or both of them) , viewports may change. So the lastone you have focused in will set the viewport.

But that may not be always the desirable option, in many different scenarios you may want to leave it manual or even to resize it according to other "rules".

For instance (and what it took me to write this plugin) was that I was using 2 clients connected to the same session, one of them in `oneHost` and the other in `otherHost`. `oneHost` has a small viewport (say of 40 x 40) , while `otherHost` has a way larger viewport (say of 208 x 55).
I use `oneHost` to get the keyboard inputs, but in fact I am looking to `otherHost` physical monitor, which shows another client attached to the same session.
The issue is that any time I wanted to use these two hosts together, I had to find out `otherHost` viewport and apply the following command

```
tmux resize-window -x <otherHost-width> -y <otherHost-height>
tmux resize-window -x 208 -y 55
```

With the hassle of having to do it for all the windows of that session.
With the hassle as well of having to find out `otherHost` viewport (sometimes I would use a different `otherHost` with a different viewport , or just resize the viewport)

With this plugin you can just tell tmux to automatically set the window size to either the largest (1), the second largest (2) , third largest (3) , ..., etc

## PLugin Functioning

The plugin works by sorting clients according to either their height or their width, then setting up a hook that resizes the Window anytime there is focus on a window. Resizing it to the Largest, Second Largest, Third Largest.

Note!! , after applying this plugin `#{window-size}` option and `#{aggressive-resize}` option wont have any effect, as the viewport it is now ultimately been setted by the plugin's hook


## Video demo


## Customization

These are the default settings, change any of the parameters accordingly to change the behaviour.

```
set -g @coloured_by_prefix_colour1_prefix 'C-a'
set -g @coloured_by_prefix_colour1_colour 'colour183'

set -g @coloured_by_prefix_colour2_prefix 'C-e'
set -g @coloured_by_prefix_colour2_colour 'colour87'

set -g @coloured_by_prefix_colour3_prefix 'C-b'
set -g @coloured_by_prefix_colour3_colour 'colour2'

set -g @coloured_by_prefix_colour4_prefix 'C-b'
set -g @coloured_by_prefix_colour4_colour 'colour2'

set -g @coloured_by_prefix_colour5_prefix 'C-b'
set -g @coloured_by_prefix_colour5_colour 'colour2'
```

If you want the key binds differ to the prefixes you can set them this way

```
set -g @coloured_by_prefix_colour1_bind 'M-q'
```

That is just an ilustrative example, just note that the key binds are bound to the "Prefix" letter , so in order to activate the keybinds you need to press `<prefix>` first.



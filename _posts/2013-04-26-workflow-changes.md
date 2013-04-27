---
layout: post
title: Workflow Changes
---

Yesterday I was reading through my [Ruby Weekly](http://rubyweekly.com/archive/142.html)
email and got sucked into a
[tmux workflow video](http://confreaks.com/videos/2291-larubyconf2013-impressive-ruby-productivity-with-vim-and-tmux).
Although I have used tmux remotely, this video inspired me to add tmux to my
local workflow. The following is a run down of my configuration, what I find
awesome and what I find annoying.


## Environment

- OSX 10.8.3, Mountain Lion
- [Homebrew](http://mxcl.github.io/homebrew/)
- [iTerm2](http://www.iterm2.com/) ([Dan Lowe explains why](http://tangledhelix.com/blog/2010/11/20/iterm-terminal/))
- [zsh](http://www.zsh.org/) with [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)
- [vim](http://www.vim.org) with the [molokai](https://github.com/tomasr/molokai) theme and plugins managed by [pathogen](https://github.com/tpope/vim-pathogen)

I assume these are installed and configured.


## Tmux

Before getting started I wanted to checkup on iTerm2's native support of
tmux. In the past, support was only available via a custom build of
tmux. This was awkward and weird so I never tried it out. Now they [support](https://code.google.com/p/iterm2/wiki/TmuxIntegration)
the official version of tmux. Whoop!

{% highlight bash %}brew install tmux{% endhighlight %}

In order to get iTerm2 tmux integration, you have to keep a window open
that acts as the session communication channel for the tmux windows and
panes. I
[agree with Dan](http://tangledhelix.com/blog/2012/04/28/iterm2-keymaps-for-tmux/)
and find that this will become annoying fast. Instead, I am not using the
iTerm2 integration and using tmux as is.

I had to start somewhere, so I yanked [Chris Hunt's](http://chrishunt.co/)
[.tmux.conf](https://github.com/chrishunt/dot-files/blob/master/.tmux.conf) and
put it in my home directory.


### Copy-Paste

To use this config and fix copy-paste issues with
tmux on a mac, install
[reattach-to-user-namespace](https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard/blob/master/README.md):

{% highlight bash %}brew install reattach-to-user-namespace{% endhighlight %}

Basically, tmux has it's own pasteboard and is not able to read or write to the
user's pasteboard. This app reattaches tmux to the user's pasteboard.


### Prefix Keybinding

Back in the day I used ^Z and ^B as my tmux prefix key. I'm not a
fan of finger gymnastics and changed it to ^A. Many people suggested
this and I found it to be much easier to work with. However, after a
few programming escapdes, I found that ^A was getting in my way.

When I am in tmux with vim, I am not able to increment numbers with ^A.
It's a small thing but I'd rather not retrain my brain to implement a longer
key sequence.

I am also conditioned to being able to go to the beginning of the line in bash
or zsh with ^A. (I could leverage vi-mode but I don't feel like retraining my
brain for that just yet.)

Chris' choice to use ^J as a prefix has made things flow quite nicely.
I haven't found any conflicts yet and I hope I don't find any!

### Pane Keybindings

I like rebinding to characters that match the split action:
{% highlight text %}
# window splitting
unbind %
bind | split-window -h
unbind '"'
bind - split-window -v
{% endhighlight %}

I also like to map vim navigation to pane resizing:
{% highlight text %}
# resize panes
bind -r H resize-pane -L 5
bind -r J resize-pane -D 5
bind -r K resize-pane -U 5
bind -r L resize-pane -R 5
{% endhighlight %}


### Mouse Configuration

After trying this configuration out for awhile, I began to realize that I kept
trying to scroll back with the mouse. So, I needed my mouse to function
according to my habits:

{% highlight text %}
set -g mode-mouse on
set -g mouse-resize-pane on
set -g mouse-select-pane on
set -g mouse-select-window on
{% endhighlight %}

[Dan's mouse mode post](http://tangledhelix.com/blog/2012/07/16/tmux-and-mouse-mode/)
has a pair of useful mouse toggle shortcuts:

{% highlight text %}
bind m \
  set -g mode-mouse on \;\
  set -g mouse-resize-pane on \;\
  set -g mouse-select-pane on \;\
  set -g mouse-select-window on \;\
  display 'Mouse: ON'

bind M \
  set -g mode-mouse off \;\
  set -g mouse-resize-pane off \;\
  set -g mouse-select-pane off \;\
  set -g mouse-select-window off \;\
  display 'Mouse: OFF'
{% endhighlight %}

I am a huge proponent of keeping your fingers on the home row and using
the mouse as little as possible. However, every once in a while I just
want to resize a pane with my mouse or scroll back with my mouse. Having
that extra nicety just feels good.

There is one draw back: mouse mode does not support selection.

When I scroll back to find something and select it, the mouse up event causes
the buffer to jump back to the command prompt and deselects the
selection.

There are two ways around this:

1. Disable mouse mode before selecting text: `^J M`
1. Hold down the option key while selecting text

Both are not ideal but tolerable, given the benefits of tmux.


## iTerm2

What really solidified tmux for me was Dan's
[iterm2 keymaps for tmux](http://tangledhelix.com/blog/2012/04/28/iterm2-keymaps-for-tmux/)
customization. iTerm2's ability to send hex codes definitely causes Angels to
dance.

Here are my key sequences:

<div class="highlight">
  <table class="nowrap">
    <thead>
      <tr>
        <th>Key Sequence</th>
        <th>Hex Sequence</th>
        <th>Purpose</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>^D</td>
        <td>0x04</td>
        <td>disconnect from pane or window</td>
      </tr>
      <tr>
        <td>^J c</td>
        <td>0x0A 0x63</td>
        <td>create new window</td>
      </tr>
      <tr>
        <td>^J d</td>
        <td>0x0A 0x64</td>
        <td>detach from session</td>
      </tr>
      <tr>
        <td>^J &lt;</td>
        <td>0x0A 0x3C</td>
        <td>previous window</td>
      </tr>
      <tr>
        <td>^J &gt;</td>
        <td>0x0A 0x3E</td>
        <td>next window</td>
      </tr>
      <tr>
        <td>^J |</td>
        <td>0x0A 0x7C</td>
        <td>Split pane horizontally</td>
      </tr>
      <tr>
        <td>^J -</td>
        <td>0x0A 0x2D</td>
        <td>Split pane vertically</td>
      </tr>
      <tr>
        <td>^J K</td>
        <td>0x0A 0x4B</td>
        <td>Resize pane up</td>
      </tr>
      <tr>
        <td>^J J</td>
        <td>0x0A 0x4A</td>
        <td>Resize pane down</td>
      </tr>
      <tr>
        <td>^J H</td>
        <td>0x0A 0x48</td>
        <td>Resize pane left</td>
      </tr>
      <tr>
        <td>^J L</td>
        <td>0x0A 0x4C</td>
        <td>Resize pane right</td>
      </tr>
      <tr>
        <td>^J &lt;arrow-up&gt;</td>
        <td>0x0A 0x1B 0x5B 0x41</td>
        <td>move to pane above</td>
      </tr>
      <tr>
        <td>^J &lt;arrow-down&gt;</td>
        <td>0x0A 0x1B 0x5B 0x42</td>
        <td>move to pane below</td>
      </tr>
      <tr>
        <td>^J &lt;arrow-right&gt;</td>
        <td>0x0A 0x1B 0x5B 0x43</td>
        <td>move to pane at right</td>
      </tr>
      <tr>
        <td>^J &lt;arrow-left&gt;</td>
        <td>0x0A 0x1B 0x5B 0x44</td>
        <td>move to pane at left</td>
      </tr>
    </tbody>
  </table>
</div>

<br/>
Here are my iTerm2 tmux shortcuts:

<div class="highlight">
  <table class="nowrap">
    <thead>
      <tr>
        <th>Shortcut</th>
        <th>Hex Sequence</th>
        <th>Purpose</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>Cmd-w</td>
        <td>0x04</td>
        <td>disconnect from pane or window</td>
      </tr>
      <tr>
        <td>Cmd-t</td>
        <td>0x0A 0x63</td>
        <td>create new window</td>
      </tr>
      <tr>
        <td>Cmd-d</td>
        <td>0x0A 0x64</td>
        <td>detach from session</td>
      </tr>
      <tr>
        <td>Cmd-Left</td>
        <td>0x0A 0x3C</td>
        <td>previous window</td>
      </tr>
      <tr>
        <td>Cmd-Shift-h</td>
        <td>0x0A 0x3C</td>
        <td>previous window</td>
      </tr>
      <tr>
        <td>Cmd-Right</td>
        <td>0x0A 0x3E</td>
        <td>next window</td>
      </tr>
      <tr>
        <td>Cmd-Shift-l</td>
        <td>0x0A 0x3E</td>
        <td>next window</td>
      </tr>
      <tr>
        <td>Cmd-Shift-|</td>
        <td>0x0A 0x7C</td>
        <td>Split pane horizontally</td>
      </tr>
      <tr>
        <td>Cmd-Shift-_</td>
        <td>0x0A 0x2D</td>
        <td>Split pane vertically</td>
      </tr>
      <tr>
        <td>Cmd-Opt-k</td>
        <td>0x0A 0x4B</td>
        <td>Resize pane up</td>
      </tr>
      <tr>
        <td>Cmd-Opt-j</td>
        <td>0x0A 0x4A</td>
        <td>Resize pane down</td>
      </tr>
      <tr>
        <td>Cmd-Opt-h</td>
        <td>0x0A 0x48</td>
        <td>Resize pane left</td>
      </tr>
      <tr>
        <td>Cmd-Opt-l</td>
        <td>0x0A 0x4C</td>
        <td>Resize pane right</td>
      </tr>
      <tr>
        <td>Cmd-k</td>
        <td>0x0A 0x1B 0x5B 0x41</td>
        <td>move to pane above</td>
      </tr>
      <tr>
        <td>Cmd-j</td>
        <td>0x0A 0x1B 0x5B 0x42</td>
        <td>move to pane below</td>
      </tr>
      <tr>
        <td>Cmd-l</td>
        <td>0x0A 0x1B 0x5B 0x43</td>
        <td>move to pane at right</td>
      </tr>
      <tr>
        <td>Cmd-h</td>
        <td>0x0A 0x1B 0x5B 0x44</td>
        <td>move to pane at left</td>
      </tr>
    </tbody>
  </table>
</div>

<br />
Here are all of my iTerm2 global shortcuts:

<img alt="iTerm2 Global Shortcuts" src="/static/img/workflow-changes/iterm2-global-shortcuts.png" />

## ZSH

Last but not least I added a few helpful commands to my .zshrc to make
session management a little easier.

<script src="https://gist.github.com/collinwat/5471105.js"></script>

Command completion is always nice, so I added session name completion for my
session function.

Make sure custom command completion is enabled:

{% highlight text %}
fpath=(~/.zsh/completion $fpath)
autoload -U compinit
compinit
{% endhighlight %}

...and add the completion script:
<script src="https://gist.github.com/collinwat/5471102.js"></script>


## Conclusion

Tmux is great at managing sessions and recoving from accidental
disconnects. It still feels in the way at times but new things always
do. It will take some time getting use to but I'm sure it has found a home.

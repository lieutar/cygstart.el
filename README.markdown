  cygstart.el
===============

[w32-browser] (http://www.emacswiki.org/cgi-bin/wiki/w32-browser.el) 
for cygwin emacs.

 Configuration
----------------

Please append following lisp to your .emacs.el.

     (require 'cygstart)
     (require 'dired)
     (define-key dired-mode-map [f3] 'dired-cygstart)
     (define-key dired-mode-map [f4] 'dired-cygstart-explore)
     (define-key dired-mode-map [menu-bar immediate dired-cygstart]
       '("Open Associated Application" . dired-cygstart))
     (define-key dired-mode-map [mouse-2] 'dired-mouse-cygstart)

Of course, these key bindings is only sample.


  See Also
------------

  * [w32-browser] (http://www.emacswiki.org/cgi-bin/wiki/w32-browser.el) 

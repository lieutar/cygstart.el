;;; cygstart.el --- Run Windows application associated with a file

;; Copyright (C) 2011  U-TreeFrog\lieutar

;; Author: U-TreeFrog\lieutar <lieutar@TreeFrog>
;; Keywords: mouse, dired, w32, explorer

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; 

;; Original source code is:
;;       w32-browser.el (C) 2004-2010, Drew Adame, all rights reserved.
;;       http://www.emacswiki.org/cgi-bin/wiki/w32-browser.el

;;; Code:
(when (eq system-type 'cygwin)

  (defcustom cygstart-wait-time 0.1
    "*Delay to wait between `cygstart' in `dired-multiple-cygstart'.
On at least some Windows systems, this delay is needed between calls
to `cygstart' within command `dired-multiple-cygstart'.
Depending on your system, you might be able to set this to 0, meaning
no wait."
    :type 'integer
    :group 'convenience)

  (defcustom cygstart-program-name "cygstart"
    ""
    :type 'string
    :group 'convenience)

  (defcustom cygstart-cygpath-name "cygpath"
    ""
    :type 'string
    :group 'convenience)

  (defcustom cygstart-explorer-name 
    (replace-regexp-in-string
     "\\\\" "/"
     (format "%s/explorer.exe" (getenv "WINDIR")))
    ""
    :type 'string
    :group 'convenience)

  (defun cygstart (file)
    "Run default Windows application associated with FILE.
If no associated application, then `find-file' FILE."
    (interactive "fFile: ")
    (let ((cmd (format "%s \'%s\'" cygstart-program-name file)))
      (or (condition-case err
              (progn
                (shell-command cmd)
                t)
            (error (message "%S" err)))
          (find-file file))))

  (defun dired-cygstart ()
    "Run default Windows application associated with current line's file.
If file is a directory, then `dired-find-file' instead.
If no application is associated with file, then `find-file'."
    (interactive)
    (let ((file  (dired-get-filename nil t)))
      (if (file-directory-p file)
          (dired-find-file)
        (cygstart file))))

  (defun dired-mouse-cygstart (event)
    "Run default Windows application associated with file under mouse.
If file is a directory or no application is associated with file, then
`find-file' instead."
    (interactive "e")
    (let (file)
      (with-current-buffer (window-buffer (posn-window (event-end event)))
        (save-excursion
          (goto-char (posn-point (event-end event)))
          (setq file (dired-get-filename nil t))))
      (select-window (posn-window (event-end event)))
      (if (file-directory-p file)
          (find-file (file-name-sans-versions file t))
        (cygstart (file-name-sans-versions file t)))))

  (defun dired-cygstart-reuse-dir-buffer ()
    "Like `dired-cygstart', but reuse Dired buffers."
    (interactive)
    (let ((file  (dired-get-filename nil t)))
      (if (file-directory-p file)
          (find-alternate-file file)
        (cygstart file))))

  (defun dired-mouse-cygstart-reuse-dir-buffer (event)
    "Like `dired-mouse-cygstart', but reuse Dired buffers."
    (interactive "e")
    (let (file)
      (with-current-buffer (window-buffer (posn-window (event-end event)))
        (save-excursion
          (goto-char (posn-point (event-end event)))
          (setq file (dired-get-filename nil t))))
      (select-window (posn-window (event-end event)))
      (if (file-directory-p file)
          (find-alternate-file (file-name-sans-versions file t))
        (cygstart (file-name-sans-versions file t)))))

  (defun dired-multiple-cygstart ()
    "Run default Windows applications associated with marked files."
    (interactive)
    (let ((files (dired-get-marked-files)))
      (while files
        (cygstart (car files))
        (sleep-for cygstart-wait-time)
        (setq files (cdr files)))))

  (defun cygstart-explore (file)   
    "Open Windows Explorer to FILE (a file or a folder)."
    (interactive "fFile: ")
    (if (file-directory-p file)
        (cygstart file)
      (let ((cmd (format "'%s' '%s' /e,/select,\"$('%s' -w '%s')\""
                         cygstart-program-name
                         cygstart-explorer-name
                         cygstart-cygpath-name
                         file)))
        (shell-command cmd))))

  (defun dired-cygstart-explore ()   
    "Open Windows Explorer to current file or folder."
    (interactive)
    (cygstart-explore (dired-get-filename nil t)))

  (defun dired-mouse-cygstart-explore (event)   
    "Open Windows Explorer to file or folder under mouse."
    (interactive "e")
    (let (file)
      (with-current-buffer (window-buffer (posn-window (event-end event)))
        (save-excursion
          (goto-char (posn-point (event-end event)))
          (setq file (dired-get-filename nil t))))
      (select-window (posn-window (event-end event)))
      (cygstart-explore file)))
)
(provide 'cygstart)
;;; cygstart.el ends here

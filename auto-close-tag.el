;;; auto-close-tag.el --- Automatically add HTML/XML close tag  -*- lexical-binding: t; -*-

;; Copyright (C) 2018  Shen, Jen-Chieh
;; Created date 2018-12-04 17:04:50

;; Author: Shen, Jen-Chieh <jcs090218@gmail.com>
;; URL: https://github.com/jcs-elpa/auto-close-tag
;; Version: 0.0.1
;; Package-Requires: ((emacs "24.4") (cl-lib "0.6"))
;; Keywords: convenience keybindings

;; This file is NOT part of GNU Emacs.

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
;; Automatically add HTML/XML close tag.
;;

;;; Code:

(require 'cl-lib)


(defgroup auto-close-tag nil
  "Automatically add HTML/XML close tag."
  :prefix "auto-close-tag-"
  :group 'tool
  :link '(url-link :tag "Repository" "https://github.com/jcs-elpa/auto-close-tag"))


(defcustom auto-close-tag-excluded-tags '("area"
                                          "base"
                                          "br"
                                          "col"
                                          "command"
                                          "embed"
                                          "hr"
                                          "img"
                                          "input"
                                          "keygen"
                                          "link"
                                          "meta"
                                          "param"
                                          "source"
                                          "track"
                                          "wbr")
  "Tag names you do not want to close."
  :group 'auto-close-tag
  :type 'list)


(defun auto-close-tag-is-contain-list-string (in-list in-str)
  "Check if a string contain in any string in the string list.
IN-LIST : list of string use to check if IN-STR in contain one of
the string.
IN-STR : string using to check if is contain one of the IN-LIST."
  (cl-some #'(lambda (lb-sub-str) (string-match-p (regexp-quote lb-sub-str) in-str)) in-list))

(defun auto-close-tag-is-beginning-of-buffer-p ()
  "Is at the beginning of buffer?"
  (= (point) (point-min)))

(defun auto-close-tag-is-end-of-buffer-p ()
  "Is at the end of buffer?"
  (= (point) (point-max)))

(defun auto-close-tag-current-char-equal-p (c)
  "Check the current character equal to 'C'."
  (if (auto-close-tag-is-beginning-of-buffer-p)
      nil
    (let ((current-char-string (string (char-before))))
      (string= current-char-string c))))

(defun auto-close-tag-backward-goto-char (c)
  "Goto backward character match 'C'."
  (while (and (not (auto-close-tag-is-beginning-of-buffer-p))
              (not (auto-close-tag-current-char-equal-p c)))
    (backward-char 1)))

(defun auto-close-tag-forward-goto-char (c)
  "Goto forward character match 'C'."
  (unless (auto-close-tag-is-end-of-buffer-p)
    (forward-char 1))
  (while (and (not (auto-close-tag-is-end-of-buffer-p))
              (not (auto-close-tag-current-char-equal-p c)))
    (forward-char 1)))

(defun auto-close-tag-backward-char-at-point (c)
  "Search backward for 'C' and return the point.
If not found, return -1."
  (save-excursion
    (auto-close-tag-backward-goto-char c)
    (if (auto-close-tag-current-char-equal-p c)
        (point)
      -1)))

(defun auto-close-tag-forward-char-at-point (c)
  "Search forward for 'C' and return the point.
If not found, return -1."
  (save-excursion
    (auto-close-tag-forward-goto-char c)
    (if (auto-close-tag-current-char-equal-p c)
        (point)
      -1)))

(defun auto-close-tag-inside-tag ()
  "Check if current point inside the tag."
  (let ((backward-less (auto-close-tag-backward-char-at-point "<"))
        (backward-greater (auto-close-tag-backward-char-at-point ">"))
        (forward-less (auto-close-tag-forward-char-at-point "<"))
        (forward-greater (auto-close-tag-forward-char-at-point ">")))
    (and (not (= -1 backward-less))
         (not (= -1 forward-greater))
         (< backward-greater backward-less)
         (or (< forward-greater forward-less)
             (= -1 forward-less)))))

(defun auto-close-tag-goto-backward-tag ()
  "Goto the backward tag."
  (interactive)
  (auto-close-tag-backward-goto-char "<")
  (backward-char 1)
  (while (and (not (auto-close-tag-is-beginning-of-buffer-p))
              (not (auto-close-tag-inside-tag)))
    (auto-close-tag-backward-goto-char "<")))

(defun auto-close-tag-get-tag-name ()
  "Return the tag name."
  (save-excursion
    (let ((tag-name ""))
      (when (auto-close-tag-inside-tag)
        ;; NOTE(jenchieh): Goto the beginning of the tag.
        (forward-char 1)
        (auto-close-tag-backward-goto-char "<")

        (when (auto-close-tag-current-char-equal-p "<")
          (forward-char 1)
          (when (auto-close-tag-current-char-equal-p "/")
            (forward-char 1))
          (setq tag-name (thing-at-point 'word))
          (unless tag-name
            (setq tag-name ""))))
      tag-name)))

(defun auto-close-tag-goto-backward-tag-not-excluded ()
  "Goto the backward to that are not excluded in the list."
  (auto-close-tag-goto-backward-tag)
  (let ((tag-name (auto-close-tag-get-tag-name)))
    (while (and (not (auto-close-tag-is-beginning-of-buffer-p))
                (auto-close-tag-is-contain-list-string auto-close-tag-excluded-tags
                                                       tag-name))
      (auto-close-tag-goto-backward-tag)
      (setq tag-name (auto-close-tag-get-tag-name)))))

(defun auto-close-tag-backward-count-nested-close-tag (&optional nc dnc)
  "Search backward, return the count of the nested closing tag.
NC : recursive nested count.
DNC : duplicate nested count."
  (save-excursion
    (let ((nested-count 0)
          (current-word "")
          (dup-nested-count 1)
          (is-end-tag nil))
      (when nc
        (setq nested-count nc))
      (when dnc
        (setq dup-nested-count dnc))

      (auto-close-tag-goto-backward-tag)

      (unless (auto-close-tag-is-beginning-of-buffer-p)
        (forward-char 1)

        (setq is-end-tag (auto-close-tag-current-char-equal-p "/"))
        (when is-end-tag
          (forward-char 1))
        ;; If outside of tag, go back then.
        (unless (auto-close-tag-inside-tag)
          (backward-char 1))
        (setq current-word (thing-at-point 'word))

        ;; Ensure `current-word' is something other than nil.
        (unless current-word
          (setq current-word ""))

        (unless (auto-close-tag-is-contain-list-string auto-close-tag-excluded-tags
                                                       current-word)
          (if is-end-tag
              (progn
                (setq nested-count (+ nested-count 1))
                (setq dup-nested-count (+ dup-nested-count 1)))
            (progn
              (setq dup-nested-count (- dup-nested-count 1)))))

        (unless (= dup-nested-count 0)
          (setq nested-count
                (auto-close-tag-backward-count-nested-close-tag nested-count
                                                                dup-nested-count))))
      nested-count)))


(defun auto-close-tag-insert-close-tag (tag-name)
  "Insert the closing tag.
TAG-NAME : name of the tag."
  (let ((insert-tag-name ""))
    ;; Ensure tag-name is a string.
    (when tag-name
      (setq insert-tag-name tag-name))
    (unless (auto-close-tag-is-contain-list-string auto-close-tag-excluded-tags
                                                   insert-tag-name)
      (save-excursion
        (insert (concat "</" insert-tag-name ">"))))))

(defun auto-close-tag-complete-close-tag (tag-name)
  "Insert the closing tag.
TAG-NAME : name of the tag."
  (let ((insert-tag-name ""))
    ;; Ensure tag-name is a string.
    (when tag-name
      (setq insert-tag-name tag-name))
    (unless (auto-close-tag-is-contain-list-string auto-close-tag-excluded-tags
                                                   insert-tag-name)
      (insert (concat insert-tag-name ">")))))


(defun auto-close-tag-post-self-insert-hook ()
  "Do stuff post insert."
  (let ((tag-name "")
        (is-closing nil)
        (do-insert nil))
    (cond (;; NOTE(jenchieh): 62 is the '>' (greater symbol).
           (= last-command-event 62)
           (progn
             ;; Ensure when insert '>' is closing the opening tag.
             (save-excursion
               (backward-char 1)
               (when (auto-close-tag-inside-tag)
                 (setq do-insert t)))
             (when do-insert
               (save-excursion
                 (auto-close-tag-backward-goto-char "<")
                 (setq tag-name (thing-at-point 'word)))
               (auto-close-tag-insert-close-tag tag-name))))
          (;; NOTE(jenchieh): 47 is the '/' (slash symbol).
           (= last-command-event 47)
           (progn
             (save-excursion
               ;; Check if input '</' combination.
               (backward-char 1)
               (setq is-closing (auto-close-tag-current-char-equal-p "<")))

             (when is-closing
               ;; Try to find the corresponding tag.
               (save-excursion
                 (let ((nested-count (auto-close-tag-backward-count-nested-close-tag)))
                   ;; Resolve nested level.
                   (while (not (= nested-count 0))
                     (setq nested-count (- nested-count 1))
                     (auto-close-tag-goto-backward-tag-not-excluded)
                     (auto-close-tag-goto-backward-tag-not-excluded))

                   ;; Head to the target tag.
                   (auto-close-tag-goto-backward-tag)

                   ;; Check found corresponding tag.
                   (unless (auto-close-tag-is-beginning-of-buffer-p)
                     (setq tag-name (thing-at-point 'word)))))
               ;; Complete the tag.
               (auto-close-tag-complete-close-tag tag-name)))))))


(defun auto-close-tag-enable ()
  "Enable `auto-close-tag' in current buffer."
  (add-hook 'post-self-insert-hook #'auto-close-tag-post-self-insert-hook nil t))

(defun auto-close-tag-disable ()
  "Disable `auto-close-tag' in current buffer."
  (remove-hook 'post-self-insert-hook #'auto-close-tag-post-self-insert-hook t))


;;;###autoload
(define-minor-mode auto-close-tag-mode
  "Minor mode 'auto-close-tag' mode."
  :lighter " ACT"
  :group auto-close-tag
  (if auto-close-tag-mode
      (auto-close-tag-enable)
    (auto-close-tag-disable)))

(defun auto-close-tag-turn-on-auto-close-tag-mode ()
  "Turn on the 'auto-close-tag-mode' minor mode."
  (auto-close-tag-mode 1))

;;;###autoload
(define-globalized-minor-mode global-auto-close-tag-mode
  auto-close-tag-mode auto-close-tag-turn-on-auto-close-tag-mode
  :require 'auto-close-tag)


(provide 'auto-close-tag)
;;; auto-close-tag.el ends here

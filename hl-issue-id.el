;;; hl-issue-id.el --- Highlight Issue ID           -*- lexical-binding: t; -*-

;; Copyright (C) 2016  Chunyang Xu

;; Author: Chunyang Xu <mail@xuchunyang.me>
;; Keywords: convenience

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

;; #1 Test 123
;; #2 Test again 123#456

;;; Code:

(defgroup hl-issue-id nil
  "Highlit issue id like #123."
  :group 'font-lock-extra-types)

(defcustom hl-issue-id-activate-in-modes '() ; FIXME: Not working well
  "Major modes in which `hl-issue-mode' should be activated.
This is used by `global-hl-issue-id-mode'."
  :group 'hl-issue-id
  :type '(repeat function))

;;;###autoload
(define-minor-mode hl-issue-id-mode
  "Highlight issue id like #123."
  :lighter " #123"
  (if hl-issue-id-mode
      (font-lock-add-keywords nil '(("#[0-9]+" 0 font-lock-warning-face prepend)) t)
    (font-lock-remove-keywords nil '(("#[0-9]+" 0 font-lock-warning-face prepend))))
  ;; Copied from hl-todo.el
  (when font-lock-mode
    (if (and (fboundp 'font-lock-flush)
             (fboundp 'font-lock-ensure))
        (save-restriction
          (widen)
          (font-lock-flush)
          (font-lock-ensure))
      (with-no-warnings
        (font-lock-fontify-buffer)))))

(defun turn-on-hl-issue-id-mode-if-desired ()
  (when (and (not hl-issue-id-mode)
             (apply #'derived-mode-p hl-issue-id-activate-in-modes))
    (hl-issue-id-mode 1)))

;;;###autoload
(define-globalized-minor-mode global-hl-issue-id-mode
  hl-issue-id-mode turn-on-hl-issue-id-mode-if-desired)

(provide 'hl-issue-id)
;;; hl-issue-id.el ends here

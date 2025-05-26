(buffer-file-name)
(buffer-name)

(current-buffer)
(switch-to-buffer (other-buffer))

(let ((l-b (current-buffer)))
	(progn
		(split-root-window-right)
		(switch-to-buffer (get-buffer "*scratch*"))
		(other-window 1)
		(switch-to-buffer (other-buffer))
		(split-root-window-below)
		(other-window 1)
		(switch-to-buffer l-b)
	))

;; lmao

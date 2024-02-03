;;;  android.el	
;;;  
;;;  David Wuertele	Thu Mar 31 13:01:09 2011

;;;  Steal This Program!!!


;; android-mode
(add-to-list 'load-path "~/lib/android-mode")
(require 'android-mode)
;(defcustom android-mode-sdk-dir "~/lib/android")

(setenv "ANT_HOME" "/opt/home/dave/apache-ant-1.8.2")
(setenv "PATH" (concat "/opt/home/dave/android-sdk-linux_x86/tools:/opt/home/dave/android-sdk-linux_x86/platform-tools:/opt/home/dave/apache-ant-1.8.2/bin:" (getenv "PATH")))

; adb devices
; ant -Dadb.device.arg="-s 015A5E590501D01C" install
; ant -Dadb.device.arg="-s emulator-5554" install

;;; Local Variables:
;;; mode:lisp-interaction
;;; mode:font-lock
;;; End:

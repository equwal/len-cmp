(in-package :asdf-user)
(defsystem :len-cmp
  :name "len-cmp"
  :version      "0.0.1"
  :description  "Efficient comparison of length."
  :author       "Spenser Truex <web@spensertruex.com>"
  :serial       t
  :license      "LicenseRef-CCAI-1.0"
  :components ((:file "length")))

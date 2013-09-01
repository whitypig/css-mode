(defun test-cssm:init ()
  (with-temp-buffer
    (insert-file-contents "../css-mode.el")
    (eval-buffer)))

(defun test-cssm:fixture (filename body)
  (test-cssm:init)
  (with-temp-buffer
    (insert-file-contents-literally filename)
    (goto-char (point-min))
    (let ((cssm-indent-level 2))
      (funcall body))))

(ert-deftest test-cssm:cssm-find-column:on-multiple-selectors ()
  ;; in the css file
  (test-cssm:fixture
   "./test.css"
   (lambda ()
     ;; go to the point where we call cssm-find-out-column
     (should (re-search-forward "^time" nil t))
     (beginning-of-line)
     ;; and test the return value
     (should (= 0 (cssm-find-column "t"))))))

(ert-deftest test-cssm:cssm-find-column:on-first-property ()
  (test-cssm:fixture
   "./test.css"
   (lambda ()
     (should (re-search-forward "margin: 0" nil t))
     (beginning-of-line)
     (should (= 2 (cssm-find-column "m"))))))

(ert-deftest test-cssm:cssm-find-column:on-closing-brace ()
  (test-cssm:fixture
   "./test.css"
   (lambda ()
     (should (re-search-forward "}" nil t))
     (beginning-of-line)
     (should (= 0 (cssm-find-column "}"))))))

(ert-deftest test-cssm:cssm-find-column:on-multiple-values ()
  (test-cssm:fixture
   "./test.css"
   (lambda ()
     (should (re-search-forward "dummy-value" nil t))
     (forward-line)
     (beginning-of-line)
     (should (= 18 (cssm-find-column "\n"))))))

(ert-deftest test-cssm:cssm-find-column:in-pseudo-selector ()
  (test-cssm:fixture
   "./test.css"
   (lambda ()
     (should (re-search-forward "dummy-bg-color" nil t))
     (beginning-of-line)
     (should (= 2 (cssm-find-column "b"))))))

(ert-deftest test-cssm:cssm-find-column:on-closing-brace-with-multi-values ()
  (test-cssm:fixture
   "./test.css"
   (lambda ()
     (should (re-search-forward "another-dummy-value" nil t))
     (forward-line)
     (beginning-of-line)
     (should (= 0 (cssm-find-column "}"))))))

(ert-deftest test-cssm:cssm-find-column:in-html-on-multiple-selectors ()
  ;; in the css file
  (test-cssm:fixture
   "./test.html"
   (lambda ()
     ;; go to the point where we call cssm-find-out-column
     (should (re-search-forward "^[ ]+time" nil t))
     (beginning-of-line)
     ;; and test the return value
     (should (= 6 (cssm-find-column "t"))))))

(ert-deftest test-cssm:cssm-find-column:in-html-on-first-property ()
  (test-cssm:fixture
   "./test.html"
   (lambda ()
     (should (re-search-forward "^[ ]+margin: 0" nil t))
     (beginning-of-line)
     (should (= 8 (cssm-find-column "m"))))))

(ert-deftest test-cssm:cssm-find-column:in-html-on-closing-brace ()
  (test-cssm:fixture
   "./test.html"
   (lambda ()
     (should (re-search-forward "^[ ]+}" nil t))
     (beginning-of-line)
     (should (= 6 (cssm-find-column "}"))))))

(ert-deftest test-cssm:cssm-find-column:in-html-on-multiple-values ()
  (test-cssm:fixture
   "./test.html"
   (lambda ()
     (should (re-search-forward "dummy-value" nil t))
     (forward-line)
     (beginning-of-line)
     (should (= 24 (cssm-find-column "\n"))))))

(ert-deftest test-cssm:cssm-find-column:in-html-on-closing-brace-with-multi-values ()
  (test-cssm:fixture
   "./test.html"
   (lambda ()
     (should (re-search-forward "another-dummy-value" nil t))
     (forward-line)
     (beginning-of-line)
     (should (= 6 (cssm-find-column "}"))))))

(ert-deftest test-cssm:cssm-find-column:in-html-in-pseudo-selector ()
  (test-cssm:fixture
   "./test.html"
   (lambda ()
     (should (re-search-forward "dummy-bg-color"))
     (beginning-of-line)
     (should (= 8 (cssm-find-column "b"))))))

(ert-deftest test-cssm:cssm-find-column:on-topmost-selector-in-style ()
  (test-cssm:fixture
   "./test.noindentation.html"
   (lambda ()
     (should (re-search-forward "<style" nil t))
     (forward-line)
     (beginning-of-line)
     (should (= cssm-indent-level-after-style (cssm-find-column "h"))))))

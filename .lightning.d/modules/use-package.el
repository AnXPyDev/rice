(lightning-load-module "setup-package")

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

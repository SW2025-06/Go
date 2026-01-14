# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo", to: "https://ga.jspm.io/npm:@hotwired/turbo@8.0.20/dist/turbo.es2017-esm.js"

pin_all_from "app/javascript/controllers", under: "controllers"
